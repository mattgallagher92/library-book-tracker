# Function to wait for k8s resources to be ready.
# Sleeps between first and second attempts in case it's caused by the pod not being created
# (otherwise command would fail immediately).
# Args:
#   $(1) - Resource name for display
#   $(2) - Label selector
define wait-for-k8s-resource
	@set -e; \
	for i in 1 2 3 4 5; do \
		if [ $$i -eq 2 ]; then \
			sleep 10; \
		fi; \
		echo "Waiting for $(1) (attempt $$i)..."; \
		if kubectl wait --for=condition=ready pod -l $(2) --timeout=10s; then \
			break; \
		fi; \
		if [ $$i -eq 5 ]; then \
			echo "Timed out waiting for $(1)"; \
			exit 1; \
		fi; \
	done
endef

.PHONY: start-docker-services wait-for-cassandra wait-for-kafka migrate-up migrate-down seed-up seed-down regenerate-proto-go-code run-time-service run-loans-service run-notifications-service run-email-service set-time advance-time-one-hour advance-time-one-day show-book-locations borrow-book k8s-setup k8s-create-cluster k8s-apply-config k8s-build-images k8s-load-images

start-docker-services:
	docker compose up -d

wait-for-cassandra:
	until cqlsh localhost 9042 -e "describe keyspaces;" > /dev/null 2>&1; do \
	  echo "Cassandra is unavailable - sleeping"; \
	  sleep 1; \
	done
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS library WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"
	@echo "Cassandra is up"

wait-for-kafka: start-docker-services
	until docker exec -it library-book-tracker-kafka-1 kafka-topics --bootstrap-server localhost:9092 --list > /dev/null 2>&1; do \
	  echo "Kafka is unavailable - sleeping"; \
	  sleep 1; \
	done
	docker exec -it library-book-tracker-kafka-1 kafka-topics --bootstrap-server localhost:9092 --topic send-email-command --create --if-not-exists -partitions 1 --replication-factor 1
	@echo "Kafka is up"

# NOTE: x-multi-statment breaks the script by semicolons. This will not work if a statement has a semicolon in it.
migrate-up: wait-for-cassandra
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true" -path ./schemas/cassandra/migrations up

migrate-down: wait-for-cassandra
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true" -path ./schemas/cassandra/migrations down

seed-up: migrate-up
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true&x-migrations-table=schema_migrations_seeds" -path ./schemas/cassandra/seeds up

seed-down: wait-for-cassandra
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true&x-migrations-table=schema_migrations_seeds" -path ./schemas/cassandra/seeds down

regenerate-proto-go-code:
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/loans/v1/loans.proto proto/time/v1/time.proto proto/borrower_notification/v1/borrower_notification.proto

run-time-service:
	go run cmd/timeservice/main.go

run-loans-service: wait-for-cassandra
	export SIMULATE_TIME=true && \
	export CASSANDRA_HOSTS=localhost && \
	export CASSANDRA_KEYSPACE=library && \
	go run cmd/loans/main.go

run-notifications-service: wait-for-cassandra wait-for-kafka
	export SIMULATE_TIME=true && \
	export CASSANDRA_HOSTS=localhost && \
	export CASSANDRA_KEYSPACE=library && \
	export KAFKA_BROKERS=localhost:9092 && \
	go run cmd/borrower_notifications/main.go -interval 5

run-email-service: wait-for-kafka
	KAFKA_BROKERS=localhost:9092 go run cmd/email/main.go

set-time:
	@echo "Enter timestamp in RFC3339 format (e.g., 2024-01-01T00:00:00Z):"
	@read -p "> " timestamp; \
	grpcurl -plaintext -d "{\"timestamp\": \"$$timestamp\"}" localhost:50052 time.v1.TimeService/SetTime

advance-time-one-hour:
	grpcurl -plaintext -d '{"seconds": 3600}' localhost:50052 time.v1.TimeService/AdvanceBy

advance-time-one-day:
	grpcurl -plaintext -d '{"seconds": 86400}' localhost:50052 time.v1.TimeService/AdvanceBy

show-book-locations:
	watch -n 1 "cqlsh -e 'SELECT * FROM library.book_locations;'"

borrow-book:
	@read -p "borrower_id (e.g. 08a5a2d0-a062-4e38-b9da-d328e5fc4a12): " borrower_id; \
	read -p "book_id (e.g. 2a161877-ba45-4ce3-bbeb-1a279116a723): " book_id; \
	grpcurl -plaintext -d "{\"borrower_id\": \"$$borrower_id\", \"book_id\": \"$$book_id\"}" localhost:50051 loans.v1.LoansService/BorrowBook

# Kubernetes setup targets
k8s-setup: k8s-create-cluster k8s-build-images k8s-load-images k8s-apply-config

k8s-create-cluster:
	@if ! kind get clusters | grep -q "^library-system$$"; then \
		echo "Creating Kubernetes cluster..."; \
		kind create cluster --config k8s/kind-config.yaml; \
	else \
		echo "Cluster already exists"; \
	fi

k8s-build-images:
	docker build -t loans:latest -f build/loans/Dockerfile .
	docker build -t borrower-notifications:latest -f build/borrower-notifications/Dockerfile .
	docker build -t email:latest -f build/email/Dockerfile .

k8s-pull-images:
	docker pull cassandra:5.0.3
	docker pull confluentinc/cp-zookeeper:7.9.0
	docker pull confluentinc/cp-kafka:7.9.0

k8s-load-images:
	kind load docker-image loans:latest --name library-system
	kind load docker-image borrower-notifications:latest --name library-system
	kind load docker-image email:latest --name library-system
	kind load docker-image cassandra:5.0.3 --name library-system
	kind load docker-image confluentinc/cp-zookeeper:7.9.0 --name library-system
	kind load docker-image confluentinc/cp-kafka:7.9.0 --name library-system

k8s-apply-config:
	kubectl apply -f k8s/cassandra/statefulset.yaml
	kubectl apply -f k8s/kafka/statefulset.yaml
	kubectl apply -f k8s/configmaps/environment.yaml
	@echo "Waiting for infrastructure services..."
	$(call wait-for-k8s-resource,Cassandra,app=cassandra)
	$(call wait-for-k8s-resource,Zookeeper,app=zookeeper)
	$(call wait-for-k8s-resource,Kafka,app=kafka)
	@echo "Deploying application services..."
	kubectl apply -f k8s/services/loans.yaml
	kubectl apply -f k8s/services/borrower-notifications.yaml
	kubectl apply -f k8s/services/email.yaml
	@echo "Waiting for application services..."
	$(call wait-for-k8s-resource,Loans service,app=loans)
	$(call wait-for-k8s-resource,Borrower Notifications service,app=borrower-notifications)
	$(call wait-for-k8s-resource,Email service,app=email)

k8s-forward-ports-cassandra:
	@trap 'kill $$!' EXIT; \
	kubectl port-forward service/infra-cassandra 9042:9042

k8s-forward-ports-loans:
	@trap 'kill $$!' EXIT; \
	kubectl port-forward service/loans 50051:50051


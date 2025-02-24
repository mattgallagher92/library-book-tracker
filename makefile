.PHONY: start-docker-services wait-for-cassandra wait-for-kafka migrate-up migrate-down seed-up seed-down regenerate-proto-go-code run-time-service run-loans-service run-notifications-service run-email-service set-time advance-time-one-hour advance-time-one-day show-book-locations borrow-book

start-docker-services:
	docker compose up -d

wait-for-cassandra: start-docker-services
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

.PHONY: wait-for-cassandra init-keyspace migrate-up migrate-down

start-docker-services:
	docker compose up -d

wait-for-cassandra: start-docker-services
	until cqlsh localhost 9042 -e "describe keyspaces;" > /dev/null 2>&1; do \
	  echo "Cassandra is unavailable - sleeping"; \
	  sleep 1; \
	done
	@echo "Cassandra is up"

init-keyspace: wait-for-cassandra
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS library WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

# NOTE: x-multi-statment breaks the script by semicolons. This will not work if a statement has a semicolon in it.
migrate-up: init-keyspace
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true" -path ./schemas/cassandra/migrations up

migrate-down: init-keyspace
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true" -path ./schemas/cassandra/migrations down

seed-up: migrate-up
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true&x-migrations-table=schema_migrations_seeds" -path ./schemas/cassandra/seeds up

seed-down: init-keyspace
	migrate -database "cassandra://localhost:9042/library?x-multi-statement=true&x-migrations-table=schema_migrations_seeds" -path ./schemas/cassandra/seeds down

regenerate-proto-go-code:
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/loans/v1/loans.proto proto/time/v1/time.proto

run-loans-service: wait-for-cassandra
	export SIMULATE_TIME=true && \
	export CASSANDRA_HOSTS=localhost && \
	export CASSANDRA_KEYSPACE=library && \
	go run cmd/loans/main.go

run-time-service:
	go run cmd/timeservice/main.go

set-time:
	@echo "Enter timestamp in RFC3339 format (e.g., 2024-01-01T00:00:00Z):"
	@read -p "> " timestamp; \
	grpcurl -plaintext -d "{\"timestamp\": \"$$timestamp\"}" localhost:50052 time.v1.TimeService/SetTime

advance-time-one-hour:
	grpcurl -plaintext -d '{"seconds": 3600}' localhost:50052 time.v1.TimeService/AdvanceBy

advance-time-one-day:
	grpcurl -plaintext -d '{"seconds": 86400}' localhost:50052 time.v1.TimeService/AdvanceBy

borrow-book:
	@read -p "borrower_id (e.g. 08a5a2d0-a062-4e38-b9da-d328e5fc4a12): " borrower_id; \
	read -p "book_id (e.g. 2a161877-ba45-4ce3-bbeb-1a279116a723): " book_id; \
	grpcurl -plaintext -d "{\"borrower_id\": \"$$borrower_id\", \"book_id\": \"$$book_id\"}" localhost:50051 loans.v1.LoansService/BorrowBook

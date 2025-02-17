.PHONY: wait-for-cassandra init-keyspace migrate-up migrate-down

start-docker-services:
	docker compose up -d

wait-for-cassandra: start-docker-services
	until cqlsh localhost 9042 -e "describe keyspaces;" > /dev/null 2>&1; do \
	  echo "Cassandra is unavailable - sleeping"; \
	  sleep 1; \
	done
	echo "Cassandra is up"

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
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/loans/v1/loans.proto

run-loans-service: wait-for-cassandra
	export CASSANDRA_HOSTS=localhost && \
	export CASSANDRA_KEYSPACE=library && \
	go run cmd/loans/main.go


.PHONY: migrate-up migrate-down wait-for-cassandra init-keyspace

init-keyspace:
	./scripts/wait-for-cassandra.sh && \
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS library WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

migrate-up: init-keyspace
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations up

migrate-down:
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations down


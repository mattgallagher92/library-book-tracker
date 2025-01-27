.PHONY: migrate-up migrate-down wait-for-cassandra

migrate-up:
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations up

migrate-down:
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations down


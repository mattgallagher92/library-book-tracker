.PHONY: migrate-up migrate-down wait-for-cassandra init-keyspace

wait-for-cassandra:
	until cqlsh localhost 9042 -e "describe keyspaces;" > /dev/null 2>&1; do \
	  echo "Cassandra is unavailable - sleeping"; \
	  sleep 1; \
	done
	echo "Cassandra is up - executing migrations"

init-keyspace: wait-for-cassandra
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS library WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

migrate-up: init-keyspace
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations up

migrate-down: init-keyspace
	./scripts/wait-for-cassandra.sh && \
	migrate -database "cassandra://localhost:9042/library" -path ./schemas/cassandra/migrations down


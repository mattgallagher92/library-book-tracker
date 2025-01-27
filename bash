until cqlsh localhost 9042 -e "describe keyspaces;" > /dev/null 2>&1; do
  echo "Cassandra is unavailable - sleeping"
  sleep 1
done
echo "Cassandra is up - executing migrations"

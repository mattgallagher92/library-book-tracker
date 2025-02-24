package config

import (
	"fmt"
	"os"
)

// Config holds all configuration for the service
type Config struct {
	CassandraHosts []string
	Keyspace       string
	KafkaBrokers   []string
}

// Load returns a Config populated from environment variables
func Load() (*Config, error) {
	hosts := os.Getenv("CASSANDRA_HOSTS")
	if hosts == "" {
		return nil, fmt.Errorf("CASSANDRA_HOSTS environment variable is required")
	}

	keyspace := os.Getenv("CASSANDRA_KEYSPACE")
	if keyspace == "" {
		return nil, fmt.Errorf("CASSANDRA_KEYSPACE environment variable is required")
	}

	brokers := os.Getenv("KAFKA_BROKERS")
	if brokers == "" {
		return nil, fmt.Errorf("KAFKA_BROKERS environment variable is required")
	}

	return &Config{
		CassandraHosts: []string{hosts}, // For now just support single host
		Keyspace:       keyspace,
		KafkaBrokers:   []string{brokers}, // For now just support single broker
	}, nil
}

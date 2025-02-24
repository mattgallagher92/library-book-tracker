package config

import (
	"fmt"
	"os"
)

// EmailConfig contains configuration specific to the email service
type EmailConfig struct {
	KafkaBrokers []string
}

// LoansConfig contains configuration specific to the loans service
type LoansConfig struct {
	CassandraHosts []string
	Keyspace       string
}

// NotificationsConfig contains configuration specific to the notifications service
type NotificationsConfig struct {
	CassandraHosts []string
	Keyspace       string
	KafkaBrokers   []string
}

func LoadEmailConfig() (*EmailConfig, error) {
	brokers := os.Getenv("KAFKA_BROKERS")
	if brokers == "" {
		return nil, fmt.Errorf("KAFKA_BROKERS environment variable is required")
	}

	return &EmailConfig{
		KafkaBrokers: []string{brokers}, // For now just support single broker
	}, nil
}

func LoadLoansConfig() (*LoansConfig, error) {
	hosts := os.Getenv("CASSANDRA_HOSTS")
	if hosts == "" {
		return nil, fmt.Errorf("CASSANDRA_HOSTS environment variable is required")
	}

	keyspace := os.Getenv("CASSANDRA_KEYSPACE")
	if keyspace == "" {
		return nil, fmt.Errorf("CASSANDRA_KEYSPACE environment variable is required")
	}

	return &LoansConfig{
		CassandraHosts: []string{hosts}, // For now just support single host
		Keyspace:       keyspace,
	}, nil
}

func LoadNotificationsConfig() (*NotificationsConfig, error) {
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

	return &NotificationsConfig{
		CassandraHosts: []string{hosts}, // For now just support single host
		Keyspace:       keyspace,
		KafkaBrokers:   []string{brokers}, // For now just support single broker
	}, nil
}

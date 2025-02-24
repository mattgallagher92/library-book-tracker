package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/IBM/sarama"
	"github.com/linkedin/goavro/v2"
)

func main() {
	log.Println("Email service starting...")

	// Load and parse Avro schema
	schemaFile, err := os.ReadFile("schemas/avro/commands/send_email.avsc")
	if err != nil {
		log.Fatalf("Failed to read Avro schema: %v", err)
	}
	codec, err := goavro.NewCodec(string(schemaFile))
	if err != nil {
		log.Fatalf("Failed to parse Avro schema: %v", err)
	}

	// Configure Kafka consumer
	config := sarama.NewConfig()
	config.Consumer.Group.Rebalance.Strategy = sarama.NewBalanceStrategyRoundRobin()
	config.Consumer.Offsets.Initial = sarama.OffsetNewest

	// Create consumer group
	group, err := sarama.NewConsumerGroup([]string{"localhost:9092"}, "email-service", config)
	if err != nil {
		log.Fatalf("Failed to create consumer group: %v", err)
	}
	defer group.Close()

	// Handle shutdown gracefully
	ctx, cancel := context.WithCancel(context.Background())
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		<-signals
		cancel()
	}()

	// Create consumer handler
	handler := &ConsumerGroupHandler{
		codec: codec,
	}

	// Consume messages
	for {
		err := group.Consume(ctx, []string{"send-email-command"}, handler)
		if err != nil {
			if ctx.Err() != nil {
				// Context was cancelled, time to exit
				break
			}
			log.Printf("Error from consumer: %v", err)
		}
	}

	log.Println("Email service shutting down...")
}

// ConsumerGroupHandler implements sarama.ConsumerGroupHandler
type ConsumerGroupHandler struct {
	codec *goavro.Codec
}

func (h *ConsumerGroupHandler) Setup(_ sarama.ConsumerGroupSession) error   { return nil }
func (h *ConsumerGroupHandler) Cleanup(_ sarama.ConsumerGroupSession) error { return nil }

func (h *ConsumerGroupHandler) ConsumeClaim(session sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	for message := range claim.Messages() {
		// Deserialize Avro message
		native, _, err := h.codec.NativeFromBinary(message.Value)
		if err != nil {
			log.Printf("Failed to deserialize message: %v", err)
			continue
		}

		record, ok := native.(map[string]interface{})
		if !ok {
			log.Printf("Unexpected message format")
			continue
		}

		// Log the email details
		log.Printf("sending email...\nTo: %v\nSubject: %v\nBody: %v",
			record["toAddress"],
			record["subject"],
			record["body"])

		// Mark message as processed
		session.MarkMessage(message, "")
	}
	return nil
}

# Library book tracker

## Repo purpose

This repo contains the code for an application whose main purpose is for me to explore the following technologies:

- Go
- Kubernetes
- Apache Cassandra
- Apache Kafka
- Envoy Proxy

The features of the application are secondary, so I'm happy for the architecture to be massively over-engineered for the actual problem domain (which it is). I want an architecture that fits well with the above technologies and am willing to pay the complexity cost, even though the availability and scalability that they provide is unlikely to be necessary without an extremely large user base.

Nevertheless, I have tried to choose a problem domain for which a service-oriented architecture with asynchronous message passing makes sense, since most of the above technologies are only really useful in that setting.

## Problem description

In order to run a library effectively, it is necessary to allow staff to see and update the locations of books and allow people to borrow and return books. In addition, it is useful to notify people before they need to take action, for example return books to the library by depositing them in a self-service terminal's storage bin or empty a storage bin and replace books onto shelves.

More details are available in [the specification](./docs/spec.md).

## Local development

Start background services, such as Cassandra, with

```sh
docker compose up -d
```

### Database Migrations

To run the migrations:
```sh
make migrate-up
```

To rollback migrations:
```sh
make migrate-down
```

Both commands will ensure the keyspace exists before proceeding.

### Testing gRPC Endpoints

For local development, you can use `grpcurl` to test the gRPC endpoints. First, install it:

```sh
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

List available services:
```sh
grpcurl -plaintext localhost:50051 list
```

Borrow a book (replace UUIDs with valid values):
```sh
grpcurl -plaintext -d '{"borrower_id": "123e4567-e89b-12d3-a456-426614174000", "book_id": "987fcdeb-51d3-12d3-a456-426614174000"}' \
    localhost:50051 loans.v1.LoansService/BorrowBook
```

Note: gRPC reflection is enabled by default in development mode to support these commands. In production, reflection is disabled for security.

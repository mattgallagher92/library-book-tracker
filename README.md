# Library book tracker

## Repo purpose

This repo contains the code for an application whose main purpose is for me to explore the following technologies:

- Go
- Kubernetes
- Apache Cassandra
- Apache Kafka
- Envoy Proxy

The features and correctness of the application are secondary.

### Overengineering

Since features are secondary, I'm happy for the architecture to be massively over-engineered for the actual problem domain (which it is). I want an architecture that fits well with the above technologies and am willing to pay the complexity cost, even though the availability and scalability that they provide is unlikely to be necessary without an extremely large user base.

Nevertheless, I have tried to choose a problem domain for which a service-oriented architecture with asynchronous message passing makes sense, since most of the above technologies are only really useful in that setting.

### Incomplete command validation

Because this repo is about learning technologies, I've decided not to worry about handling all possible error cases; for example, there is no check when borrowing a book that the book isn't already borrowed by somebody else. Handling all error cases would be time consuming and wouldn't teach me more about the tech that I'm interested in.

## Problem description

In order to run a library effectively, it is necessary to allow staff to see and update the locations of books and allow people to borrow and return books. In addition, it is useful to notify people before they need to take action, for example return books to the library by depositing them in a self-service terminal's storage bin or empty a storage bin and replace books onto shelves.

More details are available in [the specification](./docs/spec.md).

## Local development

### Install required tools

```sh
nix develop
```

### Run common tasks

`./makefile` contains targets for various development tasks, including:

- Starting docker services defined in `./docker-compose.yml`
- Migrating the local database with migrations in `./schemas/cassandra/migrations/`
- Seeding the local database with scripts in `./schemas/cassandra/seeds/`
- Running services written in Go, such as the one defined in `./cmd/loans/main.go`

Run targets using, `make <target-name>`. For example, the following command starts the loans service:

```sh
make run-loans-service
```

### Testing gRPC Endpoints

For local development, you can use `grpcurl` to test the gRPC endpoints.

List available services:
```sh
grpcurl -plaintext localhost:50051 list
```

Borrow a book (replace UUIDs with valid values):
```sh
grpcurl -plaintext -d '{"borrower_id": "08a5a2d0-a062-4e38-b9da-d328e5fc4a12", "book_id": "2a161877-ba45-4ce3-bbeb-1a279116a723"}' \
    localhost:50051 loans.v1.LoansService/BorrowBook
```

Note: gRPC reflection is enabled by default in development mode to support these commands. In production, reflection is disabled for security.

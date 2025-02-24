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

### Prerequisites

- [Docker](https://www.docker.com/get-started/)
- The [nix package manager](https://nixos.org/download/)

### Install required CLI tools

```sh
nix develop
```

### Run common tasks

`./makefile` contains targets for various development tasks, including:

- Starting docker services defined in `./docker-compose.yml`
- Migrating the local database with migrations in `./schemas/cassandra/migrations/`
- Seeding the local database with scripts in `./schemas/cassandra/seeds/`
- Running services written in Go, such as the one defined in `./cmd/loans/main.go`
- Invoking endpoints (via `grpcurl`), such as `BorrowBook`

Run targets using, `make <target-name>`. For example, the following command starts the loans service:

```sh
make run-loans-service
```
### See the app in action

Seed the database with some test data with `make seed-up`, then run the following in different terminals:

- `make run-loans-service`
- `make run-notifications-service`
- `make run-email-service`
- `make run-time-service`
- `make show-book-locations`

In another terminal, run the following in order:

- `make set-time` to set the date to 2025-02-01.
- `make borrow-book` to borrow a book (you can use the example UUIDs); notice the logs from the loans service and how the shown book location has changed.
- `make set-time` to set the date to 2025-02-05; notice the logs from the notifications and email services.

## Development roadmap

- Implement book returns in the loans service
- Publish book returned events from the loans service
- Set up the book inventory service to listen for book returned events and publish low bin capacity notifications
- Set up the pager service to listen for low capacity events and "page" librarians (mock implementation)
- Handle book move commands (bin to trolley, trolley to shelves) in the book inventory service
- Manage services in Kubernetes
- Use Envoy Proxy

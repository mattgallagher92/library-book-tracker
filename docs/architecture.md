# Application architecture

> [!NOTE]
> If the system were being designed to acheive additional non-functional requirements such as automated scaling, high availability and minimal latency, there would be various other components required such as load balancers, reverse proxies and in-memory caches. Those would all be valuable components to have, but to avoid too much complexity early on I'm focusing on the components required to achieve the functional requirements.

## Key questions

### What is the system of record?

Since Cassandra and Kafka can both be used as durable data stores, any data that is in both must be kept (eventually) consistent. To make this work, it makes sense to consider one the system of record and the other containing derived data, at least for any one piece of information. To keep things simpler, it probably makes sense to make a consistent choice across the whole application. This leaves two options:

1. Make Kafka the system of record, capturing information in events and having dedicated services read the event streams and update Cassandra's tables accordingly.
2. Make Cassandra the system of record and only use Kafka for message brokerage (potentially publishing messages in response to changes to the database).

As someone used to relational databases, Cassandra's "lightweight transactions" don't offer the ACID properties that I would like, particularly given data isn't normalized. Using Kafka here to provide atomicity is therefore tempting (an event is either durably published or it isn't). However, one problem with deriving the tables is that it opens up other potential issues such as a user not seeing the effect of their own writes immediately.

Introducing event sourcing in what's an already very unfamiliar stack seems like a step too far for the moment, so I'll go with option 2. This is all just about learning anyway.

## Infrastructure

- Shared database (Cassandra)
- Event streaming platform (Kafka)
- Service mesh sidecars (Envoy Proxy)
- Container orchestration (Kubernetes)

## Services

- Book inventory service: handles registration of newly-acquired books (not implemented; data seeded with migrations) and their movement around the library.
- Borrower service: handles management of borrower details. (Not implemented; data seeded with migrations)
- Loans service: handles checking out and returning books.
- Self-service terminal service: provides UI for self-service terminal.
- Librarian portal service: provides UI for librarians.
- Borrower notification service: checks, on a schedule (daily), whether borrowers should recieve notifications.
- Email service: sends emails.
- Pager service: sends pager messages.

## Inter-service communication

### RPC

- Self-service terminal service -> loans service: borrow book command; response indicates whether the borrower was allowed to borrow the book or not.
- Self-service teminal service -> loans service: return book command; response indicates operation success.
- Self-service terminal service -> book inventory service: storage bin emptied onto trolley command.
- Librarian portal service -> book inventory service: books moved from trolley to shelves command.
- Librarian portal service -> book inventory service: full inventory location query; response includes location of all inventory.

### Asynchronous message passing

- Loans service -> book inventory service: book returned event.
- Book inventory service -> pager service: bin capacity low notification.
- Borrower notification service -> email service: book due soon notification.


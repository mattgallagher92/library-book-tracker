FROM golang:1.23-alpine AS builder

WORKDIR /app
COPY . .

RUN go build -o borrower-notifications ./cmd/borrower_notifications

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/borrower-notifications .

EXPOSE 50052
CMD ["./borrower-notifications"]

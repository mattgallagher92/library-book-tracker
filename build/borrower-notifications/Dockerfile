FROM golang:1.23-alpine AS builder

WORKDIR /app
COPY ./cmd/ ./cmd/
COPY ./internal/ ./internal/
COPY ./proto/ ./proto/
COPY ./go.mod ./go.mod
COPY ./go.sum ./go.sum

RUN go build -o borrower-notifications ./cmd/borrower_notifications

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/borrower-notifications .

EXPOSE 50052
CMD ["./borrower-notifications"]

FROM golang:1.23-alpine AS builder

WORKDIR /app
COPY ./cmd/ ./cmd/
COPY ./internal/ ./internal/
COPY ./proto/ ./proto/
COPY ./go.mod ./go.mod
COPY ./go.sum ./go.sum

RUN go build -o email ./cmd/email

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/email .
COPY ./schemas/avro/commands/send_email.avsc ./schemas/avro/commands/send_email.avsc

CMD ["./email"]

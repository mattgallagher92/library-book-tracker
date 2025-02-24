FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY . .

RUN go build -o loans ./cmd/loans

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/loans .

EXPOSE 50051
CMD ["./loans"]

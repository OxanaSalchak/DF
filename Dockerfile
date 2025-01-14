
FROM golang:1.22.0 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy

RUN go build -o myapp .

RUN GOOS=linux GOARCH=amd64 go build -o myapp .

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache libc6-compat

COPY tracker.db .

COPY --from=builder /app/myapp .

CMD ["./myapp"]

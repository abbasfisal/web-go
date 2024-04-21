# builder stage
FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# deploy stage
FROM alpine:latest AS deploy
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]

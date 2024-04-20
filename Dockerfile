# Stage 1: Build the Go binary
FROM golang:latest AS builder

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the entire project
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Stage 2: Create a minimal runtime image
FROM alpine:latest

# Generate certificate
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the built Go binary from the builder stage
COPY --from=builder /app/app .

# Expose port 8080
EXPOSE 8080

# Command to run the executable
CMD ["./app"]

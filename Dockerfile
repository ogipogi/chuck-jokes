## We specify the base image we need for our
## go application
FROM golang:1.18.1-alpine AS builder

ARG VERSION=dev
## We create an /app directory within our
## image that will hold our application source
## files
RUN mkdir /app
## We copy everything in the root directory
## into our /app directory
ADD . /a
## We ecify that we now wish to execute
## any further commands inside our /app
## directory
WORKDIR /app

## Add this go mod download command to pull in any dependencies
RUN go mod download
## we run go build to compile the binary
## executable of our Go program

RUN go build -o main -ldflags=-X=main.version=${VERSION} main.go

FROM alpine:latest as production

COPY --from=builder /app .

## Our start command which kicks off
## our newly created binary executable
CMD ["./main"]
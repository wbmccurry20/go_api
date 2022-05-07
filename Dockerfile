FROM golang:1.18-alpine AS base
WORKDIR /go/src/go_api

ENV GO111MODULE="on"
ENV GOOS="linux"
ENV CGO_ENABLED=0

RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    curl \
    tzdata \
    git \
    && update-ca-certificates

FROM base AS dev
WORKDIR /go/src/go_api

RUN go install github.com/cosmtrek/air@latest && go install github.com/go-delve/delve/cmd/dlv@latest
EXPOSE 8080
EXPOSE 2345

ENTRYPOINT ["air"]

FROM base AS builder
WORKDIR /go/src/go_api

COPY . /go/src/go_api
RUN go mod download \
    && go mod verify

RUN go build -o todo -a .

FROM alpine:latest as prod

COPY --from=builder /go/src/go_api /usr/local/bin/go_api
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/todo"]
FROM golang:1.12-alpine

MAINTAINER tg: @jnovikov

RUN apk update && apk add git gcc musl-dev

ADD ./go.mod /app/go.mod
ADD ./go.sum /app/go.sum

WORKDIR /app

RUN go mod download

ADD . /app

RUN go build .

ENTRYPOINT ["./planetzor"]

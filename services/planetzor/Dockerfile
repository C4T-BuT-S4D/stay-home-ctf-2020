FROM golang:1.12-alpine

RUN apk update && apk add git gcc musl-dev

ADD ./go.mod /app/go.mod
ADD ./go.sum /app/go.sum

WORKDIR /app

RUN go mod download

ADD . /app

RUN go build .

USER nobody

ENTRYPOINT ["./planetzor"]

FROM ubuntu:18.04

RUN apt update && apt install -y gcc-multilib make fcgiwrap

ADD ./Makefile /app/Makefile
ADD ./src /app/src
WORKDIR /app

RUN make all

CMD ["fcgiwrap", "-c", "32", "-s", "tcp:0.0.0.0:31337", "-p", "/app/main"]

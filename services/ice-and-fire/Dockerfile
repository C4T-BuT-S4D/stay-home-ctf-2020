FROM ubuntu:18.04

RUN apt update && apt install -y gcc-multilib binutils fcgiwrap

ADD ./src /app
WORKDIR /app

RUN gcc -m32 -O3 hello.S -o hello

CMD ["fcgiwrap", "-c", "32", "-s", "tcp:0.0.0.0:31337", "-p", "/app/hello"]

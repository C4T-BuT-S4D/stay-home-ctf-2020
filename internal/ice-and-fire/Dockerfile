FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y gcc-multilib make fcgiwrap && \
    rm -rf /var/lib/apt/lists/*

ADD hiredis /hiredis
WORKDIR /hiredis
RUN CFLAGS="-m32" LDFLAGS="-m32" make && make install && ldconfig

ADD cJSON /cJSON
WORKDIR /cJSON
RUN CFLAGS="-m32" LDFLAGS="-m32" make && make install && ldconfig

WORKDIR /

RUN rm -rf /hiredis
RUN rm -rf /cJSON

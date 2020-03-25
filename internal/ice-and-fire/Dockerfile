FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y pkg-config g++-multilib gcc-multilib make fcgiwrap autoconf automake libtool unzip && \
    rm -rf /var/lib/apt/lists/*

ADD hiredis /hiredis
WORKDIR /hiredis
RUN CFLAGS="-m32" LDFLAGS="-m32" make
RUN make install
RUN ldconfig

ADD protobuf-3.11.4 /protobuf-3.11.4
WORKDIR /protobuf-3.11.4
RUN ./configure --host=i686-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
RUN make
RUN make install
RUN ldconfig

ADD protobuf-c-1.3.3 /protobuf-c-1.3.3
WORKDIR /protobuf-c-1.3.3
RUN ./autogen.sh
RUN ./configure --host=i686-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
RUN make
RUN make install
RUN ldconfig

WORKDIR /

RUN rm -rf /hiredis
RUN rm -rf /protobuf-3.11.4
RUN rm -rf /protobuf-c-1.3.3
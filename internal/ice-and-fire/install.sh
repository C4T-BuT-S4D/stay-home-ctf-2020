#!/bin/bash

set +e

echo "[*] Installing required packages..."
apt-get update && apt-get install -y \
    wget \
    pkg-config \
    g++-multilib \
    gcc-multilib \
    make \
    autoconf \
    automake \
    libtool

echo "[*] Downloading hiredis..."
wget -q https://github.com/redis/hiredis/archive/v0.14.1.tar.gz -O /hiredis-0.14.1.tar.gz 
tar -C / -xzf /hiredis-0.14.1.tar.gz
rm -f /hiredis-0.14.1.tar.gz

echo "[*] Installing hiredis..."
cd /hiredis-0.14.1
CFLAGS="-m32" LDFLAGS="-m32" make && make install && ldconfig

echo "[*] Downloading protobuf..."
wget -q https://github.com/protocolbuffers/protobuf/archive/v3.11.4.tar.gz -O /protobuf-3.11.4.tar.gz
tar -C / -xzf /protobuf-3.11.4.tar.gz 
rm -f /protobuf-3.11.4.tar.gz

echo "[*] Installing protobuf..."
cd /protobuf-3.11.4
./autogen.sh && ./configure --host=i686-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
make -j4 && make install && ldconfig

echo "[*] Downloading protobuf-c..."
wget -q https://github.com/protobuf-c/protobuf-c/archive/v1.3.3.tar.gz -O /protobuf-c-1.3.3.tar.gz 
tar -C / -xzf /protobuf-c-1.3.3.tar.gz
rm -rf /protobuf-c-1.3.3.tar.gz

echo "[*] Installing protobuf-c..."
cd /protobuf-c-1.3.3
./autogen.sh && ./configure --host=i686-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
make -j4 && make install && ldconfig

echo "[*] Cleaning up..."
cd /
apt-get remove -y \
    wget \
    pkg-config \
    g++-multilib \
    autoconf \
    automake \
    libtool 
apt-get autoremove -y 
rm -rf /var/lib/apt/lists/* 
rm -rf /hiredis-0.14.1
rm -rf /protobuf-3.11.4 
rm -rf /protobuf-c-1.3.3

echo "[+] Done!"

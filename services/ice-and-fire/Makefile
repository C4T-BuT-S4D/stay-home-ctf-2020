CC = gcc
CFLAGS = -m32 -lhiredis -lprotobuf-c -g
SRC = $(wildcard src/*.S src/proto/*.c)

main: $(SRC)
	$(CC) $^ $(CFLAGS) -o $@

all: main

.PHONY: all

CC = gcc
CFLAGS = -m32 -lhiredis -g
SRC = $(wildcard src/*.S)

main: $(SRC)
	$(CC) $^ $(CFLAGS) -o $@

all: main

.PHONY: all

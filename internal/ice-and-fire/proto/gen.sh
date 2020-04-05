#!/usr/bin/env sh

protoc --python_out="." structs.proto
protoc --c_out="." structs.proto

mv structs.pb-c.h structs.pb-c.c ../../../services/ice-and-fire/src/proto
mv structs_pb2.py ../../../checkers/ice-and-fire/proto/
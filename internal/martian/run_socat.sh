#!/bin/bash
socat TCP-LISTEN:9999,reuseaddr,fork EXEC:"./martian"
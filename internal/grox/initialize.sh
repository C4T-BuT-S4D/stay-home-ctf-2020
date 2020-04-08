#!/bin/bash

set -e

cargo build --release
rm -rf src/

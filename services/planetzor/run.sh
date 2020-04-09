#!/bin/sh

set -ex

chown nobody:nogroup -R /data/

exec su -s /bin/sh nobody -c './planetzor'

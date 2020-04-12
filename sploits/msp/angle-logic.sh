#!/usr/bin/env bash

url="$1:5001"

# create a new craft with negative angle
newcraft=$(curl -s $url/launch/ -d '{"phase": 0, "height": 5000, "antenna_focus": -1.57, "narrow_beam_response": "ping", "mass": 100}')
source=$(echo "$newcraft" | jq .id -r)

# just scan surroundings with huge antenna area
for angle in $(seq 1 360); do
  focus=200
  curl -s "$url/beam/$source" -d '{"angle": '$angle', "focus": '$focus'}' | jq .responses[] -r
done

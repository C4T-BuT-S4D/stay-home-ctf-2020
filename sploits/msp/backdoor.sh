# create a new craft
newcraft=$(curl -s localhost:5001/launch/ -d '{"phase": 0, "height": 5000, "antenna_focus": 0.2, "narrow_beam_response": "ping", "mass": 100}')
source=$(echo "$newcraft" | jq .id -r)
sx=$(echo "$newcraft" | jq .position[0] -r)
sy=$(echo "$newcraft" | jq .position[1] -r)

curl localhost:5001/tm/health | jq .stats[] -r | while read target; do

  # find target coords
  coords=$(curl -s localhost:5001/telemetry/$target | jq '(.object.position[0]|tostring) + " " + (.object.position[1]|tostring)' -r)
  tx=$(echo "$coords" | cut -d' ' -f1)
  ty=$(echo "$coords" | cut -d' ' -f2)

  echo "TARGET $target ($tx, $ty)"

  if [[ "$tx" == null ]] || [[ "$ty" == "null" ]]; then
    continue
  fi

  echo "SOURCE $source ($sx, $sy)"

  # return degrees(atan2(source_pos_x-target_pos_x, source_pos_y-target_pos_y) + PI);

  angle=$(python -c "import math; print(math.degrees(math.atan2($sx-$tx, $sy-$ty) + math.pi))")
  focus=$(python -c "import math; print(math.dist(($sx, $sy), ($tx, $ty)) * 0.9)")
  #focus=0

  echo "BEAM $angle $focus"

  curl -s localhost:5001/beam/$source -d '{"angle": '$angle', "focus": '$focus'}' | jq .

done

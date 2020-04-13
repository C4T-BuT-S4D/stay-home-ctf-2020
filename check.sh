#!/bin/bash

declare -A VULNS
VULNS=(
  [grox]=1
  [ice-and-fire]=1
  [martian]=2
  [msp]=2
  [planetzor]=1
  [spacesos]=1
  [exoplanet]=1
)

if [ -z "$RUNS" ]; then
  RUNS=10
fi

if [ -z "$HOST" ]; then
  HOST=127.0.0.1
fi

echo "RUNS=$RUNS"
echo "HOST=$HOST"

print_output() {
  echo "stdout:"
  cat /tmp/checker_stdout
  echo "stderr:"
  cat /tmp/checker_stderr
}

for SERVICE in $SERVICES; do

  if [[ -n "$1" ]] && [[ "$1" != "$SERVICE" ]] && [[ "$1" != "all" ]]; then
    continue
  fi

  CHECKER="./checkers/$SERVICE/checker.py"

  echo "Processing checker '$CHECKER', ${VULNS[$SERVICE]} vulns"
  for ((i = 1; i <= RUNS; i++)); do
    echo "Running test $i..."

    echo "Running CHECK..."
    time "$CHECKER" check $HOST >/tmp/checker_stdout 2>/tmp/checker_stderr
    A=$?
    if [ $A != 101 ]; then
      echo "CHECK failed! Got code $A"
      print_output
      exit 1
    else
      echo "CHECK passed!"
      true
    fi

    for ((j = 1; j <= ${VULNS[$SERVICE]}; j++)); do
      echo "Testing vuln $j..."
      # shellcheck disable=SC2018
      # shellcheck disable=SC2019
      FLAG=$(head -c 23 /dev/urandom | base64 | tr 'a-z' 'A-Z' | tr '+/' 'AB')

      echo "Running PUT..."
      time "$CHECKER" put $HOST 123 "$FLAG" "$j" >/tmp/checker_stdout 2>/tmp/checker_stderr
      A=$?
      if [ $A != 101 ]; then
        echo "PUT failed! Got code $A"
        print_output
        exit 1
      else
        echo "PUT passed!"
        OUT=$(cat /tmp/checker_stderr)
        echo "flag_id:"
        echo "$OUT"
        true
      fi

      echo "Running GET..."
      time "$CHECKER" get $HOST "$OUT" "$FLAG" "$j" >/tmp/checker_stdout 2>/tmp/checker_stderr
      A=$?
      if [ $A != 101 ]; then
        echo "GET failed! Got code $A"
        print_output
        exit 1
      else
        echo "GET passed!"
        true
      fi
    done

    echo "Test $i successful!"
  done
done


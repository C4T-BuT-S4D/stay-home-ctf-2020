#!/bin/bash

VULNS=4
CHECKS=10

print_output() {
  echo "stdout:"
  cat /tmp/checker_stdout
  echo "stderr:"
  cat /tmp/checker_stderr
}

find . -name 'checker.py' | while read -r CHECKER; do
  echo "Processing checker '$CHECKER'"
  for ((i = 1; i <= CHECKS; i++)); do
    echo "Running test $i..."

    echo "Running CHECK..."
    time "$CHECKER" check 127.0.0.1 >/tmp/checker_stdout 2>/tmp/checker_stderr
    A=$?
    if [ $A != 101 ]; then
      echo "CHECK failed! Got code $A"
      print_output
      exit 1
    else
      echo "CHECK passed!"
      true
    fi

    for ((j = 1; j <= VULNS; j++)); do
      echo "Testing vuln $j..."
      # shellcheck disable=SC2018
      # shellcheck disable=SC2019
      FLAG=$(head -c 23 /dev/urandom | base64 | tr 'a-z' 'A-Z' | tr '+/' 'AB')

      echo "Running PUT..."
      time "$CHECKER" put 127.0.0.1 123 "$FLAG" "$j" >/tmp/checker_stdout 2>/tmp/checker_stderr
      A=$?
      if [ $A != 101 ]; then
        echo "PUT failed! Got code $A"
        print_output
        exit 1
      else
        echo "PUT passed!"
        OUT=$(cat /tmp/checker_stdout)
        echo "flag_id:"
        echo "$OUT"
        true
      fi

      echo "Running GET..."
      time "$CHECKER" get 127.0.0.1 "$OUT" "$FLAG" "$j" >/tmp/checker_stdout 2>/tmp/checker_stderr
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


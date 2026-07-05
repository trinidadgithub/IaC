#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:5000}"
ITERATIONS="${ITERATIONS:-50}"
SLEEP_SECONDS="${SLEEP_SECONDS:-0.1}"

for i in $(seq 1 "$ITERATIONS"); do
  curl -s -o /dev/null "$BASE_URL/api/data" || true

  curl -s -o /dev/null \
    -H 'Content-Type: application/json' \
    -d '{"value":"test"}' \
    "$BASE_URL/api/submit" || true

  if (( i % 10 == 0 )); then
    curl -s -o /dev/null \
      -H 'Content-Type: application/json' \
      -d '{}' \
      "$BASE_URL/api/submit" || true
  fi

  sleep "$SLEEP_SECONDS"
done

echo "Generated traffic against $BASE_URL with $ITERATIONS iterations."

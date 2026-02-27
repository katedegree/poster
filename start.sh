#!/usr/bin/env bash

cd "$(dirname "$0")"

set -a
source .env
set +a

./follow/add.sh "$SESSION_TOKEN" "$USER_ID" &
./follow/all.sh "$SESSION_TOKEN" &
./like/add.sh "$SESSION_TOKEN" &
./like/all.sh "$SESSION_TOKEN" &
./post/trend.sh "$SESSION_TOKEN" &

wait

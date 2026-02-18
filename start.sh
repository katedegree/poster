#!/usr/bin/env bash

# すでにバックグラウンドなら何もしない
if [ -z "$RUNNING_IN_BG" ]; then
  RUNNING_IN_BG=1 nohup "$0" "$@" >> app.log 2>&1 &
  disown
  exit 0
fi

set -a
source .env
set +a

./follow/add.sh "$SESSION_TOKEN" "$USER_ID" >> app.log 2>&1 &
./follow/all.sh "$SESSION_TOKEN" >> app.log 2>&1 &
./like/add.sh "$SESSION_TOKEN" >> app.log 2>&1 &
./like/all.sh "$SESSION_TOKEN" >> app.log 2>&1 &
./post/trend.sh "$SESSION_TOKEN" >> app.log 2>&1 &

wait

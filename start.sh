#!/usr/bin/env bash

# すでにバックグラウンドなら何もしない
if [ -z "$RUNNING_IN_BG" ]; then
  RUNNING_IN_BG=1 nohup "$0" "$@" > app.log 2>&1 < /dev/null &
  disown
  exit 0
fi

set -a
source .env
set +a

./follow/add.sh "$SESSION_TOKEN" "$USER_ID" &
./follow/all.sh "$SESSION_TOKEN" &
./like/add.sh "$SESSION_TOKEN" &
./like/all.sh "$SESSION_TOKEN" &

wait
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

# 無限ループしている add 系だけログに出す
./follow/add.sh "$SESSION_TOKEN" "$USER_ID" >> app.log 2>&1 &
./like/add.sh "$SESSION_TOKEN" >> app.log 2>&1 &

# all 系はログ不要
./follow/all.sh "$SESSION_TOKEN" &
./like/all.sh "$SESSION_TOKEN" &

wait

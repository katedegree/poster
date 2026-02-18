#!/usr/bin/env bash

# $1: session_token
USER_FILE="./user_ids.txt"

while true; do
  while read -r userId; do
    [ -z "$userId" ] && continue
    ./follow/once.sh "$1" "$userId"
  done < "$USER_FILE"

  # 1日待機（86400秒）
  sleep 86400
done

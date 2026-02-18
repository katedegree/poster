#!/usr/bin/env bash

# $1: viewer の userId
# $2: session_token
URL="https://numatter.vercel.app/api/discover?viewer=$1"
FILE="./user_ids.txt"

touch "$FILE"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  curl -s "$URL" \
  | jq -r '.suggestedUsers[].id' \
  | while read -r id; do
    if ! grep -qxF "$id" "$FILE"; then
      echo "$id" >> "$FILE"
      echo "  added: $id"

      # 新規ユーザーだけフォロー
      ./follow/once.sh "$2" "$id"
    fi
  done

  sleep 600
done

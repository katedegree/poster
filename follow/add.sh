#!/usr/bin/env bash

# $1: session_token
# $2: viewer の userId
URL="https://numatter.vercel.app/api/discover?viewer=$2"
FILE="./user_ids.txt"

touch "$FILE"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] batch start"

  while true; do
    echo "  fetch..."

    IDS=$(curl -s "$URL" \
      -H "Cookie: __Secure-better-auth.session_token=$1" \
      | jq -r '.suggestedUsers[].id')

    # suggestedUsers が空なら break
    if [ -z "$IDS" ]; then
      echo "  no suggestedUsers. wait 60s..."
      break
    fi

    echo "$IDS" | while read -r id; do
      if ! grep -qxF "$id" "$FILE"; then
        echo "$id" >> "$FILE"
        echo "    added: $id"

        ./follow/once.sh "$1" "$id"
      fi
    done
  done

  sleep 60
done

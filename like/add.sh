#!/usr/bin/env bash

# $1: session_token
BASE_URL='https://numatter.vercel.app/api/posts'
USER_FILE="./user_ids.txt"
POST_FILE="./post_ids.txt"

touch "$POST_FILE"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  while read -r userId; do
    [ -z "$userId" ] && continue

    curl -s "${BASE_URL}?userId=${userId}&tab=posts" \
    | jq -r '.items[].post.id' \
    | while read -r postId; do
      if ! grep -qxF "$postId" "$POST_FILE"; then
        echo "$postId" >> "$POST_FILE"
        echo "added: $postId"

        # 新規postだけlike
        ./like/once.sh "$1" "$postId"
      fi
    done

  done < "$USER_FILE"

  sleep 600
done

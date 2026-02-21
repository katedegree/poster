#!/usr/bin/env bash

# $1: session_token
BASE_URL='https://numatter.vercel.app/api/posts'
USER_FILE="./user_ids.txt"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  while read -r userId; do
    [ -z "$userId" ] && continue

    curl -s "${BASE_URL}?userId=${userId}&tab=posts" \
      -H "Cookie: __Secure-better-auth.session_token=$1" \
    | jq -c '.items[]' \
    | while read -r item; do
        postId=$(echo "$item" | jq -r '.post.id')
        liked=$(echo "$item" | jq -r '.post.viewer.liked')

        if [ "$liked" = "false" ]; then
          echo "like: $postId"
          ./like/once.sh "$1" "$postId"
        else
          echo "skip (already liked): $postId"
        fi
      done

  done < "$USER_FILE"

  # 1日待機（86400秒）
  sleep 86400
done

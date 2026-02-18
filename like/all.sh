#!/usr/bin/env bash

# $1: session_token
BASE_URL='https://numatter.vercel.app/api/posts'
USER_FILE="./user_ids.txt"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

while read -r userId; do
  [ -z "$userId" ] && continue

  curl -s "${BASE_URL}?userId=${userId}&tab=posts" \
  | jq -c '.items[]' \
  | while read -r item; do
      postId=$(echo "$item" | jq -r '.post.id')
      liked=$(echo "$item" | jq -r '.viewer.liked')

      if [ "$liked" = "false" ]; then
        echo "like: $postId"
        ./like/once.sh "$1" "$postId"
      else
        echo "skip (already liked): $postId"
      fi
    done

done < "$USER_FILE"

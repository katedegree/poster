#!/usr/bin/env bash

# $1: session_token
BASE_URL='https://numatter.vercel.app/api/posts'

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  curl -s "$BASE_URL" \
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

  sleep 600
done

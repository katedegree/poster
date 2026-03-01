#!/bin/bash

# $1: session_token
SESSION_TOKEN="$1"
USER_ID="elFihqHCWbuQjHP0jt3CevyRrmLvUNVB"
BASE_URL="https://numatter.vercel.app/api/posts"

if [ -z "$SESSION_TOKEN" ]; then
  echo "session_token is required"
  exit 1
fi

while true; do
  # 投稿一覧取得
  RESPONSE=$(curl -s -X GET "${BASE_URL}?userId=${USER_ID}" \
    -H "Cookie: __Secure-better-auth.session_token=${SESSION_TOKEN}")

  # post.id を抽出
  POST_IDS=$(echo "$RESPONSE" | jq -r '.items[].post.id')

  # 投稿がなければ終了
  if [ -z "$POST_IDS" ]; then
    echo "No posts found. Done."
    break
  fi

  # 1件ずつ削除
  for POST_ID in $POST_IDS; do
    echo "Deleting post: $POST_ID"
    curl -s -X DELETE "${BASE_URL}/${POST_ID}" \
      -H "Cookie: __Secure-better-auth.session_token=${SESSION_TOKEN}" \
      -o /dev/null
  done
done

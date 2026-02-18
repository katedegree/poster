#!/usr/bin/env bash

# $1: session_token
DISCOVER_URL="https://numatter.vercel.app/api/discover"
POST_URL="https://numatter.vercel.app/api/posts"
SEARCH_BASE_URL="https://numatter.vercel.app/api/search"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  # trends の 0 番目の tag と count を取得
  read -r tag count < <(
    curl -s "$DISCOVER_URL" \
      | jq -r '.trends[0] | "\(.tag) \(.count)"'
  )

  if [ -z "$tag" ] || [ -z "$count" ]; then
    echo "invalid trends response"
    sleep 600
    continue
  fi

  # tag が #alice なら何もしない
  if [ "$tag" = "#alice" ]; then
    echo "skip: $tag"
  else
    echo "trend: $tag x$count"

    # SEARCH_URL?q=#alice を叩いて hashtags[0].count を取得
    alice_count=$(
      curl -s "${SEARCH_BASE_URL}?q=%23alice" \
        | jq -r '.hashtags[0].count // 0'
    )

    # 同率トップでも上にする場合
    if [ "$count" -ge "$alice_count" ]; then
      diff=$((count - alice_count + 1))
      echo "post #alice x$diff (alice=$alice_count)"

      for ((i=0; i<diff; i++)); do
        curl -s -X POST \
          -H "Cookie: __Secure-better-auth.session_token=$1" \
          -F 'content=#alice' \
          "$POST_URL" > /dev/null
      done
    else
      echo "no need to post (alice=$alice_count)"
    fi
  fi

  sleep 600
done

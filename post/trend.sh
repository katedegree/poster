#!/usr/bin/env bash

# $1: session_token
DISCOVER_URL="https://numatter.vercel.app/api/discover"
POST_URL="https://numatter.vercel.app/api/posts"

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] fetch start"

  trends_json=$(curl -s "$DISCOVER_URL")

  # trends の 0 番目の tag と count を取得
  read -r tag count < <(
    echo "$trends_json" | jq -r '.trends[0] | "\(.tag) \(.count)"'
  )

  if [ -z "$tag" ] || [ -z "$count" ]; then
    echo "invalid trends response"
    sleep 600
    continue
  fi

  alice_count=$(
    echo "$trends_json" | jq -r '(.trends[] | select(.tag == "#alice") | .count) // 0'
  )

  # trends[1] の count を取得
  second_count=$(
    echo "$trends_json" | jq -r '.trends[1].count // 0'
  )

  # #alice が単独トップ（2位と差がある）ならスキップ
  if [ "$tag" = "#alice" ] && [ "$alice_count" -gt "$second_count" ]; then
    echo "skip: alice is top ($alice_count) > second ($second_count)"
  elif [ "$alice_count" -gt "$count" ]; then
    echo "skip: alice=$alice_count > top=$count"
  else
    diff=$((count - alice_count + 1))
    echo "trend: $tag x$count (alice=$alice_count)"
    echo "post #alice x$diff"

    for ((i=0; i<diff; i++)); do
      curl -s -X POST \
        -H "Cookie: __Secure-better-auth.session_token=$1" \
        -F 'content=#alice' \
        "$POST_URL" > /dev/null
    done
  fi

  sleep 60
done

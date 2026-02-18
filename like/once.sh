#!/usr/bin/env bash

# $1: session_token
# $2: post_id

echo "like: $2"

curl -s -o /dev/null -w "%{http_code}\n" -X POST \
  -H "Cookie: __Secure-better-auth.session_token=$1" \
  "https://numatter.vercel.app/api/posts/$2/likes"

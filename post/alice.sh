#!/bin/bash

# $1: session_token
yes | xargs -n10 -P20 -I{} curl -s -o /dev/null -w "%{http_code}\n" -X POST \
  -H "Cookie: __Secure-better-auth.session_token=$1" \
  -F 'content=#推しはアリス' \
  -F 'images=@post/alice.png' \
  'https://numatter.vercel.app/api/posts'

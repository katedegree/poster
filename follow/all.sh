#!/usr/bin/env bash

# $1: session_token
FILE="./post_ids.txt"

while read -r post_id; do
  [ -z "$post_id" ] && continue
  ./like/once.sh "$1" "$post_id"
done < "$FILE"

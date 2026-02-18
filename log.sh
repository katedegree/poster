#!/usr/bin/env bash

LOG_FILE="app.log"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file $LOG_FILE does not exist. Please run ./start.sh first."
  exit 1
fi

tail -n 100 -f "$LOG_FILE"

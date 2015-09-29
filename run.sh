#!/bin/sh
while true
do
  if [ ! -d "out" ]; then
    echo "Created out directory."
    mkdir out
  fi
  echo "Starting scrape."
  python scrape.py
  echo "Sleeping for 15 minutes..."
  sleep 15m
done

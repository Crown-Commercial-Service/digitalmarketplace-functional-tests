#!/usr/bin/env bash

brew install nginx
sudo cp "$(dirname "${BASH_SOURCE[0]}")/nginx.conf" /usr/local/etc/nginx/nginx.conf

if sudo ps -xU nobody > /dev/null 2>&1; then
  echo "Nginx running, reloading config"
  sudo nginx -s reload
else
  echo "Starting Nginx"
  sudo nginx
fi


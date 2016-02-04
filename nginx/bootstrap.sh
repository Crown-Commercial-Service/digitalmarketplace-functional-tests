#!/usr/bin/env bash

if [ "$(brew ls --versions nginx | wc -l)" -eq 0 ]; then
  brew install nginx
fi

local_config="$(dirname "$BASH_SOURCE[0]}")/nginx.conf"
installed_config="/usr/local/etc/nginx/nginx.conf"
config_updated=0
if [ "$(diff "$local_config" "$installed_config" | wc -l)" -gt 0 ]; then
  echo "Installing updated Nginx config"
  sudo cp "$local_config" "$installed_config"
  config_updated=1
fi

if [ ! -d /tmp/nginx ]; then
  echo "Creating temporary directory for nginx to use for uploads"
  mkdir /tmp/nginx
  config_updated=1
fi

if ps -xU nobody > /dev/null 2>&1; then
  if [ "$config_updated" -eq 1 ]; then
    echo "Nginx running, reloading config"
    sudo nginx -s reload
  fi
else
  echo "Starting Nginx"
  sudo nginx
fi


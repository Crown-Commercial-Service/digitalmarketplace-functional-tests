#!/bin/bash

set -e

until curl -s ${DM_DATA_API_URL} | grep -q Unauthorized; do
  >&2 echo "API is unavailable - sleeping"
  sleep 1
done

>&2 echo "API is up - continuing"

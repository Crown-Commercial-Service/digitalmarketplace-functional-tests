#!/bin/bash

# Test that the data API, search API and frontends are up and accepting requests.

DM_ENVIRONMENT=${1:-local}

. "./scripts/envs/${DM_ENVIRONMENT}.sh"

function test_url {
  curl --output /dev/null --silent --head --fail "$1"
}

function fail {
  >&2 echo -e "\033[1;31m$1\033[0m"
  exit 1
}

test_url "${DM_API_DOMAIN}/_status" || fail "Data API is not up"
test_url "${DM_SEARCH_API_DOMAIN}/_status" || fail "Search API is not up"
test_url "${DM_FRONTEND_DOMAIN}/_status" || fail "Buyer frontend is not up"
test_url "${DM_FRONTEND_DOMAIN}/suppliers/_status" || fail "Supplier frontend is not up"
test_url "${DM_FRONTEND_DOMAIN}/admin/_status" || fail "Admin frontend is not up"

echo -e "\033[0;32mAll services are up\033[0m"

#!/bin/bash

# Test that the data API, search API and frontends are up and accepting requests.

DM_ENVIRONMENT=${1:-local}

. "./scripts/envs/${DM_ENVIRONMENT}.sh"

function test_url {
  curl --output /dev/null --silent --head --fail "$1"
}

function test_framework_status {
  curl -H "Authorization: Bearer $DM_API_ACCESS_TOKEN" "$DM_API_DOMAIN/frameworks/$1" 2>/dev/null | grep '"status": "'$2'"' > /dev/null || fail "Framework $1 should have status '$2'"
}

function fail {
  >&2 echo -e "\033[1;31m$1\033[0m"
  exit 1
}

test_url "${DM_API_DOMAIN}/_status" || fail "Data API is not up"
test_url "${DM_SEARCH_API_DOMAIN}/_status" || fail "Search API is not up"
test_url "${DM_FRONTEND_DOMAIN}/_status" || fail "Buyer frontend is not up$([ "$DM_ENVIRONMENT" = "local" ] && echo -n "; you may need to run ./nginx/bootstrap.sh")"
test_url "${DM_FRONTEND_DOMAIN}/suppliers/_status" || fail "Supplier frontend is not up"
test_url "${DM_FRONTEND_DOMAIN}/admin/_status" || fail "Admin frontend is not up"

echo -e "\033[0;32mAll services are up\033[0m"

test_framework_status "g-cloud-4" "expired"
test_framework_status "g-cloud-5" "expired"
test_framework_status "g-cloud-6" "expired"
test_framework_status "g-cloud-7" "live"
test_framework_status "g-cloud-8" "live"
test_framework_status "digital-outcomes-and-specialists" "expired"
test_framework_status "digital-outcomes-and-specialists-2" "live"

echo -e "\033[0;32mAll frameworks have the correct status\033[0m"

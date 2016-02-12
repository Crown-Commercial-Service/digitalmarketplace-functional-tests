#!/bin/bash
#
# Create admin users for use in functional tests
#
# Usage:
# ./scripts/create_users.sh <environment>
#
# Example:
# ./scripts/create_users.sh local

DM_ENVIRONMENT=${1:-local}

. "./scripts/envs/${DM_ENVIRONMENT}.sh"

function create_user {
  local email=$1;
  local name=$2;
  local role=$3;
  local password=$4;

  read -r -d '' USER_PAYLOAD <<EOF
{
  "users": {
    "emailAddress": "$email",
    "name": "$name",
    "role": "$role",
    "password": "$password"
  }
}
EOF
  echo -n "Creating admin user $email... "
  STATUS_CODE=$(curl -sL -w "%{http_code}" -o /dev/null -X POST -H 'Content-type: application/json' -H "Authorization: Bearer ${DM_API_ACCESS_TOKEN}" -d "${USER_PAYLOAD}" "${DM_API_DOMAIN}/users")
  if [ "$STATUS_CODE" == "409" ]; then
    echo "Already exists"
  elif [ "$STATUS_CODE" == "201" ]; then
    echo "Created"
  else
    echo "ERROR: $STATUS_CODE"
  fi
}

create_user "$DM_ADMIN_EMAIL" "Admin" "admin" "$DM_ADMIN_PASSWORD"
create_user "$DM_ADMIN_CCS_SOURCING_EMAIL" "Admin" "admin-ccs-sourcing" "$DM_ADMIN_PASSWORD"
create_user "$DM_ADMIN_CCS_CATEGORY_EMAIL" "Admin" "admin-ccs-category" "$DM_ADMIN_PASSWORD"

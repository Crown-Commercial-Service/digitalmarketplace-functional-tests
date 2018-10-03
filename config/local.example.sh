#!/bin/bash

export DM_ENVIRONMENT=${DM_ENVIRONMENT:="local"}

export DM_API_DOMAIN=${DM_API_DOMAIN:=http://localhost:5000}
export DM_SEARCH_API_DOMAIN=${DM_SEARCH_API_DOMAIN:=http://localhost:5001}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=http://localhost}

source "${BASH_SOURCE%/*}/common.sh"

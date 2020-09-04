export DM_ENVIRONMENT=${DM_ENVIRONMENT:="local"}

export DM_API_PORT=${DM_API_PORT:=5000}
export DM_SEARCH_API_PORT=${DM_SEARCH_API_PORT:=5009}

export DM_API_DOMAIN=${DM_API_DOMAIN:=http://localhost:${DM_API_PORT}}
export DM_SEARCH_API_DOMAIN=${DM_SEARCH_API_DOMAIN:=http://localhost:${DM_SEARCH_API_PORT}}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=http://localhost}

source "${BASH_SOURCE%/*}/common.sh"

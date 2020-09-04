export DM_ENVIRONMENT=${DM_ENVIRONMENT:="development"}

export DM_API_DOMAIN=${DM_API_DOMAIN:=https://api.${DM_ENVIRONMENT}.marketplace.team}
export DM_API_ACCESS_TOKEN=${DM_API_ACCESS_TOKEN:=myToken}
export DM_SEARCH_API_DOMAIN=${DM_SEARCH_API_DOMAIN:=https://search-api.${DM_ENVIRONMENT}.marketplace.team}
export DM_SEARCH_API_ACCESS_TOKEN=${DM_SEARCH_API_ACCESS_TOKEN:=myToken}
export DM_ANTIVIRUS_API_DOMAIN=${DM_ANTIVIRUS_API_DOMAIN:=https://antivirus-api.${DM_ENVIRONMENT}.marketplace.team}
export DM_ASSETS_DOMAIN=${DM_ASSETS_DOMAIN:=https://assets.${DM_ENVIRONMENT}.marketplace.team}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=https://www.${DM_ENVIRONMENT}.marketplace.team}

export DM_NOTIFY_API_KEY=${DM_NOTIFY_API_KEY}

export DM_SUPPLIER_USER_EMAIL=${DM_SUPPLIER_USER_EMAIL:=functional-tests-default-supplier-user@example.com}
export DM_SUPPLIER_USER_PASSWORD=${DM_SUPPLIER_USER_PASSWORD:=Password1234}
export DM_SUPPLIER_USER_SUPPLIER_ID=${DM_SUPPLIER_USER_SUPPLIER_ID:=577184}

export DM_BUYER_USER_EMAIL=${DM_BUYER_USER_EMAIL:=functional-tests-default-buyer-user@example.gov.uk}
export DM_BUYER_USER_PASSWORD=${DM_BUYER_USER_PASSWORD:=Password1234}

export DM_ADMIN_USER_EMAIL=${DM_ADMIN_USER_EMAIL:=functional-tests-default-admin-user@user.marketplace.team}
export DM_ADMIN_USER_PASSWORD=${DM_ADMIN_USER_PASSWORD:=Password1234}

export DM_ADMIN_CCS_CATEGORY_USER_EMAIL=${DM_ADMIN_CCS_CATEGORY_USER_EMAIL:=functional-tests-default-admin-ccs-category-user@user.marketplace.team}
export DM_ADMIN_CCS_CATEGORY_USER_PASSWORD=${DM_ADMIN_CCS_CATEGORY_USER_PASSWORD:=Password1234}

export DM_ADMIN_CCS_SOURCING_USER_EMAIL=${DM_ADMIN_CCS_SOURCING_USER_EMAIL:=functional-tests-default-admin-ccs-sourcing-user@user.marketplace.team}
export DM_ADMIN_CCS_SOURCING_USER_PASSWORD=${DM_ADMIN_CCS_SOURCING_USER_PASSWORD:=Password1234}

export DM_ADMIN_MANAGER_USER_EMAIL=${DM_ADMIN_MANAGER_USER_EMAIL:=functional-tests-default-admin-manager-user@user.marketplace.team}
export DM_ADMIN_MANAGER_USER_PASSWORD=${DM_ADMIN_MANAGER_USER_PASSWORD:=Password1234}

export DM_ADMIN_FRAMEWORK_MANAGER_USER_EMAIL=${DM_ADMIN_FRAMEWORK_MANAGER_USER_EMAIL:=functional-tests-default-admin-framework-manager-user@user.marketplace.team}
export DM_ADMIN_FRAMEWORK_MANAGER_USER_PASSWORD=${DM_ADMIN_FRAMEWORK_MANAGER_USER_PASSWORD:=Password1234}

export DM_ADMIN_CCS_DATA_CONTROLLER_USER_EMAIL=${DM_ADMIN_CCS_DATA_CONTROLLER_USER_EMAIL:=functional-tests-default-admin-ccs-data-controller-user@user.marketplace.team}
export DM_ADMIN_CCS_DATA_CONTROLLER_USER_PASSWORD=${DM_ADMIN_CCS_DATA_CONTROLLER_USER_PASSWORD:=Password1234}

export DM_PAGINATION_LIMIT=${DM_PAGINATION_LIMIT:=5}

export DM_DOCUMENTS_BUCKET_NAME=${DM_DOCUMENTS_BUCKET_NAME:=digitalmarketplace-documents-${DM_ENVIRONMENT}-${DM_ENVIRONMENT}}

#!/bin/bash

export DM_API_DOMAIN=${DM_API_DOMAIN:=http://localhost:5000}
export DM_API_ACCESS_TOKEN=${DM_API_ACCESS_TOKEN:=myToken}
export DM_SEARCH_API_DOMAIN=${DM_API_API_DOMAIN:=http://localhost:5001}
export DM_SEARCH_API_ACCESS_TOKEN=${DM_SEARCH_API_ACCESS_TOKEN:=myToken}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=http://localhost}

export DM_PRODUCTION_SUPPLIER_USER_EMAIL=${DM_PRODUCTION_SUPPLIER_USER_EMAIL:=production-supplier-user@example.com}
export DM_PRODUCTION_SUPPLIER_USER_PASSWORD=${DM_PRODUCTION_SUPPLIER_USER_PASSWORD:=password123}
export DM_PRODUCTION_SUPPLIER_USER_SUPPLIER_ID=${DM_PRODUCTION_SUPPLIER_USER_SUPPLIER_ID:=577184}

export DM_PRODUCTION_BUYER_USER_EMAIL=${DM_PRODUCTION_BUYER_USER_EMAIL:=production-buyer-user@example.gov.uk}
export DM_PRODUCTION_BUYER_USER_PASSWORD=${DM_PRODUCTION_BUYER_USER_PASSWORD:=password123}

export DM_PRODUCTION_ADMIN_USER_EMAIL=${DM_PRODUCTION_ADMIN_USER_EMAIL:=production-admin-user@example.gov.uk}
export DM_PRODUCTION_ADMIN_USER_PASSWORD=${DM_PRODUCTION_ADMIN_USER_PASSWORD:=password123}

export DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_EMAIL=${DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_EMAIL:=production-admin-ccs-category-user@example.gov.uk}
export DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_PASSWORD=${DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_PASSWORD:=password123}

export DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_EMAIL=${DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_EMAIL:=production-admin-ccs-sourcing-user@example.gov.uk}
export DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_PASSWORD=${DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_PASSWORD:=password123}

export DM_PAGINATION_LIMIT=${DM_PAGINATION_LIMIT:=5}

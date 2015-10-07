#!/bin/bash

export DM_API_DOMAIN=${DM_API_DOMAIN:=http://localhost:5000}
export DM_API_ACCESS_TOKEN=${DM_API_ACCESS_TOKEN:=myToken}
export DM_SEARCH_API_DOMAIN=${DM_API_API_DOMAIN:=http://localhost:5001}
export DM_SEARCH_API_ACCESS_TOKEN=${DM_SEARCH_API_ACCESS_TOKEN:=myToken}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=http://localhost}
export DM_ADMIN_EMAIL=${DM_ADMIN_EMAIL:=admin@example.com}
export DM_ADMIN_PASSWORD=${DM_ADMIN_PASSWORD:=admin-password}
export DM_SUPPLIER_EMAIL=${DM_SUPPLIER_EMAIL:=supplier@example.com}
export DM_SUPPLIER2_EMAIL=${DM_SUPPLIER2_EMAIL:=supplier2@example.com}
export DM_SUPPLIER3_EMAIL=${DM_SUPPLIER3_EMAIL:=supplier3@example.com}
export DM_SUPPLIER2_USER_EMAIL=${DM_SUPPLIER2_USER_EMAIL:=supplier4@example.com}
export DM_SUPPLIER_PASSWORD=${DM_SUPPLIER_PASSWORD:=supplier-password}
export DM_PAGINATION_LIMIT=${DM_PAGINATION_LIMIT:=5}

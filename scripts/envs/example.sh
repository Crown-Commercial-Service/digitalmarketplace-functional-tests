#!/bin/bash

export DM_API_DOMAIN=${DM_API_DOMAIN:=http://localhost:5000}
export DM_API_ACCESS_TOKEN=${DM_API_ACCESS_TOKEN:=myToken}
export DM_SEARCH_API_DOMAIN=${DM_API_API_DOMAIN:=http://localhost:5001}
export DM_SEARCH_API_ACCESS_TOKEN=${DM_SEARCH_API_ACCESS_TOKEN:=myToken}
export DM_FRONTEND_DOMAIN=${DM_FRONTEND_DOMAIN:=http://localhost}
export DM_ADMIN_EMAIL=${DM_ADMIN_EMAIL:=admin@admin.dmdev}
export DM_ADMIN_CCS_SOURCING_EMAIL=${DM_ADMIN_CCS_SOURCING_EMAIL:=ccs-sourcing@example.com}
export DM_ADMIN_PASSWORD=${DM_ADMIN_PASSWORD:=Admin12345}
export DM_SUPPLIER_EMAIL=${DM_SUPPLIER_EMAIL:=testing.supplier.username@dmtestemail.com}
export DM_SUPPLIER2_EMAIL=${DM_SUPPLIER2_EMAIL:=testing.supplier.username2@dmtestemail.com}
export DM_SUPPLIER3_EMAIL=${DM_SUPPLIER3_EMAIL:=testing.supplier.username3@dmtestemail.com}
export DM_SUPPLIER2_USER_EMAIL=${DM_SUPPLIER2_USER_EMAIL:=testing.supplier2.username@dmtestemail.com}
export DM_SUPPLIER_PASSWORD=${DM_SUPPLIER_PASSWORD:=testuserpassword}
export DM_PAGINATION_LIMIT=${DM_PAGINATION_LIMIT:=5}

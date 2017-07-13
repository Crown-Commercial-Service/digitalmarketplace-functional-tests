#!/bin/bash
set -e

psql -d postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB -f /docker-entrypoint-initdb.d/database_dump

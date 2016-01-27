#!/bin/bash

DM_ENVIRONMENT=${1:-local}

bundle install
. "./scripts/envs/${DM_ENVIRONMENT}.sh"

./scripts/test_services.sh "$DM_ENVIRONMENT" || exit 1

if [ "$DM_ENVIRONMENT" = "local" ]; then
  echo -e "\033[0;34mBootstrapping local environment\033[0m"
  ./nginx/bootstrap.sh
  ./scripts/create_users.sh "$DM_ENVIRONMENT"
  exit
fi

mkdir -p reports
rm -f screenshot*

bundle exec cucumber -r features --tags ~@ssp --tags ~@ssp-gcloud --tags ~@wip --tags @functional-test --color --format html --out reports/index.html --format pretty

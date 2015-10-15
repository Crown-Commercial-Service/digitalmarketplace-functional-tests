#!/bin/bash

DM_ENVIRONMENT=${1:-local}

bundle install
. "./scripts/envs/${DM_ENVIRONMENT}.sh"

mkdir -p reports
rm -f screenshot*

bundle exec cucumber -r features --tags ~@ssp --tags ~@wip --tags @functional-test --color --format html --out reports/index.html --format pretty

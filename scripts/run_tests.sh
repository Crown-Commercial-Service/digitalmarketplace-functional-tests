#!/bin/bash
#
# Examples:
#   # Run default test suite (should be the same as what preview runs)
#   ./scripts/run_tests.sh local
#
#   # Run a specific feature file
#   ./scripts/run_tests.sh local features/G-Cloud/admin_journey.feature
#
#   # Run features tagged as @ssp-gcloud on preview
#   ./scripts/run_tests.sh preview --tags @ssp-gcloud
#
#   # ERROR first argument must be an environment
#   ./scripts/run_tests.sh features/G-Cloud/admin_journey.feature

DM_ENVIRONMENT=${1:-local}
shift

if [ "$#" -gt 0 ]; then
  COMMAND="features --tags ~@wip  --tags ~@ssp-gcloud  --tags ~@ssp-dos  --tags @functional-test"
else
  COMMAND="$*"
fi

bundle install
. "./scripts/envs/${DM_ENVIRONMENT}.sh"

./scripts/test_services.sh "$DM_ENVIRONMENT" || exit 1

if [ "$DM_ENVIRONMENT" = "local" ]; then
  echo -e "\033[0;34mBootstrapping local environment\033[0m"
  ./scripts/create_users.sh "$DM_ENVIRONMENT"
fi

mkdir -p reports
rm -f screenshot*

echo -e "\033[0;34mRunning functional tests\033[0m"
bundle exec cucumber -r features $COMMAND --color --format html --out reports/index.html --format pretty

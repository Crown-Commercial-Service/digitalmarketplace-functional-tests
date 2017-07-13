DM_ENVIRONMENT ?= local

smoke-tests: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags @smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

run: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT} ${ARGS}

rerun:
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber -p rerun

setup: install clean
	@echo "Environment:" ${DM_ENVIRONMENT}
	mkdir -p reports/

install:
	bundle install

config/local.sh:
	cp config/example.sh config/local.sh

clean:
	rm -rf reports/

docker-up:
	$(eval export AWS_ACCESS_KEY_ID=$(shell aws configure get aws_access_key_id))
	$(eval export AWS_SECRET_ACCESS_KEY=$(shell aws configure get aws_secret_access_key))
	docker-compose up

.PHONY: smoke-tests run rerun setup install clean aws docker-up

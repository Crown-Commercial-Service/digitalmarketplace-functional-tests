DM_ENVIRONMENT ?= local

smoke-tests: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags @smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

run: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

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

.PHONY: smoke-tests run rerun setup install clean

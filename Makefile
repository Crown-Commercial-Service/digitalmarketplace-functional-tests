DM_ENVIRONMENT ?= local

smoke-tests: setup
	. config/${DM_ENVIRONMENT}.sh && bundle exec cucumber --tags @smoke-tests

run: setup
	. config/${DM_ENVIRONMENT}.sh && bundle exec cucumber ${ARGS}

setup: install clean
	@echo "Environment:" ${DM_ENVIRONMENT}
	mkdir -p reports/

install:
	bundle install

config/local.sh:
	cp config/example.sh config/local.sh

clean:
	rm -rf reports/

.PHONY: smoke-tests run setup install clean

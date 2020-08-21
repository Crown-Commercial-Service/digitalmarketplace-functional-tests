DM_ENVIRONMENT ?= local

CONFIG := config/${DM_ENVIRONMENT}.sh

smoke-tests: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict --tags @smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

smoulder-tests: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict --tags @smoulder-tests,@smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

smoulder-tests-parallel: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec parallel_cucumber features/ -n 4 -o "--strict --tags @smoulder-tests,@smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT} ${ARGS} -p run-parallel"

run: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT} ${ARGS}

rerun:
	[ -s reports/rerun ] || (echo "rerun file is empty or does not exist"; exit 1)
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict -p rerun

run-parallel: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec parallel_cucumber features/ -n 4 -o "--strict -t ~@skip -t ~@skip-${DM_ENVIRONMENT} ${ARGS} -p run-parallel"

build-report:
	bundle exec report_builder -s 'reports' -o 'reports/index' -f html -t features,errors -T '<img src="https://media.giphy.com/media/sIIhZliB2McAo/giphy.gif">Functional Test Results'

setup: install config clean
	mkdir -p reports/

install:
	bundle config set path '.bundle';\
	bundle config set without 'development';\
	bundle install

.PHONY: config
config:
	@[ -z "$${DM_API_DOMAIN}" ] && ${MAKE} ${CONFIG} || true
	@[ -f ${CONFIG} ] && echo 'Using config from ${CONFIG}' || echo 'Using config from envvars'
	@echo "Environment:" ${DM_ENVIRONMENT}

config/%.sh: config/%.example.sh
	@[ -f ${CONFIG} ] || (echo "Copying example config" && cp $? $@)

clean:
	rm -rf reports/

lint: install
	bundle exec rubocop features

index-services:
	$(if ${FRAMEWORK},,$(error Must specify FRAMEWORK))
	docker run --net=host digitalmarketplace/scripts scripts/index-to-search-service.py services dev --api-token=myToken --search-api-token=myToken --index=${FRAMEWORK} --frameworks=${FRAMEWORK}


.PHONY: smoke-tests run rerun run-parallel setup install clean index-services

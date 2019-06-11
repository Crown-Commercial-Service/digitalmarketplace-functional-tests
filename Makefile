DM_ENVIRONMENT ?= local

CONFIG := config/${DM_ENVIRONMENT}.sh

smoke-tests: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict --tags @smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

smoulder-tests: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec cucumber --strict --tags @smoulder-tests,@smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

smoulder-tests-parallel: setup
	[ -f ${CONFIG} ] && . ${CONFIG} ; bundle exec parallel_cucumber features/ -n 4 -o "--strict --tags @smoulder-tests,@smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT} ${ARGS} -p run-parallel"

run: setup lint
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
	bundle install --path .bundle --without development test

.PHONY: config
config:
	@[ -z "$${DM_API_DOMAIN}" ] && ${MAKE} ${CONFIG} || true
	@[ -f ${CONFIG} ] && echo 'Using config from ${CONFIG}' || echo 'Using config from envvars'
	@echo "Environment:" ${DM_ENVIRONMENT}

config/%.sh: config/%.example.sh
	@[ -f ${CONFIG} ] || (echo "Copying example config" && cp $? $@)

clean:
	rm -rf reports/

lint:
	bundle exec govuk-lint-ruby features --diff

docker-up:
	$(eval export AWS_ACCESS_KEY_ID=$(shell aws configure get aws_access_key_id))
	$(eval export AWS_SECRET_ACCESS_KEY=$(shell aws configure get aws_secret_access_key))
	$(eval export DM_MANDRILL_API_KEY=$(shell ${DM_CREDENTIALS_REPO}/sops-wrapper -d ${DM_CREDENTIALS_REPO}/vars/preview.yaml | grep mandrill_key | sed 's/^.* //'))
	$(eval export DM_NOTIFY_API_KEY=$(shell ${DM_CREDENTIALS_REPO}/sops-wrapper -d ${DM_CREDENTIALS_REPO}/vars/preview.yaml | grep notify_api_key | sed 's/^.* //'))
	$(if ${AWS_ACCESS_KEY_ID},,$(error AWS_ACCESS_KEY_ID not set.))
	$(if ${AWS_SECRET_ACCESS_KEY},,$(error AWS_SECRET_ACCESS_KEY not set.))
	$(if ${DM_MANDRILL_API_KEY},,$(error DM_MANDRILL_API_KEY not set.))
	$(if ${DM_NOTIFY_API_KEY},,$(error DM_NOTIFY_API_KEY not set.))
	docker-compose up

index-services:
	$(if ${FRAMEWORK},,$(error Must specify FRAMEWORK))
	docker run --net=host digitalmarketplace/scripts scripts/index-to-search-service.py services dev --api-token=myToken --search-api-token=myToken --index=${FRAMEWORK} --frameworks=${FRAMEWORK}


.PHONY: smoke-tests run rerun run-parallel setup install clean docker-up index-services

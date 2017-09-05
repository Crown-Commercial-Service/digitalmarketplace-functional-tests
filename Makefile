DM_ENVIRONMENT ?= local

smoke-tests: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags @smoke-tests --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT}

run: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber --tags ~@skip --tags ~@skip-${DM_ENVIRONMENT} ${ARGS}

rerun:
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec cucumber -p rerun

run-parallel: setup
	[ -f config/${DM_ENVIRONMENT}.sh ] && . config/${DM_ENVIRONMENT}.sh ; bundle exec parallel_cucumber features/ -n 4 -o "-t ~@skip -t ~@skip-${DM_ENVIRONMENT} ${ARGS} -p run-parallel"

build-report:
	report_builder -s 'reports' -o 'reports/index' -f html -t features,errors -T '<img src="http://media.giphy.com/media/sIIhZliB2McAo/giphy.gif">Functional Test Results'

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
	$(eval export DM_MANDRILL_API_KEY=$(shell ${DM_CREDENTIALS_REPO}/sops-wrapper -d ${DM_CREDENTIALS_REPO}/vars/preview.yaml | grep mandrill_key | sed 's/^.* //'))
	$(if ${AWS_ACCESS_KEY_ID},,$(error AWS_ACCESS_KEY_ID not set.))
	$(if ${AWS_SECRET_ACCESS_KEY},,$(error AWS_SECRET_ACCESS_KEY not set.))
	$(if ${DM_MANDRILL_API_KEY},,$(error DM_MANDRILL_API_KEY not set.))
	docker-compose up

index-services:
	$(if ${FRAMEWORK},,$(error Must specify FRAMEWORK))
	docker run --net=host digitalmarketplace/scripts scripts/index-services.py dev --api-token=myToken --search-api-token=myToken --index=${FRAMEWORK} --frameworks=${FRAMEWORK}


.PHONY: smoke-tests run rerun run-parallel setup install clean docker-up index-services

# digitalmarketplace-functional-tests
BDD tests for the digital marketplace suite of applications.

Technology wise it is a Ruby project using:
- [Cucumber](http://cukes.info/)
- [Capybara](https://github.com/jnicklas/capybara)
- [Bundler](http://bundler.io/)

## Bootstraping the project on Mac

This installation assumes you're using [Homebrew](http://brew.sh/) and Ruby
installed by Homebrew. We expect you to have [rbenv](https://github.com/rbenv/rbenv)
installed and expect you to be using that to manage your Ruby versions. We have seen
problems installing Nokogiri with native Mac Ruby. Nokogiri can also cause problems
if you have an old version of XCode. Upgrading to version 6.1.0 from 5.x has been
known to resolve the issue. `brew doctor` will warn if your version of XCode is
sufficiently out of date.

```bash
gem install bundler
make install
```

## Running tests

If you have an environment set up then tests can be run with `bundle exec cucumber`

Alternatively, you can load the environment config and run tests at the same time with

`make run`

To run only smoke tests suite

`make smoke-tests`

To run tests for a specific environment file

Create a `config/<evnironment>.sh` file and run `DM_ENVIRONMENT=preview make smoke-tests`

To run a specific feature run with

`make ARGS='-n ...' run`

To run features with a specific tag run

`make ARGS='--tags ...' run`

To include or exclude tags see [the cucumber documentation](https://github.com/cucumber/cucumber/wiki/Tags#running-a-subset-of-scenarios)

## Tags
Tags are used to include/exclude given tests on certain environments. The following tags are currently supported:

| Tag Name                    | Description                                           |
|-----------------------------|-------------------------------------------------------|
| smoke-tests                 |                                                       |
| opportunities               |                                                       |               
| requirements                |                                                       |
| brief-response              |                                                       |
| with-production-<type>-user |                                                       |
| skip                        | Skip this test everywhere (e.g. temporarily disabled) |
| skip-preview                | Will not run on the preview environment.              |
| skip-staging                | Will not run on the staging environment.              |
| skip-production             | Will not run on the production environment.           |


## Run tests against local services

First you need to create a file to set up your local environment variables - this must be in
the `config/` directory. There is an example file `config/example.sh`.  Copy this to
`config/local.sh` - this should hopefully work out of the box, but you might have a
different experience depending on your setup.

In order to run the functional tests against local apps you will need a reverse proxy
that serves the application through the same host / port. There is an Nginx config provided
with a bootstrap script at `nginx/bootstrap.sh`. Once this has been run and all the
applications are running the functional tests can be run with

`make run`

(or you can substitute `local` with the name of whatever `config/*.sh` environment file you're using.

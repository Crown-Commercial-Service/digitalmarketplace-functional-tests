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


## Setting up your local environment with Docker Compose to run functional tests against

Setting up your local environment and database to run the functional tests against can be a pain. Wouldn't it be nice if you could get all the apps up and running, backed by a database in the correct state with just one command? That's hopefully what we can do with Docker Compose. It uses the latest tagged Docker images of the apps as well as a DB dump of your choosing to achieve this.

### Setup

  - Do all of this without any apps running locally to avoid issues with blocking ports.
  - Have Docker installed on your machine - see [here](https://www.docker.com/docker-mac)
  - Have Docker Compose installed on your machine. Docker for Mac comes with it so you probably won't need to do anything extra. You can check with `docker-compose -v`. If you don't have it, go [here](https://docs.docker.com/compose/install/)
  - Have a `.envrc` file in the root of your credentials repo which sets your AWS profile to your sops profile. Probably something like `AWS_PROFILE=sops`. Check in `~/.aws/config` if you're not sure. This step isn't strictly necessary to get all the containers up and running, but functional tests will fail whenever trying to send an email if you don't do it.
  - Have a database dump that you want to use. The most up to date you can get your hands on the better. This is the data you're going to be running tests against so it should have all frameworks up to date. It doesn't matter what it's called, as long as it ends in `.sql`.
  - Create a new directory within `./sql` - `./sql/data` and place your database dump in it.
  - Execute:
  
        make docker-up
  - Enter your AWS MFA code when prompted.
  - If this is the first time you've run this command, the Postgres image will need to import the data from the dump. This will take a minute or two. When it's done, the apps will load, beginning with the api. When the logs in your terminal have calmed down and tell you that frontend apps have spawned uWSGI workers, move on.
  - Go to [`http://localhost`](http://localhost). You should see the Digital Marketplace homepage.
  - You now need to index your services from a new shell in your functional tests repo. There is a make rule to do it, but you will need to set a couple of variables first.
    * `DM_SCRIPTS_REPO` should be set to an absolute path to the root of your local Digital Marketplace scripts repo. It's probably worth adding this to your environment permanently as it's unlikely to change very often.
    *  `FRAMEWORKS` should be set to a comma separated string of the frameworks you want to index. At the time of writing this is probably just `g-cloud-9`. If you wanted to do more, it would look like `g-cloud-8,g-cloud-9`. This variable should just be set when you run the make rule (see below).
  - Execute, substituting in your desired frameworks:
        make FRAMEWORKS=g-cloud-9 index-services

    This will generate a lot of noise in your terminal, including creating a virtualenv in your scripts repo. Don't worry, it cleans up after itself.
  - Return to your original shell and hit `CTRL+C` to exit, or run `docker-compose down` from a shell in the functional tests repo.

### Starting the environment
      make docker-up
  - This will create, recreate or restart the containers. If they don't exist it'll create them, if they have changed it'll recreate them, if they exist and haven't changed it'll restart them.
  - The `make` rule will grab your local default AWS credentials and the preview Mandrill API key and present them as env variables for the docker-compose file. This is why you'll need to input an MFA code - it uses SOPS.

### Stopping the environment
      CTRL+D or docker-compose stop
  - If using the `stop` command run it from a shell in the functional tests repo
  - Occasionally `CTRL+C` will cause an error and abort without actually stopping the containers. Then use the full command to stop the containers.

### Destroying the environment
      docker-compose down --volumes
  - This destroys the containers (they'll need to be recreated) and deletes their associated volumes.
  - If you run it without the `--volumes` flag, the volumes will remain in your system but won't be uses by subsequent containers.
  - If you do this, the next time you run `make docker-up` your database will recreate itself and you will have to index your services again.

### Updating the images
      docker-compose pull
  - Docker Compose will pull in app images tagged with `:latest`.
  - Before running tests you'll probably want to pull the latest versions of the apps.
  - This command will pull them all.
  - Do this *before* building local versions incorporating your changes, or this will overwrite the "latest" tag with the 
    latest from Dockerhub.
  
### Running tests against YOUR version of the app.
  - The main reason for doing all this is to make it easier to test YOUR local changes, which won't happen if you always have the `:latest` tagged image from Dockerhub.
  - From the root of the app you want to build an image for, run `make docker-build`.
  - Building your app locally will create a local image of it and give it the `:latest` tag.
  - Docker Compose will now use your local copy including your new stuff.
  - Then start the local container environment as described above.

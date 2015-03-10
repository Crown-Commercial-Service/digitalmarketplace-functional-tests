# digitalmarketplace-functional-tests
BDD tests for the digital marketplace suite of applications.

Technology wise it is a Ruby project using:
- [Cucumber](http://cukes.info/)
- [Capybara](https://github.com/jnicklas/capybara)
- [Bundler](http://bundler.io/)

## Bootstraping the project on Mac

This installation assumes you're using [Homebrew](http://brew.sh/) and Ruby
installed by Homebrew. We have seen problems installing Nokogiri with native
Mac Ruby. Nokogiri can also cause problems if you have an old version of
XCode. Upgrading to version 6.1.0 from 5.x has been known to resolve the issue.
`brew doctor` will warn if your version of XCode is sufficiently out of date.

```bash
gem install bundler
bundle install
```

## Running tests

Tests can be run with

`bundle exec cucumber`

To run a specific feature run with

`bundle exec cucumber -n <part of feature name>`

To run features with a specific tag run

`bundle exec cucumber --tags @tag-name`

To include or exclude tags see [the cucumber documentation](https://github.com/cucumber/cucumber/wiki/Tags#running-a-subset-of-scenarios)

## Controlling the test environment

The test environment can be controlled with environment variables

| Environment Variable           | Description                | Default               |
| ------------------------------ | -------------------------- | --------------------- |
| `DM_API_DOMAIN`                | API domain                 | http://localhost:5000 |
| `DM_API_ACCESS_TOKEN`          | API Access Token           | myToken               |
| `DM_SEARCH_API_DOMAIN`         | Search API Domain          | http://localhost:5001 |
| `DM_SEARCH_API_ACCESS_TOKEN`   | Search API Access Token    | myToken               |
| `DM_BUYER_FRONTEND_DOMAIN`     | Buyer frontend domain      | http://localhost:5002 |
| `DM_SUPPLIER_FRONTEND_DOMAIN`  | Supplier frontend domain   | http://localhost:5003 |
| `DM_ADMIN_FRONTEND_DOMAIN`     | Admin frontend domain      | http://localhost:5004 |

@assets @skip-local
Feature: Favicon.ico should return a blank, transparent gif on assets. domain

Scenario: Request favicon from assets domain
  Given I visit the assets /favicon.ico page
  Then the response code should be 200
  And the response header content_type should be image/gif

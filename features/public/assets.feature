@assets @skip-local
Feature: Favicon.ico should return a blank, transparent x-icon on frontend. domain

Scenario: Request favicon from frontend domain
  Given I visit the frontend /static/images/favicon.ico page
  Then the response code should be 200
  And the response header content_type should be image/x-icon

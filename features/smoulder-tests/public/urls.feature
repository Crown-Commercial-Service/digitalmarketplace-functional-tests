@smoulder-tests
Feature: Handling of various degenerate URL cases

Scenario: Use of leading double-slashes in URL path
  Given I visit the //user/login page
  Then I am on the 'Log in to the Digital Marketplace' page

Scenario: Use of trailing slashes in URL path
  Given I visit the /user/login/ page
  Then I am on the 'Log in to the Digital Marketplace' page

Scenario: Use of relative URL path components
  Given I visit the /user/../help page
  Then I am on the 'Help and feedback' page

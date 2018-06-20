@skip-production
@smoke-tests
@direct-award-passive
Feature: Direct Award passive assurance

Scenario: User is required to login to save a search
  Given I visit the /g-cloud/search page
  Then I see the 'Save search' button
  And I click 'Save search'
  Then I am on the 'Log in to the Digital Marketplace' page

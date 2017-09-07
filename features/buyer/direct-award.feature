@skip-staging @skip-production
@direct-award
Feature: Direct Award flows

Scenario: User can save a search into a new Direct Award Project
  Given I am logged in as a buyer user
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Save your search' page
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

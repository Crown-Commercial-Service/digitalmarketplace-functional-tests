@skip-staging @skip-production
@direct-award
Feature: Direct Award flows

Scenario: User can save a search into a new Direct Award Project
  Given I am logged in as a buyer user
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Save search' page
  And I enter 'my cloud project' in the 'Name a new project' field
  And I click 'Create project and save search'
  Then I am on the 'my cloud project' page

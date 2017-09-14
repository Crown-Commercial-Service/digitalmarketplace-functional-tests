@skip-staging @skip-production
@direct-award
Feature: Direct Award flows

Scenario: User can save a search into a new Direct Award Project
  Given I am logged in as a buyer user
  And I have a created and saved a search
  Then I am on the 'my cloud project' page

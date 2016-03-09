@not-production @functional-test 
Feature: Create buyer account. WIP-The flow to get to the creation page is as yet not nailed down. This test starts directly on the buyer creation page itself rather than navigating to it as a user would on the frontend app

Scenario: User steps through buyer account creation process
  Given I navigate directly to the page '/buyers/create'
  When I am on the 'Create a buyer account' page
  And I enter 'test.buyer.email@test.com' in the 'email_address' field
  And I click 'Create account'
  Then I am taken to the 'Activate your account' page

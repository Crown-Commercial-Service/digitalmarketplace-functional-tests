@not-production @functional-test @buyer-creation
Feature: Create buyer account. We're assuming a user journey where someone tries to find a specialist, eventually hits the login page, and then clicks 'Create a buyer account' from the login page

Scenario: User steps through buyer account creation process
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find an individual specialist' link
  Then I am taken to the buyers 'Find an individual specialist' page

  When I click the 'Create requirement' button
  Then I am taken to the 'Log in to the Digital Marketplace' page

  When I click the 'Create a buyer account' link
  Then I am on the 'Create a buyer account' page

  And I enter 'test.buyer.email@test.gov.uk' in the 'email_address' field
  And I click 'Create account'
  Then I am taken to the 'Activate your account' page

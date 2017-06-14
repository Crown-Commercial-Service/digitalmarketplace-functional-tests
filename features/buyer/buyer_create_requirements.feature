@not-production @functional-test
Feature: Buyer create buyer requirements

Background: Login to Digital Marketplace as the newly created buyer
  Given I have a buyer user account
  And I have logged in to Digital Marketplace as a 'Buyer' user

Scenario: Test setup
  Given I have deleted all draft buyer requirements
  And I am on the 'Digital Marketplace' landing page
  When I click the 'Find an individual specialist' link
  Then I am taken to the buyers 'Find an individual specialist' page

  When I click the 'Create requirement' button
  Then I am taken to the 'What you want to call your requirements' page

  When I enter 'Find an individual specialist' in the 'title' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Find an individual specialist' requirements overview page

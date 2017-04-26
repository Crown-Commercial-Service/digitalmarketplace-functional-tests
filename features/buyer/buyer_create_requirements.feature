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

Scenario: Newly created buyer requirements should be listed on the buyer's dashboard
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'View your account' link
  Then I am presented with the 'DM Functional Test Buyer User 1' 'Buyer' dashboard page
  Then The buyer requirements for 'Find an individual specialist' 'is' listed on the buyer's dashboard

Scenario: "Ready to publish" button should not exist yet
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'Review and publish your requirements' link
  Then I am taken to the 'Publish your requirements and evaluation criteria' page
  And The 'Publish requirements' button is 'not' available

Scenario: Edit Requirements title and verify the change made, on the summary page
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'Title' link
  Then I am taken to the 'What you want to call your requirements' page
  And Form field 'title' should contain 'Find an individual specialist'
  When I change 'title' to 'Find an individual specialist-edited'
  And I click 'Save and continue'
  Then I am taken to the 'Find an individual specialist-edited' requirements overview page

Scenario: Created buyer requirements can be deleted
  Given A draft 'Find an individual specialist' buyer requirements with the name 'Buyer Requirements to be deleted' exists and I am on the "Overview of work" page
  When I click 'Delete'
  Then I am presented with the message 'Are you sure you want to delete these requirements?'

  When I click 'Yes, delete'
  Then I am presented with the 'DM Functional Test Buyer User 1' 'Buyer' dashboard page
  And I am presented with the message 'Your requirements ‘Buyer Requirements to be deleted’ were deleted'
  And The buyer requirements for 'Buyer Requirements to be deleted' 'is not' listed on the buyer's dashboard

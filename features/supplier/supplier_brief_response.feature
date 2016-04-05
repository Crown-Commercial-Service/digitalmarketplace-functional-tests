@not-production @functional-test
Feature: Supplier respond to opportunities

Background: Buyer publishes requirements
  Given I have a buyer user account
  And I have deleted all draft buyer requirements
  And I have a 'published' set of requirements

Scenario: Setup for responding to an opportunity
  Given I have test suppliers
  And Test suppliers are eligible to respond to a brief
  And The test suppliers have users
  And Test supplier users are active

Scenario: Supplier sees the correct opportunity
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  And I am on the supplier response page for the opportunity
  Then I see the correct title and requirements for the opportunity

Scenario: Supplier successfully responds to an opportunity
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  And I am on the supplier response page for the opportunity
  And I enter 'testing.supplier.username@dmtestemail.com' in the 'respondToEmailAddress' field
  And I choose 'Yes' for the 'essentialRequirements' requirements
  And I choose 'Yes' for the 'niceToHaveRequirements' requirements
  And I enter '23/03/2015' in the 'availability' field
  And I enter '100' in the 'dayRate' field
  And I enter 'Janny' in the 'specialistName' field
  And I click the 'Save and continue' button
  Then I am presented with the message 'Your response to ‘Individual Specialist-Buyer Requirements’ has been submitted.'

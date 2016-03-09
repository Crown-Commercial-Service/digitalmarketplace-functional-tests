@not-production @functional-test @brief-responses
Feature: Supplier respond to briefs

Background: Publish a brief
  Given I have a buyer user account
  And I have deleted all draft briefs
  And I have a 'published' brief

Scenario: Setup for responding to a brief
  Given I have test suppliers
  And Test suppliers are eligible to respond to a brief
  And The test suppliers have users
  And Test supplier users are active

Scenario: Check the brief response is correct
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  And I am on the supplier response page for the brief
  Then I see correct brief title and requirements for the brief

Scenario: Supplier successfully responds to a brief
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  And I am on the supplier response page for the brief
  And I choose 'Yes' for the 'essentialRequirements' requirements
  And I choose 'Yes' for the 'niceToHaveRequirements' requirements
  And I enter '23/03/2015' in the 'availability' field
  And I enter '100' in the 'dayRate' field
  And I enter 'Janny' in the 'specialistName' field
  And I click the 'Save and continue' button
  Then I am presented with the message 'Your response to ‘Individual Specialist-Brief deletion test’ has been submitted.'
@create-requirements
Feature: Buyer can create requirements

Scenario: Buyer can log in
  Given I have a buyer user
  And I am on the /login page
  When I enter that user.emailAddress in the 'email_address' field
  And I enter that user.password in the 'password' field
  And I click 'Log in' button
  Then I am on the 'Digital Marketplace' page

@create-requirements
Feature: Buyer can create requirements

Scenario: Buyer can log in
  Given I have a buyer user
  And I am on the /login page
  When I enter that user.emailAddress in the 'email_address' field
  And I enter that user.password in the 'password' field
  And I click 'Log in' button
  Then I am on the 'Digital Marketplace' page

Scenario: I can start writing a requirement
  Given I am logged in as a buyer user
  When I click 'Find an individual specialist'
  Then I am on the 'Find an individual specialist' page
  When I click 'Create requirement'
  Then I am on the 'What you want to call your requirements' page
  When I enter a random value in the 'title' field
  And I click 'Save and continue'
  Then I am on that fields.title page

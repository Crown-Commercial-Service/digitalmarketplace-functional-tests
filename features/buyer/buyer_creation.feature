@buyer @newbuyer
Feature: Create buyer account

@requires-credentials @notify
Scenario: Create a new buyer account when trying to create a requirement from the home page
  Given I visit the homepage
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page

  When I click the 'Create a buyer account' link
  Then I am on the 'Create a buyer account' page

  Given I have an email address with an accepted buyer domain
  When I enter that email_address in the 'email_address' field
  And I click the 'Create account' button
  Then I am on the 'Activate your account' page

  And I receive a 'create-user-account' email for that email_address
  And I click the link in that email
  Then I am on the 'Create a new Digital Marketplace account' page
  When I enter 'Hugs and Cuddles Ministry' in the 'Your name' field
  And I enter 'Password1234' in the 'Password' field
  And I click 'Create account' button
  Then I am on the 'Digital Marketplace' page
  And I see the 'Log out' link

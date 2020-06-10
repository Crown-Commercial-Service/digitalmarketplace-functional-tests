@user @reset-password @requires-credentials @notify
Feature: Reset user password

Scenario: User has forgotten their password and requests a password reset
  Given I have a buyer user
  When I visit the homepage
  And I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page

  And that user is able to reset their password

Scenario: Inactive user trying to reset password instead receives an informational message
  Given I have a buyer user with:
    | active | false |
  When I visit the homepage
  And I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page

  When I click 'Forgotten password'
  Then I am on the 'Reset password' page

  When I enter that user.emailAddress in the 'Email address' field
  And I click 'Send reset email' button
  Then I see a success flash message containing 'send a link to reset the password'
  And I receive a 'reset-password-inactive' email for that user.emailAddress

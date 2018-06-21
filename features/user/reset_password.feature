@user @reset-password @notify @skip-staging
Feature: Reset user password

Background:
  Given I have a buyer user

Scenario: User has forgotten their password and requests a password reset
  When I visit the homepage
  And I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page

  When I click 'Forgotten password'
  Then I am on the 'Reset password' page

  When I enter that user.emailAddress in the 'Email address' field
  And I click 'Send reset email' button
  Then I see a success banner message containing 'send a link to reset the password'
  And I receive a 'reset-password' email for that user.emailAddress
  And I click the link in that email
  Then I am on the 'Reset password' page
  When I enter that user.password in the 'New password' field
  And I enter that user.password in the 'Confirm new password' field
  And I click 'Reset password' button
  Then I am on the 'Log in to the Digital Marketplace' page
  And I see a success banner message containing 'You have successfully changed your password.'

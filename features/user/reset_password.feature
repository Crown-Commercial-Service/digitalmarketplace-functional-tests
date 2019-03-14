@user @reset-password @requires-credentials @notify @skip-staging
Feature: Reset user password

Background:
  Given I have a buyer user

Scenario: User has forgotten their password and requests a password reset
  When I visit the homepage
  And I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page

  And that user is able to reset their password

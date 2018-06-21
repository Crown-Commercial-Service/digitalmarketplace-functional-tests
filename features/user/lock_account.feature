@user @lock-account
Feature: Users are locked if they enter the wrong password too many times

Scenario: User has 10 failed login attempts and is locked out of their account
  Given I have a supplier user
  When The wrong password is entered 10 times for that user
  Then That user can not log in using their correct password
  # TODO: And the user is shown as 'locked' on the admin users page

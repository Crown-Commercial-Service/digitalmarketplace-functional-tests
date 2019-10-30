@user @lock-account
Feature: Users are locked if they enter the wrong password too many times

Scenario: User has 5 failed login attempts and is locked out of their account
  Given I have a supplier user
  When the wrong password is entered 5 times for that user
  Then that user can not log in using their correct password
  # TODO: And the user is shown as 'locked' on the admin users page

  # This could be performed as a separate scenario, but getting the account into a locked state takes long enough
  # as it is
  And that user is able to reset their password

  # Now the user should be able to log in again
  When I visit the /user/login page
  And I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

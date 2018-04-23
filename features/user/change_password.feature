@password_change
Feature: Password change

Background:
  Given I have a supplier user
  And that supplier is logged in
  And I am on the /suppliers page

Scenario: Supplier user can change their password
  When I click 'Change your password'
  Then I am on the 'Change your password' page
  When I enter that user.password in the 'Old password' field
  And I enter that user.password in the 'New password' field
  And I enter that user.password in the 'Confirm new password' field
  And I click 'Save changes' button
  Then I see a success banner message containing 'You have successfully changed your password.'
  And I am on the /suppliers page

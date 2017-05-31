@contributors
Feature: Managing contributors

Background:
  Given I have a supplier
  And that supplier is logged in

Scenario: Supplier can invite a new contributor
  When I click the 'View your account' link
  And I click the 'Invite or remove' link
  Then I am on 'Invite or remove contributors' page
  And I click the 'Invite a contributor' link
  Then I am on the 'Invite a contributor' page
  And I enter 'contributor@marketplace.team' in the 'email_address' field and click its associated 'Send invite' button
  Then I see a success banner message containing 'Contributor invited'

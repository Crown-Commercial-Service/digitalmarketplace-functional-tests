@admin @invite-admin-user
Feature: Admin manager can manage users

@requires-credentials @notify
Scenario Outline: Admin Manager user can log in and invite admin users
  Given I am logged in as the existing <role> user
  And I click the 'View and edit admin accounts' link
  And I click the 'Invite user' link
  When I enter 'some-desired-admin@user.marketplace.team' in the 'Email address' field
  And I choose the 'Manage services' radio button
  And I click the 'Invite user' button
  Then I see a success banner message containing 'An invitation has been sent to some-desired-admin@user.marketplace.team.'

  Examples:
    | role          |
    | admin-manager |

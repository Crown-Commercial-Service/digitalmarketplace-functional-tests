@admin @invite-admin-user
Feature: Admin manager can manage users

@notify
Scenario Outline: Admin Manager user can log in and invite admin users
  Given I am logged in as the production <role> user
  And I click the 'View and edit admin accounts' link
  And I click the 'Invite user' link
  When I enter 'some-desired-admin@user.marketplace.team' in the 'Email address' field
  And I choose the 'Manage services' radio button
  And I click the 'Invite user' button
  Then I see a success banner message containing 'An invitation has been sent to some-desired-admin@user.marketplace.team.'

  Examples:
    | role          |
    | admin-manager |

Scenario Outline: Correct users cannot access the invite admin user page
  Given I am logged in as the production <role> user
  And I visit the /admin/admin-users/invite page
  Then I am on the 'You don’t have permission to perform this action' page

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-ccs-category      |
    | admin                   |

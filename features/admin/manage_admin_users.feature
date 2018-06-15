@manage-users
Feature: Admin manager can manage admin users

Scenario Outline: Admin Manager user can log in and suspend admin users
  Given I have an <editing-role> user with:
    | email_address | dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk |
    | name          | DM Functional Test Manage Admin User <editing-role>                              |
  And I am logged in as the production <role> user
  And I click the 'View and edit admin accounts' link
  And I click the summary table 'Edit' link for 'dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk'
  When I choose the 'Suspended' radio button
  And I click the 'Update user' button
  Then I see a success banner message containing 'dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk has been updated.'
  And I see an entry in the 'Admin users' table with:
    | Name                                                | Email                                                                             | Permissions         | Status    |
    | DM Functional Test Manage Admin User <editing-role> | dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk | <editing-role-name> | Suspended |
  When I click the summary table 'Edit' link for 'dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk'
  And I choose the 'Active' radio button
  And I click the 'Update user' button
  Then I see a success banner message containing 'dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk has been updated.'
  And I see an entry in the 'Admin users' table with:
    | Name                                                | Email                                                                             | Permissions         | Status |
    | DM Functional Test Manage Admin User <editing-role> | dm-functional-test-manage-admin-user-<editing-role>@digital.cabinet-office.gov.uk | <editing-role-name> | Active |

  Examples:
    | role          | editing-role            | editing-role-name |
    | admin-manager | admin-framework-manager | Manage framework  |
    | admin-manager | admin                   | Support accounts  |
    | admin-manager | admin-ccs-sourcing      | Audit framework   |
    | admin-manager | admin-ccs-category      | Manage services   |

Scenario Outline: Correct users cannot access the manage admin users page
  Given I am logged in as the production <role> user
  Then I don't see the 'View and edit admin accounts' link
  When I visit the /admin/admin-users page
  Then I am on the 'You don’t have permission to perform this action' page

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-ccs-category      |
    | admin                   |

@search-for-users
Feature: Search for users

Scenario Outline: Correct users can search for users by email address
  Given I have a buyer user with:
    | email_address | dm-functional-test-search-for-user-1@digital.cabinet-office.gov.uk |
    | name          | DM Functional Test Search User 1                           |
  And I am logged in as the production <role> user
  And I click the 'Find a user by email' link
  When I enter 'dm-functional-test-supplier-user-1@digital.cabinet-office.gov.uk' in the 'Find a user by email' field
  And I click the 'Search' button
  Then I am on the 'Find a user' page
  And I see the 'User' summary table filled with:
    | DM Functional Test Search User 1 | supplier |

  Examples:
    | role                    |
    | admin                   |
    | admin-ccs-category      |

Scenario Outline: Correct users cannot search for users by email address
  Given I am logged in as the production <role> user
  Then I don't see the 'Find a user by email' link
  When I am on the /admin/users page
  Then I am on the 'You don’t have permission to perform this action' page

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |

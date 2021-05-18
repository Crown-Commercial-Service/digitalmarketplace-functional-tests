@admin @search-for-users
Feature: Search for users

Scenario Outline: Admins can search for users by email address
  Given I have a buyer user with:
    | email_address | user-one-findme@example.gov.uk   |
    | name          | DM Functional Test Search User 1 |
  And I am logged in as the existing admin user
  And I click the 'Find a user by email' link
  When I enter 'user-one-findme@example.gov.uk' in the 'Find a user by email' field
  And I click the 'Search' button
  Then I am on the 'Find a user' page
  And I see an entry in the 'Users' table with:
    | Name                             | Role  | Supplier | Last login | Last password change | Locked |
    | DM Functional Test Search User 1 | buyer |          | <ANY>      | <ANY>                | No     |

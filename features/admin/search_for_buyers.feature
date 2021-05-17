@admin @search-for-buyers
Feature: Find a buyer

Scenario Outline: Correct users can search for buyers by brief id
  Given I am logged in as the existing admin user
  And I click the 'Find a buyer by opportunity ID' link
  When I enter '18723' in the 'Find a buyer by opportunity ID' field
  And I click the 'Search' button
  Then I am on the 'Find a buyer' page
  And I see the 'User' summary table filled with:
    | Test user | 18723@user.marketplace.team |

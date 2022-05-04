@smoulder-tests
Feature: Supplier list download

@file-download @skip-local
Scenario: Framework manager admin can download list of supplier details
  Given I am logged in as the existing admin-framework-manager user
  And I click a random link with text 'Contact suppliers'
  When I click the 'Official details for suppliers' link
  Then I should get a download file with filename ending '.csv' and content-type 'text/csv'

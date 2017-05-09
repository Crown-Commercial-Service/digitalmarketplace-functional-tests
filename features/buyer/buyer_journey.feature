@not-production @functional-test
Feature: Buyer user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have live services
  And All services for the test suppliers are Public

Scenario: There is pagination on the list of suppliers page if there are more than 100 results
  Given I navigate to the list of 'Suppliers starting with S' page
  When I click the 'Next page' link
  Then I am taken to page '2' of results

  When I click the 'Previous page' link
  Then I am taken to page '1' of results

Scenario: There is no pagination on the list of suppliers page if there is less than or equal to 100 results
  Given I navigate to the list of 'Suppliers starting with Q' page
  Then Pagination is 'not available'

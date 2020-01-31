@smoulder-tests
Feature: Passive supplier a-z browsing journey

@skip-local
@skip-preview
@skip-staging
Scenario: User can click through to opportunities page
  Given I visit the homepage
  When I click 'G-Cloud supplier A–Z'
  Then I am on the 'Suppliers starting with A' page

@skip-production
Scenario: User can click through to opportunities page
  Given I visit the homepage
  When I click 'G-Cloud supplier A to Z'
  Then I am on the 'Suppliers starting with A' page

Scenario: User can click through to suppliers beginning with a specific letter
  Given I visit the /g-cloud/suppliers?prefix=other page
  When I choose a random uppercase letter
  And I click that letter
  Then I see the page's h1 ends in that letter
  And I do not see any suppliers that don't begin with that letter

Scenario: User can navigate to a specific supplier's detail page
  Given I visit the /g-cloud/suppliers?prefix=other page
  And I have a random g-cloud supplier from the API
  When I click the first letter of that supplier.name
  Then I see that supplier in one of the pages that follow from clicking 'Next page'
  When I click that specific supplier
  Then I am on that supplier.name page

Scenario: There is pagination on the list of suppliers page if there are more than 100 results
  Given I navigate to the list of 'Suppliers starting with S' page
  When I click the 'Next page' link
  Then I am taken to page '2' of results
  When I click the 'Previous page' link
  Then I am taken to page '1' of results

Scenario: There is no pagination on the list of suppliers page if there is less than or equal to 100 results
  Given I navigate to the list of 'Suppliers starting with Q' page
  Then pagination is 'not available'

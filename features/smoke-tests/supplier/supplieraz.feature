@smoke-tests
Feature: Passive supplier a-z browsing journey

Scenario: User can see the main links on the homepage
  Given I am on the homepage
  Then I see the 'G-Cloud supplier A–Z' link

Scenario: User can click through to opportunities page
  Given I am on the homepage
  When I click 'G-Cloud supplier A–Z'
  Then I am on the 'Suppliers starting with A' page

Scenario: User can click through to suppliers beginning with a specific letter
  Given I am on the /g-cloud/suppliers?prefix=other page
  When I choose a random uppercase letter
  And I click that letter
  Then I see the page's h1 ends in that letter
  And I do not see any suppliers that don't begin with that letter

Scenario: User can navigate to a specific supplier's detail page
  Given I am on the /g-cloud/suppliers?prefix=other page
  And I have a random g-cloud supplier from the API
  When I click the first letter of that supplier.name
  Then I see that supplier in one of the pages that follow from clicking 'Next page'
  When I click that specific supplier
  Then I am on that supplier.name page

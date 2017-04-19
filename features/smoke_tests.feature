@smoke-test
Feature: Smoke tests


Scenario: gzip is enabled
    Given I am on the 'Digital Marketplace' landing page
    Then gzip is enabled

Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Digital Marketplace' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'Digital Marketplace Team' 'Supplier' dashboard page

  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: User is able to navigate from the digital marketplace landing page to the g-cloud landing page
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find cloud technology and support' link
  Then I am taken to the 'Cloud technology and support' landing page

Scenario: User able to search by keywords field on the search results page to narrow down the results returned
  Given I have a random service from the API
  Given I am on the search results page with results for that service.lot displayed
  When I enter that service.id in the 'q' field
  And I click 'Filter'
  Then I am on a page with that service.id in search summary text
  And There is 1 search result
  And Selected lot is that service.lot with links to the search for that service.id
  And I am on a page with that service in search results

@smoke-test
Feature: Smoke tests

Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'Digital Marketplace Team' supplier dashboard page

  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: User is able to navigate from the digital marketplace landing page to the g-cloud landing page
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find cloud technology and support' link
  Then I am taken to the 'Cloud technology and support' landing page

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot with SaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Software as a Service' link
  Then I am taken to the search results page with results for 'Software as a Service' lot displayed

Scenario: User selects PaaS lot from the g-cloud page is presented with search results page for PaaS lot with PaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Platform as a Service' link
  Then I am taken to the search results page with results for 'Platform as a Service' lot displayed

Scenario: User selects IaaS lot from the g-cloud page is presented with search results page for IaaS lot with IaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Infrastructure as a Service' link
  Then I am taken to the search results page with results for 'Infrastructure as a Service' lot displayed

Scenario: User selects SCS lot from the g-cloud page is presented with search results page for SCS lot with SCS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Specialist Cloud Services' link
  Then I am taken to the search results page with results for 'Specialist Cloud Services' lot displayed

Scenario: User able to search by service ID and have result returned
  Given I am on the 'Cloud technology and support' landing page
  And I have a random service from the API
  When I enter that service.id in the 'q' field
  And I click 'Show services'
  Then I am on a page with that service.id in search summary text
  And There is 1 search result
  And I am on a page with that service in search results

Scenario: User is able to search by service name and have result returned.
  Given I am on the 'Cloud technology and support' landing page
  And I have a random service from the API
  When I enter that service.serviceName in the 'q' field
  And I click 'Show services'
  Then I am on a page with that service.serviceName in search summary text
  And I am on a page with that service in search results

Scenario: User is able to navigate to service listing page via selecting the service from the search results
  Given I am on the search results page with results for 'Platform as a Service' lot displayed
  When I click the first record in the list of results returned
  Then I am taken to the service listing page of that specific record selected

Scenario: User able to search by keywords field on the search results page to narrow down the results returned
  Given I have a random service from the API
  Given I am on the search results page with results for that service.lot displayed
  When I enter that service.id in the 'q' field
  And I click 'Filter'
  Then I am on a page with that service.id in search summary text
  And There is 1 search result
  And Selected lot is that service.lot with links to the search for that service.id
  And I am on a page with that service in search results

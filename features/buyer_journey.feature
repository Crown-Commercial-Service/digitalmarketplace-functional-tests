@not-production @functional-test @now
Feature: Buyer user journey through Digital Marketplace

Scenario: User is able to navigate from the digital marketplace landing page to the g-cloud landing page
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find cloud technology and support' link
  Then I am taken to the 'Cloud technology and support' landing page

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Software as a Service' link
  Then I am taken to the search results page with results for 'Software as a Service' lot displayed
  And All filters for 'Software as a Service' are available

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Platform as a Service' link
  Then I am taken to the search results page with results for 'Platform as a Service' lot displayed
  And All filters for 'Platform as a Service' are available

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Infrastructure as a Service' link
  Then I am taken to the search results page with results for 'Infrastructure as a Service' lot displayed
  And All filters for 'Infrastructure as a Service' are available

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Specialist Cloud Services' link
  Then I am taken to the search results page with results for 'Specialist Cloud Services' lot displayed
  And All filters for 'Specialist Cloud Services' are available

Scenario: Search results page displays filters according to selected lot

Scenario: User able to search by service ID and have result returned

Scenario: User is able to search by service name and have result returned

Scenario: User able to search by keywords field on the search results page and have results returned

Scenario: Words in service description matching the search criteria are highlighted

Scenario: User is able to use filter to narrow down results set

Scenario: User is able to navigate to listing page via selecting the service from the search results

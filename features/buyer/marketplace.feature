@_smoke-tests
Feature: Buyer user journey through Digital Marketplace

Scenario: User can see the main links on the homepage
  Given I am on the homepage
  Then I see the 'Find cloud technology and support' link
  And I see the 'Buy physical datacentre space for legacy systems' link
  And I see the 'Find an individual specialist' link
  And I see the 'Find a team to provide an outcome' link
  And I see the 'Find user research participants' link
  And I see the 'Find a user research lab' link
  And I see the 'View Digital Outcomes and Specialists opportunities' link
  And I see the 'Create a supplier account' link

Scenario: User can click through to g-cloud page
  Given I am on the homepage
  When I click 'Find cloud technology and support'
  Then I am on the 'Cloud technology and support' page

Scenario: User can get the SaaS search results
  Given I am on the /g-cloud page
  When I click 'Software as a Service'
  Then I am on the 'Search results' page
  And I see the 'Software as a Service' breadcrumb
  And I see a service in the search results

Scenario: User is able to search by service name and have result returned.
  Given I am on the /g-cloud page
  And I have a random g-cloud service from the API
  When I enter that service.serviceName in the 'q' field
  And I click 'Show services'
  Then I see that service.serviceName as the value of the 'q' field
  And I see that service in search results


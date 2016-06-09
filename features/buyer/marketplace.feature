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
  When I click the 'Find cloud technology and support' link
  Then I am on the 'Cloud technology and support' page

Scenario: User can get the SaaS search results
  Given I am on the /g-cloud page
  When I click the 'Software as a Service' link
  Then I am on the 'Search results' page
  And I see the 'Software as a Service' breadcrumb
  And I see a service in the search results

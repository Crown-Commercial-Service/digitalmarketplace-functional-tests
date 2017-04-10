@smoke-tests
Feature: Passive catalogue buyer journey

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

Scenario: User can get the PaaS search results
  Given I am on the /g-cloud page
  When I click 'Platform as a Service'
  Then I am on the 'Search results' page
  And I see the 'Platform as a Service' breadcrumb
  And I see a search result

Scenario: User can get the SaaS search results
  Given I am on the /g-cloud page
  When I click 'Software as a Service'
  Then I am on the 'Search results' page
  And I see the 'Software as a Service' breadcrumb
  And I see a search result

Scenario: User can get the IaaS search results
  Given I am on the /g-cloud page
  When I click 'Infrastructure as a Service'
  Then I am on the 'Search results' page
  And I see the 'Infrastructure as a Service' breadcrumb
  And I see a search result

Scenario: User is able to search by service id and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that service.id in the 'q' field
  And I click 'Filter'
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

Scenario: User is able to search by service name and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that quoted service.serviceName in the 'q' field
  And I click 'Filter'
  Then I see that quoted service.serviceName in the search summary text
  And I see that quoted service.serviceName as the value of the 'q' field
  And I see that service in the search results

Scenario: User is able to navigate to service detail page via selecting the service from the search results
  Given I am on the /g-cloud/search page
  Then I am on the 'Search results' page
  When I click a random result in the list of service results returned
  Then I am on that result.title page
  And I see that result.supplier_name as the page header context

Scenario: User is able to search by keywords field on the search results page to narrow down the results returned
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I click that service.lotName
  And I enter that service.id in the 'q' field
  And I click 'Filter'
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

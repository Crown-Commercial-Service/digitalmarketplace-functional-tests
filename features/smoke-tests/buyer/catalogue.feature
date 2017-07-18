@smoke-tests
@catalogue
Feature: Passive catalogue buyer journey

Scenario: User can see the main links on the homepage
  Given I am on the homepage
  Then I see the 'Find cloud hosting, software and support' link
  And I see the 'Buy physical datacentre space' link
  And I see the 'Find an individual specialist' link
  And I see the 'Find a team to provide an outcome' link
  And I see the 'Find user research participants' link
  And I see the 'Find a user research lab' link
  And I see the 'View Digital Outcomes and Specialists opportunities' link
  And I see the 'Create a supplier account' link

Scenario: User can click through to g-cloud page
  Given I am on the homepage
  When I click 'Find cloud hosting, software and support'
  Then I am on the 'Cloud hosting, software and support' page

Scenario: User can select a lot from the g-cloud page and see search results.
  Given I am on the /g-cloud page
  When I have a random g-cloud lot from the API
  When I click that lot.name
  Then I am on the 'Search results' page
  And I see that lot.name breadcrumb
  And I see a search result

@skip-local @skip-preview @skip-staging
Scenario: User is able to search by service id and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that service.id in the 'q' field
  And I click the 'Filter' button
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

@skip-production
Scenario: User is able to search by service id and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that service.id in the 'q' field
  And I wait for the page to reload
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

@skip-local @skip-preview @skip-staging
Scenario: User is able to search by service name and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that quoted service.serviceName in the 'q' field
  And I click the 'Filter' button
  Then I see that quoted service.serviceName in the search summary text
  And I see that quoted service.serviceName as the value of the 'q' field
  And I see that service in the search results

@skip-production
Scenario: User is able to search by service name and have result returned.
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that quoted service.serviceName in the 'q' field
  And I wait for the page to reload
  Then I see that quoted service.serviceName in the search summary text
  And I see that quoted service.serviceName as the value of the 'q' field
  And I see that service in the search results

Scenario: User is able to navigate to service detail page via selecting the service from the search results
  Given I am on the /g-cloud/search page
  Then I am on the 'Search results' page
  When I click a random result in the list of service results returned
  Then I am on that result.title page
  And I see that result.supplier_name as the page header context

@skip-local @skip-preview @skip-staging
Scenario: User is able to search by keywords field on the search results page to narrow down the results returned
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  And I enter that service.id in the 'q' field
  And I click the 'Filter' button
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

@skip-production
Scenario: User is able to search by keywords field on the search results page to narrow down the results returned
  Given I am on the /g-cloud/search page
  And I have a random g-cloud service from the API
  And I enter that service.id in the 'q' field
  And I wait for the page to reload
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  And I see that service in the search results

Scenario: User is able to click on a random category
  Given I am on the /g-cloud page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  And I note the number of search results

  When I click a random category link
  Then I am on the 'Search results' page
  And I see that category_name in the search summary text
  And I see a search result
  And I see fewer search results than noted

@skip-local @skip-preview @skip-staging
Scenario: User is able to click on several random filters
  Given I am on the /g-cloud page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  And I note the number of search results
  Then I select several random filters
  And I click the 'Filter' button
  Then I am on the 'Search results' page
  And I see fewer search results than noted

@skip-production
Scenario: User is able to click on several random filters
  Given I am on the /g-cloud page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  And I note the number of search results
  Then I select several random filters
  And I wait for the page to reload
  Then I am on the 'Search results' page
  And I see fewer search results than noted

Scenario: User is able to paginate through search results and all of the navigation is preserved
  Given I am on the /g-cloud page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  And I note the number of category links
  And I click the Next Page link
  Then I am taken to page 2 of results
  And I see the same number of category links as noted
  When I click the Previous Page link
  Then I am taken to page 1 of results
  And I see the same number of category links as noted

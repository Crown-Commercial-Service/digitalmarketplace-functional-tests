@smoke-tests
@catalogue
Feature: Passive catalogue buyer journey

Scenario: User can see the main links on the homepage
  Given I visit the homepage
  Then I see the 'Find cloud hosting, software and support' link
  And I see the 'Buy physical datacentre space' link
  And I see the 'Find an individual specialist' link
  And I see the 'Find a team to provide an outcome' link
  And I see the 'Find user research participants' link
  And I see the 'Find a user research lab' link
  And I see the 'View Digital Outcomes and Specialists opportunities' link
  And I see the 'Become a supplier' link

@skip-local
@skip-preview
@skip-staging
Scenario: User can click through to g-cloud page
  Given I visit the homepage
  When I click 'Find cloud hosting, software and support'
  Then I am on the 'Find cloud hosting, software and support' page
  When I click 'Start a new search'
  Then I am on the 'Cloud hosting, software and support' page

@skip-production
Scenario: User can click through to g-cloud page
  Given I visit the homepage
  When I click 'Find cloud hosting, software and support'
  Then I am on the 'Find cloud hosting, software and support' page
  When I click 'Start a new search'
  Then I am on the 'Choose a category' page

@skip-local
@skip-preview
@skip-staging
Scenario: User can select a lot from the g-cloud page and see search results.
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  When I have a random g-cloud lot from the API
  When I click that lot.name
  Then I am on the 'Search results' page
  And I see that lot.name breadcrumb
  And I see a search result

@skip-production
Scenario: User can select a lot from the g-cloud page and see search results.
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  When I have a random g-cloud lot from the API
  When I choose that lot.name radio button
  And I click 'Search for services'
  Then I am on the 'Search results' page
  And I see that lot.name breadcrumb
  And I see a search result

Scenario: User is able to search by service id and have result returned.
  Given I visit the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that service.id in the 'q' field
  And I wait for the page to reload
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  When I continue clicking 'Next' until I see that service in the search results
  And I click a link with text that service.serviceName in that search_result
  Then I am on that service.serviceName page

Scenario: User is able to search by service name and have result returned.
  Given I visit the /g-cloud/search page
  And I have a random g-cloud service from the API
  When I enter that quoted service.serviceName in the 'q' field
  And I wait for the page to reload
  Then I see that quoted service.serviceName in the search summary text
  And I see that quoted service.serviceName as the value of the 'q' field
  When I continue clicking 'Next' until I see that service in the search results
  And I click a link with text that service.serviceName in that search_result
  Then I am on that service.serviceName page

Scenario: User is able to navigate to service detail page via selecting the service from the search results
  Given I visit the /g-cloud/search page
  Then I am on the 'Search results' page
  When I click a random result in the list of service results returned
  Then I am on that result.title page
  And I see that result.supplier_name as the page header context

Scenario: User is able to search by keywords field on the search results page to narrow down the results returned
  Given I visit the /g-cloud/search page
  And I have a random g-cloud service from the API
  And I enter that service.id in the 'q' field
  And I wait for the page to reload
  Then I see that service.id in the search summary text
  And I see that service.id as the value of the 'q' field
  When I continue clicking 'Next' until I see that service in the search results
  And I click a link with text that service.serviceName in that search_result
  Then I am on that service.serviceName page

@skip-local
@skip-preview
@skip-staging
Scenario: User is able to click on a random category
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  And I note the number of search results

  When I click a random category link
  Then I am on the 'Search results' page
  And I see that category_name in the search summary text
  And I see a search result
  And I see fewer search results than noted

@skip-production
Scenario: User is able to click on a random category
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  And I have a random g-cloud lot from the API
  And I choose that lot.name radio button
  And I click 'Search for services'
  Then I am on the 'Search results' page
  And I note the number of search results

  When I click a random category link
  Then I am on the 'Search results' page
  And I see that category_name in the search summary text
  And I see a search result
  And I see fewer search results than noted

@skip-local
@skip-preview
@skip-staging
Scenario: User is able to click on several random filters
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  And I have a random g-cloud lot from the API
  And I click that lot.name
  Then I am on the 'Search results' page
  When I note the number of search results
  Then a filter checkbox's associated aria-live region contains that result_count
  When I select several random filters
  And I wait for the page to reload
  Then I am on the 'Search results' page
  And I see fewer search results than noted
  When I note the number of search results
  Then a filter checkbox's associated aria-live region contains that result_count

@skip-production
Scenario: User is able to click on several random filters
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  And I have a random g-cloud lot from the API
  And I choose that lot.name radio button
  And I click 'Search for services'
  Then I am on the 'Search results' page
  When I note the number of search results
  Then a filter checkbox's associated aria-live region contains that result_count
  When I select several random filters
  And I wait for the page to reload
  Then I am on the 'Search results' page
  And I see fewer search results than noted
  When I note the number of search results
  Then a filter checkbox's associated aria-live region contains that result_count

@skip-local
@skip-preview
@skip-staging
Scenario: User is able to paginate through search results and all of the navigation is preserved
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
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

@skip-production
Scenario: User is able to paginate through search results and all of the navigation is preserved
  Given I visit the /buyers/direct-award/g-cloud/choose-lot page
  And I have a random g-cloud lot from the API
  And I choose that lot.name radio button
  And I click 'Search for services'
  Then I am on the 'Search results' page
  And I note the number of category links
  And I click the Next Page link
  Then I am taken to page 2 of results
  And I see the same number of category links as noted
  When I click the Previous Page link
  Then I am taken to page 1 of results
  And I see the same number of category links as noted

Scenario: User gets no results for an unfindable term
  Given I visit the /g-cloud/search page
  And I enter 'metempsychosis' in the 'q' field
  And I wait for the page to reload
  Then I don't see a search result
  And I see 'metempsychosis' in the search summary text

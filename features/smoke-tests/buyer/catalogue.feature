@smoke-tests
@catalogue
Feature: Passive catalogue buyer journey (smoke tests)

Scenario: User can click through to g-cloud page
  Given I visit the homepage
  When I click 'Find cloud hosting, software and support'
  Then I am on the 'Find cloud hosting, software and support' page
  When I click 'Start a new search'
  Then I am on the 'Choose a category' page

Scenario: User is able to navigate to service detail page via selecting the service from the search results
  Given I visit the /g-cloud/search page
  Then I am on the 'Search results' page
  When I click a random result in the list of service results returned
  Then I am on that result.title page
  And I see that result.supplier_name as the page header context

@skip-staging @skip-production
Scenario: User is able to navigate to service detail page via selecting the service from the search results
  Given I visit the /g-cloud/search page
  Then I am on the 'Search results' page
  And I wait for the page to load
  When I click a random result in the list of service results returned
  Then I am on that result.title page
  And I see that result.supplier_name as the page header context

Scenario: User is able to search by keywords field on the search results page to narrow down the results returned
  Given I visit the /g-cloud/search page
  And I have a random g-cloud service from the API
  And I search for that service.id using the search box
  And I wait for the page to reload
  Then I see that service.id in the search summary text
  And I see that service.id as the search query in the search box
  When I continue clicking 'Next' until I see that service in the search results
  And I click a link with text that service.serviceName in that search_result
  Then I am on that service.serviceName page

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

Scenario: User receives a 404 page when attempting to access a page beyond the number of search results
  Given I visit the /g-cloud/search?q=metempsychosis&page=2 page
  Then I am on the 'Page could not be found' page

Scenario: User receives a 404 page when attempting to access a page absurdly beyond the number of search results
  Given I visit the /g-cloud/search?page=50000 page
  Then I am on the 'Page could not be found' page

Scenario: User can fetch the highest possible page number on this index
  Given I visit the /g-cloud/search page
  And I note the total number of pages of results
  When I visit the page number of that page_count
  Then I see a search result

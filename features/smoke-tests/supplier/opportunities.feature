@smoke-tests @opportunities
Feature: Passive opportunity supplier journey (smoke tests)

Scenario: User can click through to opportunities page
  Given I visit the homepage
  When I click 'View Digital Outcomes and Specialists opportunities'
  Then I am on the 'Digital Outcomes and Specialists opportunities' page
  And I see an opportunity in the search results

Scenario: User is able to navigate to opportunity detail page via selecting the opportunity from the search results
  Given I visit the /digital-outcomes-and-specialists/opportunities page
  When I click a random result in the list of opportunity results returned
  Then I am on that result.title page

Scenario Outline: User can filter by individual lot and keyword search
  Given I visit the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I click '<lot>'
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are on the '<lot>' lot
  And I note the result_count
  # using the plural here helps us exercise stemming
  When I enter 'governments' in the 'q' field
  And I wait for the page to reload
  Then I see 'governments' in the search summary text
  And I see that the stated number of results does not exceed that result_count

  Examples:
    | lot                        |
    | Digital specialists        |
    | Digital outcomes           |
    | User research participants |

Scenario: User receives a 404 page when attempting to access a page beyond the number of search results
  Given I visit the /digital-outcomes-and-specialists/opportunities?q=metempsychosis&page=2 page
  Then I am on the 'Page could not be found' page

Scenario: User receives a 404 page when attempting to access a page absurdly beyond the number of search results
  Given I visit the /digital-outcomes-and-specialists/opportunities?page=50000 page
  Then I am on the 'Page could not be found' page

Scenario: User can fetch the highest possible page number on this index
  Given I visit the /digital-outcomes-and-specialists/opportunities page
  And I note the total number of pages of results
  When I visit the page number of that page_count
  Then I see a search result

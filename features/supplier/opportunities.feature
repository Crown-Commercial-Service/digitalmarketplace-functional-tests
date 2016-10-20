@smoke-tests
Feature: Passive opportunity supplier journey

Scenario: User can see the main links on the homepage
  Given I am on the homepage
  Then I see the 'View Digital Outcomes and Specialists opportunities' link

Scenario: User can click through to opportunities page
  Given I am on the homepage
  When I click 'View Digital Outcomes and Specialists opportunities'
  Then I am on the 'Digital Outcomes and Specialists opportunities' page
  And I see an opportunity in the search results

Scenario: User is able have specific opportunity search result returned
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  And I have a random dos brief from the API
  Then I see that brief in one of the pages that follow from clicking 'Next page'

Scenario: User is able to filter by lot and have specific result returned
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  And I have a random dos brief from the API
  When I check that brief.lotName checkbox
  And I click the 'Filter' button
  Then I see that brief in one of the pages that follow from clicking 'Next page'

Scenario: User is able to filter by status and have specific result returned
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  And I have a random dos brief from the API
  When I check that brief.statusLabel checkbox
  And I click the 'Filter' button
  Then I see that brief in one of the pages that follow from clicking 'Next page'

Scenario: User is able to filter by both status and lot and have specific result returned
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  And I have a random dos brief from the API
  When I check that brief.lotName checkbox
  When I check that brief.statusLabel checkbox
  And I click the 'Filter' button
  Then I see that brief in one of the pages that follow from clicking 'Next page'

Scenario: User is able to navigate to opportunity detail page via selecting the opportunity from the search results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I click a random result in the list of opportunity results returned
  Then I am on that result.title page

Scenario: Filtering by lot doesn't increase result count
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check a random 'lot' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count

Scenario: Filtering by status doesn't increase result count
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check a random 'status' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count

Scenario: Filtering by both status and lot doesn't increase result count
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check a random 'status' checkbox
  And I check a random 'lot' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count

Scenario: Checking all lots returns all results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check all 'lot' checkboxes
  And I click the 'Filter' button
  Then I see that the stated number of results equals that result_count

Scenario: Checking all statuses returns all results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check all 'status' checkboxes
  And I click the 'Filter' button
  Then I see that the stated number of results equals that result_count

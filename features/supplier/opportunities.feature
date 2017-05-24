@smoke-tests @opportunities
Feature: Passive opportunity supplier journey

Scenario: User can see the main links on the homepage
  Given I am on the homepage
  Then I see the 'View Digital Outcomes and Specialists opportunities' link

Scenario: User can click through to opportunities page
  Given I am on the homepage
  When I click 'View Digital Outcomes and Specialists opportunities'
  Then I am on the 'Digital Outcomes and Specialists opportunities' page
  And I see an opportunity in the search results

Scenario: User is able to navigate to opportunity detail page via selecting the opportunity from the search results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I click a random result in the list of opportunity results returned
  Then I am on that result.title page

Scenario Outline: User can filter by individual lot
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check '<lot>' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are on the '<lot>' lot

  Examples:
    | lot                        |
    | Digital specialists        |
    | Digital outcomes           |
    | User research participants |

Scenario Outline: User can filter by individual status
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check '<status>' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are of the '<status>' status

  Examples:
    | status |
    | Open   |
    | Closed |

Scenario Outline: User can filter by both status and lot
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check '<lot>' checkbox
  And I check '<status>' checkbox
  And I click the 'Filter' button
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are on the '<lot>' lot
  And I see all the opportunities on the page are of the '<status>' status

  Examples:
    | lot                        | status   |
    | Digital specialists        | Open     |
    | Digital outcomes           | Open     |
    | User research participants | Open     |
    | Digital specialists        | Closed   |
    | Digital outcomes           | Closed   |
    | User research participants | Closed   |

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

@withdrawn
Scenario: See detail page for a withdrawn brief
  Given I have a live digital outcomes and specialists framework
    And I have a buyer
    And I have a withdrawn digital-specialists brief
  When I go to that brief page
  Then I am on that brief.title page
    And I see a temporary-message banner message containing 'This opportunity was withdrawn'
    And I don't see the 'Apply' link
    And I don't see the 'Log in to ask a question' link
    And I don't see the 'Log in to view question and answer session details' link

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
  And I click '<lot>'
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
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are of the '<status>' status

  Examples:
    | status       |
    | Open         |
    | Closed       |
    | Awarded      |
    | Unsuccessful |
    | Cancelled    |

Scenario Outline: User can filter by individual location
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check '<location>' checkbox
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are in the '<location>' location

  Examples:
    | location                       |
    | Scotland                       |
    | International (outside the UK) |
    | Off-site                       |

Scenario Outline: User can filter by both status and lot
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I click '<lot>'
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I note the result_count
  And I check '<status>' checkbox
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are on the '<lot>' lot
  And I see all the opportunities on the page are of the '<status>' status

  Examples:
    | lot                        | status       |
    | Digital specialists        | Open         |
    | Digital outcomes           | Open         |
    | User research participants | Open         |
    | Digital specialists        | Closed       |
    | Digital outcomes           | Closed       |
    | User research participants | Closed       |
    | Digital specialists        | Awarded      |
    | Digital outcomes           | Unsuccessful |
    | User research participants | Cancelled    |

Scenario: Checking all statuses returns all results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check all 'status' checkboxes
  And I wait for the page to reload
  Then I see that the stated number of results equals that result_count

@opportunities
Feature: Supplier viewing and filtering DOS opportunities - extension of smoke tests

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

Scenario: Checking all statuses returns all results
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I check all 'status' checkboxes
  And I wait for the page to reload
  Then I see that the stated number of results equals that result_count

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

Scenario: Specialist roles are selectable for Digital specialists
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  Then I don't see a 'Designer' checkbox
  And I don't see any 'specialistRole' checkboxes
  When I click 'Digital specialists'
  And I note the result_count
  And I check 'Designer' checkbox
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I see all the opportunities on the page are on the 'Digital specialists' lot
  And I see all the opportunities on the page are for the 'Designer' role

Scenario Outline: Specialist roles are not selectable for non-Digital specialists lots
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  Then I don't see a 'Designer' checkbox
  And I don't see any 'specialistRole' checkboxes
  When I click '<lot>'
  Then I don't see a 'Designer' checkbox
  And I don't see any 'specialistRole' checkboxes

  Examples:
    | lot                        |
    | Digital outcomes           |
    | User research participants |

Scenario Outline: User gets no results for impossible combinations of location and lot
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  And I click '<lot>'
  And I check '<location>' checkbox
  And I wait for the page to reload
  Then I see no results
  # now we backtrack a bit to check the lot "link" has been made unclickable when showing it has no results
  When I click 'Clear filters'
  And I wait for the page to reload
  And I click 'All categories'
  And I check '<location>' checkbox
  And I wait for the page to reload
  Then I don't see the '<lot>' link

  Examples:
    | lot                        | location                       |
    | Digital specialists        | International (outside the UK) |
    | Digital outcomes           | International (outside the UK) |
    | User research participants | Off-site                       |

Scenario Outline: User can filter by both status, lot and location together
  Given I am on the /digital-outcomes-and-specialists/opportunities page
  When I note the result_count
  And I click '<lot>'
  Then I see that the stated number of results does not exceed that result_count
  And I note the result_count
  When I check '<status>' checkbox
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I note the result_count
  And I see all the opportunities on the page are on the '<lot>' lot
  And I see all the opportunities on the page are of the '<status>' status
  When I check '<location>' checkbox
  And I wait for the page to reload
  Then I see that the stated number of results does not exceed that result_count
  And I note the result_count
  And I see all the opportunities on the page are on the '<lot>' lot
  And I see all the opportunities on the page are of the '<status>' status
  And I see all the opportunities on the page are in the '<location>' location

  Examples:
    | lot                        | status       | location                       |
    | Digital specialists        | Open         | Scotland                       |
    | Digital outcomes           | Open         | International (outside the UK) |
    | User research participants | Open         | Off-site                       |
    | Digital specialists        | Closed       | South West England             |
    | Digital outcomes           | Closed       | International (outside the UK) |
    | User research participants | Closed       | Off-site                       |
    | Digital specialists        | Open         | London                         |
    | Digital outcomes           | Closed       | International (outside the UK) |
    | User research participants | Open         | Off-site                       |
    | Digital specialists        | Closed       | Wales                          |
    | Digital outcomes           | Open         | Yorkshire and the Humber       |
    | User research participants | Closed       | Northern Ireland               |

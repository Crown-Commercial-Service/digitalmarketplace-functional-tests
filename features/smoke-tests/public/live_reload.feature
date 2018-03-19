@live-reload @skip-staging @skip-production
Feature: Live reload search

Scenario: Live reload search hitting enter should not cause a full page reload
  Given I am on the homepage
  And I click 'View Digital Outcomes and Specialists opportunities'
  And I am on the 'Digital Outcomes and Specialists opportunities' page
  Then I see the 'Clear filters' link with href 'digital-outcomes-and-specialists/opportunities'
  And I set the page reload flag
  When I enter 'Tea\n' in the 'search' field
  Then I see that the page has not been reloaded
  And I see the 'Clear filters' link with href '/digital-outcomes-and-specialists/opportunities?q=Tea%5Cn&doc_type=briefs&live-results=true'

Scenario: Live reload search button should not cause a full page reload
  Given I am on the homepage
  And I click 'View Digital Outcomes and Specialists opportunities'
  And I am on the 'Digital Outcomes and Specialists opportunities' page
  Then I see the 'Clear filters' link with href 'digital-outcomes-and-specialists/opportunities'
  And I set the page reload flag
  And I enter 'Tea' in the 'search' field
  When I click the 'Search' button
  Then I see that the page has not been reloaded
  And I see the 'Clear filters' link with href '/digital-outcomes-and-specialists/opportunities?q=Tea&doc_type=briefs&live-results=true'
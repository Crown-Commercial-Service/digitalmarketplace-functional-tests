@public-opportunity-view @skip-staging @skip-production
Feature: Published requirements can be viewed by the public

Scenario: Public views the publish requirements. Details presented matches what was published.
  Given I have the latest live digital-outcomes-and-specialists framework
  And I have a buyer user
  And that buyer is logged in
  And I have a live digital-specialists brief
  And I click 'Log out'

  When I go to that brief page
  Then I see the details of the brief match what was published

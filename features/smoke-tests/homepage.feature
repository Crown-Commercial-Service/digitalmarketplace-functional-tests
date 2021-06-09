@smoke-tests @homepage
Feature: Check appropriate links on homepage

Scenario: User can see the main links on the homepage
  Given I visit the homepage
  Then I see the 'Find cloud hosting, software and support' link
  And I see the 'Find physical datacentre space' link
  And I see the 'Find an individual specialist' link
  And I see the 'Find a team to provide an outcome' link
  And I see the 'Find user research participants' link
  And I see the 'Find a user research studio' link
  And I see the 'View Digital Outcomes and Specialists opportunities' link
  And I see the 'Become a supplier' link
  And I see the 'G-Cloud supplier A to Z' link

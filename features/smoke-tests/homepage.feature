@smoke-tests @homepage
Feature: Check appropriate links on homepage

Scenario: User can see the main links on the homepage
  Given I visit the homepage
  Then I see the 'Find cloud hosting, software and support' link
#  TODO add this line when content change is released otherwise smoke tests will show false positives while releasing
#  And I see the 'Find physical datacentre space' link
  And I see the 'Find an individual specialist' link
  And I see the 'Find a team to provide an outcome' link
  And I see the 'Find user research participants' link
  And I see the 'Find a user research lab' link
  And I see the 'View Digital Outcomes and Specialists opportunities' link
  And I see the 'Become a supplier' link
  And I see the 'G-Cloud supplier A to Z' link

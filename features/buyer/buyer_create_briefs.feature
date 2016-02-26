@not-production @functional-test @wip
Feature: Create new buyer account

Scenario: Setup for tests
  Given I have a buyer user account

Scenario: Logged in buyer attempts to access a supplier page

Scenario: Logged in supplier

Scenario: Publish a brief for an individual specialist
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

Scenario: Publish a brief for a team to provide an outcome
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

Scenario: Publish a brief to recruit particpants for user research
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

Scenario: Publish a brief to book a user research lab
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

Scenario: Buyer view submitted briefs

Scenario: Buyer view supplier responses to submitted briefs

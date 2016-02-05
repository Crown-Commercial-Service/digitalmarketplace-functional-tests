@not-production @functional-test @wip
Feature: Create new buyer account

#Scenario: User steps through supplier account creation process
#  Given I am on the 'Digital Marketplace' landing page
#  When I click 'Create supplier account'
#  Then I am on the 'Create supplier account' page

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

Scenario: Publish a brief to recruitment particpants for user research
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

Scenario: Book a user research lab
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Find an individual specialist'
  Then I am taken to the 'appropriate page'

  When I choose the 'appripriate' role
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

  When I choose the 'appropriate' location
  And I click 'Save and continue'
  Then I am taken to the 'appropriate page'

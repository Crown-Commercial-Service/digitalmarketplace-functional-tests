@buyer-dashboard
Feature: Buyer Dashboard

Scenario: Users should see new Dashboard
  Given I am logged in as a buyer user
  And I am on the /buyers page
  Then I see 'Cloud hosting, software and support' text on the page
  And I see 'Digital outcomes, specialists and user research' text on the page

Scenario: Users should see link when there are searches available to view
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I am on the /buyers page
  Then I see the 'View your saved searches' link

Scenario: Users should see message when no searches are created
  Given I am logged in as a buyer user
  And I am on the /buyers page
  Then I see 'You don't have any saved searches' text on the page

Scenario: Users should see message when no requirements are created
  Given I am logged in as a buyer user
  And I am on the /buyers page
  Then I see 'You don't have any requirements' text on the page

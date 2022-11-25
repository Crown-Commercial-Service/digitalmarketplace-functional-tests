@buyer @buyer-dashboard
Feature: Buyer Dashboard

Background:
  Given I have the latest expired 'g-cloud' framework

Scenario: Users should see new Dashboard
  Given I am logged in as a buyer user
  And I visit the /buyers page
  Then I see 'Cloud hosting, software and support' text on the page
  And I see 'Digital outcomes, specialists and user research' text on the page

Scenario: Users should see link when there are searches available to view
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I visit the /buyers page
  Then I see the 'View your saved searches' link

Scenario: Users should see message when no searches are created
  Given I am logged in as a buyer user
  And I visit the /buyers page
  Then I see 'You don't have any saved searches' text on the page

Scenario: Users should see message when no requirements are created
  Given I am logged in as a buyer user
  And I visit the /buyers page
  Then I see 'You don't have any requirements' text on the page

Scenario: New users should have a link to join the use research mailing list
  Given I am logged in as a buyer user
  When I visit the /buyers page
  Then I see the 'Join the user research mailing list' link

Scenario: Users on the mailing list should have the link to unsubscribe
  Given I am logged in as a buyer user
  And that user is on the user research mailing list
  When I visit the /buyers page
  Then I see the 'Unsubscribe from the user research mailing list' link

@brief-response
Feature: Supplier applys for a brief

Background: Buyer publishes brief
  Given I have a live brief
  
Background: (option 1) Set up supplier eligible for brief 
  Given I have a supplier
  And that supplier is on all frameworks?
  And that supplier has services on all lots... (not sure about this one)
  And I have a supplier user for that supplier

Background: (option 2) Set up supplier eligible for brief 
  Given I have a supplier on all frameworks and all lots
  And I have a supplier user for that supplier

Background: (option 3) Set up supplier eligible for brief (option 3)
  Given I have a supplier user on all frameworks and all lots

Background: (option 4) Set up supplier eligible for brief
  Given I have a supplier
  And that supplier is on the 'digital-outcomes-and-specialists' framework
  And that supplier is ... has lots of services
  And I have a supplier user for that supplier

Background: (option 5) Set up supplier eligible for brief
  Given I have a supplier user who can apply for digital outcomes and specialist briefs

Scenario: Supplier starts brief application
  Given I am logged in as that supplier user
  And I go to that brief page
  And I click 'Apply'
  Then I am on 'Apply for ‘Tea drinker’' page

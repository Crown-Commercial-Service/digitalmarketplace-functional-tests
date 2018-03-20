@supplier-framework-application
Feature: Apply to an open framework

Background:
  Given There is a framework that is open for applications
  And I have a supplier user
  And that supplier is logged in

Scenario: Supplier submits a framework declaration
  Given I am on the /suppliers page
  When I click 'Apply'
  And I am on the 'Apply to framework' page for that framework application
  When I click 'Make supplier declaration'
  Then I am on the 'Make your supplier declaration' page
  When I click 'Start your declaration'
  Then I am on the 'Your declaration overview' page

  When I answer all questions on that page
  Then I click 'Make declaration' button
  And I am on the 'Apply to framework' page for that framework application
  And I see 'You’ve made the supplier declaration' text on the page

  When I click 'Add, edit and complete services'
  Then I am on the 'Your framework services' page for that framework application

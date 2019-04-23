@supplier @supplier-framework-application
Feature: Apply to an open framework

Background:
  Given there is a framework that is open for applications

Scenario: Supplier submits a framework application
  Given I have a supplier user
  And that supplier is logged in
  When I visit the /suppliers page
  And I start that framework application
  Then I am on the 'Apply to framework' page for that framework application

  When I click 'Enter your company details'
  Then I am on the 'Company details' page
  And I fill in all the missing details
  And I click 'Save and confirm'
  Then I am on the 'Apply to framework' page for that framework application

  When I click 'Make supplier declaration'
  Then I am on the 'Make your supplier declaration' page
  When I click 'Start your declaration'
  Then I am on the 'Your declaration overview' page
  And I don't see a 'Review answer' link

  When I follow the first 'Edit' link and answer all questions on that page and those following until I'm back on the 'Your declaration overview' page
  Then I click 'Make declaration' button
  And I am on the 'Apply to framework' page for that framework application
  And I see 'You’ve made the supplier declaration' text on the page

  When I click 'Add, edit and complete services'
  Then I am on the 'Your framework services' page for that framework application
  Then I submit a service for each lot
  And I see '1 service will be submitted' or '1 lab will be submitted' text on the page
  And I click 'Back to framework application' link for that framework application

  And I see 'Your application will be submitted at' text on the page

Scenario: Supplier re-uses a declaration
  Given I have a supplier with a reusable declaration
  And that supplier has a user with:
    |active|true|
  And that supplier has begun the application process for that framework
  And that supplier has confirmed their company details for that application
  And that supplier has not begun the declaration for that application
  And that supplier is logged in
  When I visit the /suppliers page
  And I click 'Continue your application'
  Then I am on the 'Apply to framework' page for that framework application

  When I click 'Make supplier declaration'
  Then I am on the 'Make your supplier declaration' page
  When I click 'Start your declaration'
  Then I am on the 'Reusing answers from an earlier declaration' page

  When I choose the 'Yes' radio button for the 'Do you want to reuse the answers from your earlier declaration?' question
  And I click 'Save and continue'
  Then I am on the 'Your declaration overview' page

  When I click a random link with text 'Review answer'
  # TODO this is where we could continue onwards to make some assertions about the reused declaration data, however
  # at time of writing we redact so much data from the test datasets as to make this infeasible. revisit this.


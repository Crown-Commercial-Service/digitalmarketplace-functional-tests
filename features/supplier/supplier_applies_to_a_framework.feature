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

  When I click 'Confirm your company details'
  Then I am on the 'Your company details' page
  And I fill in all the missing details
  And I click 'Save and confirm'
  Then I am on the 'Apply to framework' page for that framework application
  And I see 'Done' text on the page

  When I click 'Make your supplier declaration'
  Then I am on the 'Make your supplier declaration' page
  When I click 'Start your declaration'
  Then I am on the 'Your declaration overview' page
  And I don't see a 'Review answer' link

  When I follow the first 'Edit' link and answer all questions on that page and those following until I'm back on the 'Your declaration overview' page
  Then I click 'Make declaration' button
  And I am on the 'Apply to framework' page for that framework application
  And I see 'Done' text on the page

  When I click 'Add, edit and complete services'
  Then I am on the 'Your framework services' page for that framework application
  Then I submit a service for each lot
  And I see '1 service will be submitted' or '1 research studio will be submitted' text on the page
  And I click 'Back to framework application' link for that framework application

  Then I am on the 'Apply to framework' page for that framework application
  And I see 'Your application is complete and will be submitted automatically' text on the page
  And I have submitted services for each lot

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

  When I click 'Make your supplier declaration'
  Then I am on the 'Make your supplier declaration' page
  When I click 'Start your declaration'
  Then I am on the 'Reusing answers from an earlier declaration' page

  When I choose the 'Yes' radio button for the 'Do you want to reuse the answers from your earlier declaration?' question
  And I click 'Save and continue'
  Then I am on the 'Your declaration overview' page

  When I click a random link with text 'Review answer'
  # TODO this is where we could continue onwards to make some assertions about the reused declaration data, however
  # at time of writing we redact so much data from the test datasets as to make this infeasible. revisit this.

Scenario: Supplier copies a service from a previous framework
  Given I have a supplier with a copyable service
  And that supplier has a user with:
    |active|true|
  And that supplier has begun the application process for that framework
  And that supplier has confirmed their company details for that application
  And that supplier is logged in
  When I visit the /suppliers page
  And I click 'Continue your application'
  Then I am on the 'Apply to framework' page for that framework application

  When I click 'Add, edit and complete services'
  Then I am on the 'Your framework services' page for that framework application
  Then I click on the lot link for the existing service
  And I remove existing drafts with the same name
  And I click the link to view and add services from the previous framework
  Then I am on the 'Previous lot services' page for that lot
  And I see the existing service in the copyable services table

  When I click the 'Add' button for the existing service
  Then I see 'You'll need to review it before it can be completed.' text on the page

  When I ensure I am on the services page
  Then I see that service in the Draft services section
  When I click the link to view and add services from the previous framework
  Then I don't see the existing service in the copyable services table

  When I ensure I am on the services page
  And I click the link to edit the newly copied service
  Then I am on the draft service page

  When I click the 'Remove draft service' button
  Then I see 'Are you sure you want to remove this' text on the page
  When I click the 'Yes, remove' button
  Then I see confirmation that I have removed that draft service
  Then I don't see that service in the Draft services section

  When I click the link to view and add services from the previous framework
  Then I am on the 'Previous lot services' page for that lot
  And I see the existing service in the copyable services table

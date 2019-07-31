@admin
Feature: Admin acknowledging service edits

Background:
  Given I have a published service on a live G-Cloud framework
  And I ensure that all update audit events for that service are acknowledged

Scenario: Admin approves service edits
  Given I choose a random sentence
  And user 'functional.test@example.com' sets the serviceDescription of that service to that random_sentence
  And I am logged in as the existing admin-ccs-category user
  And I am on the 'Admin' page
  When I click 'Review service changes'
  Then I am on the 'Check edits to services' page
  And I don't see a banner message
  And I see that service.supplierName in the 'Edited services' summary table
  When I click the summary table 'View changes' link for that service.id
  Then I am on that service.serviceName page
  And I see 'functional.test@example.com made 1 edit' in the page's main
  And I see that random_sentence in the page's ins

  # Before we approve the edit we're going to test a race condition of the supplier re-editing the service
  # before approval

  When I choose a random sentence
  And user 'functional.test@example.com' sets the serviceDescription of that service to that random_sentence
  And I click the 'Approve edit' button
  Then I am on the 'Check edits to services' page
  And I see a success banner message containing that service.id

  # However we still haven't approved the second edit

  And I see that service.supplierName in the 'Edited services' summary table
  When I click the summary table 'View changes' link for that service.id
  Then I am on that service.serviceName page
  And I see 'functional.test@example.com made 1 edit' in the page's main
  # This is the second random_sentence now of course
  And I see that random_sentence in the page's ins

  When I click the 'Approve edit' button
  Then I am on the 'Check edits to services' page
  And I see a success banner message containing that service.id
  And I don't see that service.id in the 'Edited services' summary table
  And that service has no unacknowledged update audit events

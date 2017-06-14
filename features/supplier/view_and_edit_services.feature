@view_dos_service
Feature: Supplier being able to view their DOS services

Background:
  Given I have a live digital outcomes and specialists framework
  And I have a supplier
  And that supplier is logged in
  Given that supplier is on that framework

# do for all lots
Scenario: Supplier coming from dashboard to view the detail page for their DOS service
  Given that supplier has a service on the digital-specialists lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click 'Digital specialists'
  Then I am on the 'Digital specialists' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  # assert some content from summary table is shown (like individual specialist roles)

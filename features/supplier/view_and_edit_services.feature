@view_dos_service
Feature: Supplier being able to view their DOS services

Background:
  Given I have a live digital outcomes and specialists framework
  And I have a supplier
  And that supplier is logged in
  Given that supplier is on that framework

Scenario: Supplier coming from dashboard to view the detail page for their digital-specialists service
  Given that supplier has a service on the digital-specialists lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click 'Digital specialists'

  Then I am on the 'Digital specialists' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  And I see 'Agile coach' in the 'Individual specialist roles' summary table

Scenario: Supplier coming from dashboard to view the detail page for their digital-outcomes service
  Given that supplier has a service on the digital-outcomes lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click 'Digital outcomes'

  Then I am on the 'Digital outcomes' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  And I see 'Agile coaching' in the 'Team capabilities' summary table

Scenario: Supplier coming from dashboard to view the detail page for their user-research-participants service
  Given that supplier has a service on the user-research-participants lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click 'User research participants'

  Then I am on the 'User research participants' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  And I see 'Entirely offline' in the 'Recruitment approach' summary table

Scenario: Supplier coming from dashboard to view the detail page for their user-research-studios service
  Given that supplier has a service on the user-research-studios lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click 'GDSvieux Innovation Lab'

  Then I am on the 'GDSvieux Innovation Lab' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  And I see 'GDSbury' in the 'Lab address' summary table

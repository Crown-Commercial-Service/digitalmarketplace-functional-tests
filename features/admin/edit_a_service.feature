@edit-a-service
Feature: Edit a service

Scenario: Only Service Manager can edit services
  Given I am logged in as the production admin-ccs-category user
  # TODO get me here from the search
  #  And I have a random g-cloud service from the api
  #  And I am on the /admin/services/@service['id'] page
  And I am on the /admin/services/1123456789012346 page
  And I see '£100 to £1234 per person per week' text on the page
  When I click the top-level summary table Edit link for the section 'Pricing'
  And I enter '1000' in the 'Minimum price' field
  And I click the 'Save and return to summary' button
  Then I see '£1000 to £1234 per person per week' text on the page
  When I click the top-level summary table Edit link for the section 'Pricing'
  And I enter '100' in the 'Minimum price' field
  And I click the 'Save and return to summary' button
  Then I see '£100 to £1234 per person per week' text on the page

Scenario Outline: Correct users cannot edit services
  Given I am logged in as the production <role> user
  When I am on the /admin/services/1123456789012346 page
  Then I don't see the 'Edit' link
  When I am on the /admin/services/1123456789012346/edit/pricing page
  And I take a screenshot
  Then I am on the 'You don’t have permission to perform this action' page

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin                   |

@remove-a-service
Feature: Remove a service

Scenario: Only Service Manager can remove services
  Given I am logged in as the production admin-ccs-category user
  # TODO get me here from the search
#  And I have a random g-cloud service from the api
#  And I am on the /admin/services/@service['id'] page
  And I am on the /admin/services/1123456789012346 page
  When I click the 'Remove service' link
  Then I see a destructive banner message containing 'Are you sure you want to remove ‘1123456789012346 DM Functional Test N3 Secure Remote Access’?'
  When I click 'Remove'
  Then I see a temporary-message banner message containing 'Removed by digital-marketplace-development+preview-admin-ccs-category@digital.cabinet-office.gov.uk'
  When I click 'Publish service'
  Then I see a destructive banner message containing 'Are you sure you want to publish ‘1123456789012346 DM Functional Test N3 Secure Remote Access’?'
  When I click 'Publish'
  Then I see a success banner message containing 'You published ‘1123456789012346 DM Functional Test N3 Secure Remote Access’.'

Scenario Outline: Correct users cannot remove services
  Given I am logged in as the production <role> user
  And I am on the /admin/services/1123456789012346 page
  Then I don't see the 'Remove service' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin                   |

@view-a-service
Feature: View a service

Scenario Outline: Correct user can access the service page
  Given I am logged in as the production <role> user
  # TODO GET ME HERE FROM THE LOGIN
  And I am on the /admin/services/1123456789012346 page
  Then I am on the '1123456789012346 DM Functional Test N3 Secure Remote Access' page

  Examples:
    | role               |
    | admin              |
    | admin-ccs-category |

Scenario Outline: Correct users cannot access the service page
  Given I am logged in as the production <role> user
  # TODO GET ME HERE FROM THE LOGIN
  And I am on the /admin/services/1123456789012346 page
  Then I am on the 'You don’t have permission to perform this action' page

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |


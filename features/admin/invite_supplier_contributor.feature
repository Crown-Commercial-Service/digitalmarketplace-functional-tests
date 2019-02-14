@admin @invite-supplier-contributor
Feature: Invite a contributor to a supplier account

@requires-credentials @notify
Scenario Outline: Correct users can invite a contributors to a supplier account
  Given I am logged in as the existing <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier - Invite a contributor feature |
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier - Invite a contributor feature' in the 'supplier_name' field and click its associated 'Search' button
  And I click the summary table 'Users' link for the 'DM Functional Test Supplier - Invite a contributor feature' link
  When I enter 'simulate-delivered@notifications.service.gov.uk' in the 'Email address' field
  And I click the 'Send invitation' button
  Then I see a success banner message containing 'User invited'

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Prohibited user roles cannot manage supplier users
  Given I am logged in as the existing <role> user
  When I visit the /admin/suppliers?supplier_name=DM+Functional+Test+Supplier+-+Invite+a+contributor+feature page
  Then I don't see the 'Users' link

  Examples:
    | role                    |
    | admin-ccs-sourcing      |
    | admin-manager           |

Scenario Outline: Prohibited user roles cannot invite users to a supplier
  Given I am logged in as the existing <role> user
  When I visit the /admin/suppliers?supplier_name=DM+Functional+Test+Supplier+-+Invite+a+contributor+feature page
  And I click the summary table 'Users' link for the 'DM Functional Test Supplier - Invite a contributor feature' link
  Then I don't see the 'Send invitation' button

  Examples:
    | role                      |
    | admin-framework-manager   |
    | admin-ccs-category        |
    | admin-ccs-data-controller |

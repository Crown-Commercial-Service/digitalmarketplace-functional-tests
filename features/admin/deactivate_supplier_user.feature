@deactivate-supplier-user
Feature: Deactivate a supplier's contributor

Scenario Outline: Correct users can deactivate a supplier's contributor
  Given I am logged in as the production <role> user
  And I am on the /admin/suppliers?supplier_name_prefix=DM+Functional+Test+Supplier page
  And I click the summary table 'Users' link for 'DM Functional Test Supplier'
  And I click the summary table 'Deactivate' button for 'DM Functional Test Supplier User 1'

  And I take a screenshot
#  Then I see the 'Suppliers' summary table filled with:
#      | functional-test-new-name | Change name | Users | Services |
#  When I click the summary table 'Change name' link for 'functional-test-new-name'
#  And I enter 'DM Functional Test Supplier' in the 'New name' field
#  And I click the 'Save' button
#  Then I see the 'Suppliers' summary table filled with:
#      | DM Functional Test Supplier | Change name | Users | Services |

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Correct users cannot update the supplier name
  Given I am logged in as the production <role> user
  When I am on the /admin/suppliers?supplier_name_prefix=DM+Functional+Test+Supplier page
  Then I don't see the 'Users' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin-ccs-category      |

@update-supplier-name
Feature: Update supplier name

Scenario Outline: Correct users can edit a supplier name
  Given I am logged in as the production <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier |
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click a summary table 'Change name' link for 'DM Functional Test Supplier'
  When I enter 'DM Functional Test Supplier Changed Name' in the 'New name' field
  And I click the 'Save' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                     | Change name | Users | Services |
    | DM Functional Test Supplier Changed Name | Change name | Users | Services |
  When I click a summary table 'Change name' link for 'DM Functional Test Supplier Changed Name'
  And I enter 'DM Functional Test Supplier' in the 'New name' field
  And I click the 'Save' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                        | Change name | Users | Services |
    | DM Functional Test Supplier | Change name | Users | Services |

  Examples:
    | role                    | link-name                               |
    | admin                   | Edit supplier accounts or view services |
    | admin-ccs-category      | Edit suppliers and services             |

Scenario Outline: Correct users cannot update the supplier name
  Given I am logged in as the production <role> user
  When I am on the /admin/suppliers?supplier_name_prefix=DM+Functional+Test+Supplier page
  Then I don't see the 'Change name' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |

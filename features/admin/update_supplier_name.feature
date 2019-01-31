@admin @update-supplier-name
Feature: Update supplier name

Scenario Outline: Correct users can edit a supplier name
  Given I am logged in as the existing <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier - Update supplier name feature |
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier - Update supplier name feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click a summary table 'Change name' link for 'DM Functional Test Supplier - Update supplier name feature'
  When I enter 'DM Functional Test Supplier - Update supplier name feature - Changed Name' in the 'New name' field
  And I click the 'Save' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                                      | Change name | Users | Services |
    | DM Functional Test Supplier - Update supplier name feature - Changed Name | Change name | Users | Services |
  When I click a summary table 'Change name' link for 'DM Functional Test Supplier - Update supplier name feature - Changed Name'
  And I enter 'DM Functional Test Supplier - Update supplier name feature' in the 'New name' field
  And I click the 'Save' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                       | Change name | Users | Services |
    | DM Functional Test Supplier - Update supplier name feature | Change name | Users | Services |

  Examples:
    | role                    | link-name                               |
    | admin                   | Edit supplier accounts or view services |
    | admin-ccs-category      | Edit suppliers and services             |

Scenario Outline: Correct users cannot update the supplier name
  Given I am logged in as the existing <role> user
  When I visit the /admin/suppliers?supplier_name=DM+Functional+Test+Supplier+-+Update+supplier+name+feature page
  Then I don't see the 'Change name' link

  Examples:
    | role                      |
    | admin-framework-manager   |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-data-controller |

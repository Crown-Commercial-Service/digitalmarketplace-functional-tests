@admin @search-supplier-name
Feature: Search by registered supplier name

Scenario Outline: Correct users search for a supplier by registered name
  Given I am logged in as the production <role> user
  And I have a supplier with:
    | name           | DM Functional Test Supplier - Search supplier name feature |
    | registeredName | DM Functional Test Supplier - Search registered supplier name |
  And I click the '<link-name>' link
  And I enter 'Functional Test Supplier - Search registered' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                       | Change name | Users | Services |
    | DM Functional Test Supplier - Search supplier name feature | Change name | Users | Services |

  Examples:
    | role                    | link-name                               |
    | admin                   | Edit supplier accounts or view services |
    | admin-ccs-category      | Edit suppliers and services             |

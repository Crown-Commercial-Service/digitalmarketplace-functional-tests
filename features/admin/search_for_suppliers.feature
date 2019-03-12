@admin
Feature: Search for suppliers by registered name, DUNS number and companies house number

@search-supplier-name
Scenario Outline: Correct users search for a supplier by registered name
  Given I am logged in as the existing <role> user
  And I have a supplier with:
    | name           | DM Functional Test Supplier - Search supplier name feature |
    | registeredName | DM Functional Test Supplier - Search registered supplier name |
  And I click the '<link-name>' link
  And I enter 'Functional Test Supplier - Search registered' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                       | Users | Services |
    | DM Functional Test Supplier - Search supplier name feature | Users | Services |

  Examples:
    | role                      | link-name                               |
    | admin                     | Edit supplier accounts or view services |
    | admin-ccs-category        | Edit suppliers and services             |
    | admin-ccs-data-controller | View and edit suppliers                 |


@search-supplier-name @with-admin-ccs-sourcing-user
  Scenario: CCS Sourcing user can search for a supplier by registered name
  Given I am logged in as the existing admin-ccs-sourcing user
  And I have a supplier with:
    | name           | DM Functional Test Supplier - Search supplier name feature |
    | registeredName | DM Functional Test Supplier - Search registered supplier name |
  And I click the 'Edit supplier declarations' link
  And I enter 'Functional Test Supplier - Search registered' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                       |
    | DM Functional Test Supplier - Search supplier name feature |

@search-supplier-duns @with-admin-ccs-data-controller-user
Scenario: Admin data controller user can search for a supplier by DUNS number
  Given I am logged in as the existing admin-ccs-data-controller user
  And I have a random supplier from the API
  And I click the 'View and edit suppliers' link
  And I click the 'DUNS Number' link
  When I enter that supplier.dunsNumber in the 'Find a supplier by DUNS number' field
  And I click the 'find_supplier_by_duns_number_search' button
  And I see that supplier in the list of suppliers


@search-supplier-company-number @with-admin-ccs-data-controller-user
Scenario: Admin data controller user can search for a supplier by companies house number
  Given I am logged in as the existing admin-ccs-data-controller user
  And I have a supplier with:
    | name                 | DM Functional Test Supplier - Search companies house number feature |
    | companiesHouseNumber | 01234567                                                            |
  And I click the 'View and edit suppliers' link
  And I click the 'Company registration number' link
  When I enter '01234567' in the 'Find a supplier by company registration number' field
  And I click the 'find_supplier_by_company_registration_number_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Name                                                                | Users | Services |
    | DM Functional Test Supplier - Search companies house number feature | Users | Services |

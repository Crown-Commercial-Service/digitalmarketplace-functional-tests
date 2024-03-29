@admin @company-details
Feature: Company details page

Background:
  # Now that G-Cloud 12 has expired, we cannot have G-Cloud 12 services
  #
  # Given I have the latest live g-cloud framework with the cloud-support lot
  And I have a supplier with:
      | name                 | DM Functional Test Supplier - Company details feature |
      | registeredName       | DM Functional Test Suppliers Ltd.                     |
      | companiesHouseNumber | 87654321                                              |
  And that supplier has a user with:
      | name   | DM Functional Test - Supplier Mr Muffins |
      | email  | muffins@example.com |
  # And that supplier has applied to be on that framework
  # And we accepted that suppliers application to the framework
  # And that supplier has returned a signed framework agreement for the framework
  # And that supplier has a service on the cloud-support lot

Scenario Outline: Correct admin roles can view a supplier's details
  Given I am logged in as the existing <role> user
  And I am on the 'Admin' page
  When I click '<link-name>'
  Then I am on the '<page-title>' page
  And I enter 'DM Functional Test Supplier - Company details feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Supplier Name                                         | Users | Services |
    | DM Functional Test Supplier - Company details feature | Users | Services |
  And I click the 'DM Functional Test Supplier - Company details feature' link
  Then I am on the 'DM Functional Test Supplier - Company details feature' page
  And I see the 'Company details for supplier account' summary table filled with:
    | field                        | value                                |
    | Company registered name      | DM Functional Test Suppliers Ltd.    |
    | Company registration number  | 87654321                             |
    | DUNS Number                  | <ANY>                                |
    | Address                      | 14 Duke Street Dublin H3 LY5 Ireland |
  # And I see the framework the supplier is on in the 'Frameworks' table
  When I click the 'Users' link
  Then I am on the 'DM Functional Test Supplier - Company details feature' page
  And I see an entry in the 'Users' table with:
    | Name                                     | Email address   | Last login | Pwd changed | Locked | Status |
    | DM Functional Test - Supplier Mr Muffins | <ANY>           | <ANY>      | <ANY>       | No     | <ANY>  |

  Examples:
    | role                      | link-name                               | page-title                              |
    | admin                     | Edit supplier accounts or view services | Edit supplier accounts or view services |

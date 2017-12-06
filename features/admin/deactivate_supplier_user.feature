@deactivate-supplier-user
Feature: Deactivate a supplier's contributor

Scenario Outline: Correct users can deactivate and reactivate a supplier's contributor
  Given I am logged in as the production <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier |
  And that supplier has a user with:
    | name          | DM Functional Test Supplier User 1                               |
    | email_address | dm-functional-test-supplier-user-1@digital.cabinet-office.gov.uk |
  And that supplier has a user with:
    | name          | DM Functional Test Supplier User 2                               |
    | email_address | dm-functional-test-supplier-user-2@digital.cabinet-office.gov.uk |
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click the summary table 'Users' link for 'DM Functional Test Supplier'
  When I click the summary table 'Deactivate' button for 'DM Functional Test Supplier User 1'
  Then I see an entry in the 'Users' table with:
    | Name                               | Email address                                                    | Last login  | Pwd changed | Locked |
    | DM Functional Test Supplier User 1 | dm-functional-test-supplier-user-1@digital.cabinet-office.gov.uk | <ANY>       | <ANY>       | No     |
  When I click the summary table 'Activate' button for 'DM Functional Test Supplier User 1'
  Then I see an entry in the 'Users' table with:
    | Name                               | Email address                                                    | Last login  | Pwd changed | Locked |
    | DM Functional Test Supplier User 1 | dm-functional-test-supplier-user-1@digital.cabinet-office.gov.uk | <ANY>       | <ANY>       | No     |

  Examples:
    | role  |
    | admin |

Scenario Outline: Correct users cannot update suppliers users
  Given I am logged in as the production <role> user
  When I am on the /admin/suppliers?supplier_name_prefix=DM+Functional+Test+Supplier page
  Then I don't see the 'Users' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin-ccs-category      |

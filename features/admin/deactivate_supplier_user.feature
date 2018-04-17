@deactivate-supplier-user
Feature: Deactivate a supplier's contributor

Background:
  Given I have a supplier with:
    | name          | DM Functional Test Supplier |
  And that supplier has a user with:
    | name          | DM Functional Test Supplier User #1 |
    | email_address | user-one@example.com                |
  And that supplier has a user with:
    | name          | DM Functional Test Supplier User #2 |
    | email_address | user-two@example.com                |

Scenario Outline: Correct users can deactivate and reactivate a supplier's contributor
  Given I am logged in as the production <role> user
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click a summary table 'Users' link for 'DM Functional Test Supplier'
  When I click the summary table 'Deactivate' button for 'DM Functional Test Supplier User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                | Email address        | Last login  | Pwd changed | Locked |
    | DM Functional Test Supplier User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |
  When I click the summary table 'Activate' button for 'DM Functional Test Supplier User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                | Email address        | Last login  | Pwd changed | Locked |
    | DM Functional Test Supplier User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |

  Examples:
    | role  |
    | admin |

Scenario Outline: Correct users can view but not deactivate suppliers users
  Given I am logged in as the production <role> user
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  When I click a summary table 'Users' link for 'DM Functional Test Supplier'
  Then I don't see the 'Deactivate' button
  And I see an entry in the 'Users' table with:
    | Name                                | Email address        | Last login  | Pwd changed | Locked | Status |
    | DM Functional Test Supplier User #1 | user-one@example.com | <ANY>       | <ANY>       | No     | Active |
  And I see an entry in the 'Users' table with:
    | Name                                | Email address        | Last login  | Pwd changed | Locked | Status |
    | DM Functional Test Supplier User #2 | user-two@example.com | <ANY>       | <ANY>       | No     | Active |

  Examples:
    | role                    | link-name                   |
    | admin-ccs-category      | Edit suppliers and services |
    | admin-framework-manager | View suppliers and services |

Scenario Outline: Correct users cannot view suppliers users
  Given I am logged in as the production <role> user
  When I am on the /admin/suppliers?supplier_name_prefix=DM+Functional+Test+Supplier page
  Then I don't see the 'Users' link

  Examples:
    | role                    |
    | admin-ccs-sourcing      |
    | admin-manager           |

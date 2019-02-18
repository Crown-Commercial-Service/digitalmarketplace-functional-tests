@admin @deactivate-supplier-user
Feature: Deactivate a supplier's contributor

Background:
  Given I have a supplier with:
    | name          | DM Functional Test Supplier - Deactivate a suppliers contributor feature |
  And that supplier has a user with:
    | name          | Deactivate a suppliers contributor feature User #1 |
    | email_address | user-one@example.com                               |
  And that supplier has a user with:
    | name          | Deactivate a suppliers contributor feature User #2 |
    | email_address | user-two@example.com                               |

@skip-staging
Scenario Outline: Correct users can deactivate and reactivate a supplier's contributor
  Given I am logged in as the existing <role> user
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click the summary table 'Users' link for the 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' link
  When I click the summary table 'Deactivate' button for 'Deactivate a suppliers contributor feature User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |
  When I click the summary table 'Activate' button for 'Deactivate a suppliers contributor feature User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |

  Examples:
    | role  |
    | admin |

@skip-preview @skip-local
Scenario Outline: Correct users can deactivate and reactivate a supplier's contributor
  Given I am logged in as the existing <role> user
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click a summary table 'Users' link for 'DM Functional Test Supplier - Deactivate a suppliers contributor feature'
  When I click the summary table 'Deactivate' button for 'Deactivate a suppliers contributor feature User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |
  When I click the summary table 'Activate' button for 'Deactivate a suppliers contributor feature User #1'
  Then I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     |
  Examples:
    | role  |
    | admin |

@skip-staging
Scenario Outline: Correct users can view but not deactivate suppliers users
  Given I am logged in as the existing <role> user
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  When I click the summary table 'Users' link for the 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' link
  And I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked | Status |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     | Active |
  And I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked | Status |
    | Deactivate a suppliers contributor feature User #2 | user-two@example.com | <ANY>       | <ANY>       | No     | Active |

  Examples:
    | role                    | link-name                   |
    | admin-ccs-category      | Edit suppliers and services |
    | admin-framework-manager | View suppliers and services |

@skip-preview @skip-local
Scenario Outline: Correct users can view but not deactivate suppliers users
  Given I am logged in as the existing <role> user
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier - Deactivate a suppliers contributor feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  When I click a summary table 'Users' link for 'DM Functional Test Supplier - Deactivate a suppliers contributor feature'
  Then I don't see the 'Deactivate' button
  And I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked | Status |
    | Deactivate a suppliers contributor feature User #1 | user-one@example.com | <ANY>       | <ANY>       | No     | Active |
  And I see an entry in the 'Users' table with:
    | Name                                               | Email address        | Last login  | Pwd changed | Locked | Status |
    | Deactivate a suppliers contributor feature User #2 | user-two@example.com | <ANY>       | <ANY>       | No     | Active |
  Examples:
    | role                    | link-name                   |
    | admin-ccs-category      | Edit suppliers and services |
    | admin-framework-manager | View suppliers and services |

Scenario Outline: Correct users cannot view suppliers users
  Given I am logged in as the existing <role> user
  When I visit the /admin/suppliers?supplier_name=DM+Functional+Test+Supplier+-+Deactivate+a+supplier's+contributor+feature page
  Then I don't see the 'Users' link

  Examples:
    | role                      |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-data-controller |

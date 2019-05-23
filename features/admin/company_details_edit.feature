@admin @company-details-edit
Feature: Editing company details

Background:
  Given I have the latest live g-cloud framework with the cloud-support lot
  And I have a supplier with:
      | name                 | DM Functional Test Supplier - Edit company details feature |
      | registeredName       | We Edit Company Details Ltd.                               |
      | companiesHouseNumber | 87654321                                                   |
  And that supplier has a user with:
      | name   | DM Functional Test - Supplier Mr Muffins |
      | email  | muffins@example.com |
  And that supplier has applied to be on that framework
  And we accepted that suppliers application to the framework
  And that supplier has returned a signed framework agreement for the framework
  And that supplier has a service on the cloud-support lot

@with-admin-ccs-data-controller-user @skip-local @skip-preview
Scenario: Admin CCS Data Controller can edit a supplier's details
  Given I am logged in as the existing admin-ccs-data-controller user
  And I am on the 'Admin' page
  When I click 'View and edit suppliers'
  Then I am on the 'Search for suppliers' page
  When I enter 'DM Functional Test Supplier - Edit company details feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Supplier Name                                              | Users | Services |
    | DM Functional Test Supplier - Edit company details feature | Users | Services |
  When I click the 'DM Functional Test Supplier - Edit company details feature' link
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page

  When I click the summary table 'Change' link for 'Company registered name'
  Then I am on the 'Update registered company name for ‘DM Functional Test Supplier - Edit company details feature’' page
  When I enter 'We Have Edited These Company Details Ltd.' in the 'Registered company name' field and click its associated 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for G-Cloud 10' summary table filled with:
    | field                        | value                                           |
    | Company registered name      | We Have Edited These Company Details Ltd.       |
    | Company registration number  | 87654321                                        |
    | DUNS Number                  | <ANY>                                           |
    | Address                      | 10 Downing Street London AB1 2CD United Kingdom |

  When I click the summary table 'Change' link for 'Company registration number'
  Then I am on the 'Update registered company number for ‘DM Functional Test Supplier - Edit company details feature’' page
  And I enter '12345678' in the 'Companies House number' field and click its associated 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for G-Cloud 10' summary table filled with:
    | field                        | value                                           |
    | Company registered name      | We Have Edited These Company Details Ltd.       |
    | Company registration number  | 12345678                                        |
    | DUNS Number                  | <ANY>                                           |
    | Address                      | 10 Downing Street London AB1 2CD United Kingdom |

  When I click the summary table 'Change' link for 'DUNS Number'
  Then I see 'You need to contact cloud_digital@crowncommercial.gov.uk to change a supplier DUNS number.' text on the page
  And I click 'Return to ‘DM Functional Test Supplier - Edit company details feature’ company details'
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page

  When I click the summary table 'Change' link for 'Address'
  Then I am on the 'Update registered company address for ‘DM Functional Test Supplier - Edit company details feature’' page
  And I enter '11 Downing Street' in the 'Building and street' field
  And I enter 'New London' in the 'Town or city' field
  And I enter 'EF1 2GH' in the 'Postcode' field
  And I enter 'France' in the 'location-autocomplete' field and click the selected autocomplete option
  And I click the 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for G-Cloud 10' summary table filled with:
    | field                        | value                                       |
    | Company registered name      | We Have Edited These Company Details Ltd.   |
    | Company registration number  | 12345678                                    |
    | DUNS Number                  | <ANY>                                       |
    | Address                      | 11 Downing Street New London EF1 2GH France |

  # Reset details for next test run
  When I click the summary table 'Change' link for 'Company registered name'
  When I enter 'We Edit Company Details Ltd.' in the 'Registered company name' field and click its associated 'Save' button
  When I click the summary table 'Change' link for 'Company registration number'
  And I enter '87654321' in the 'Companies House number' field and click its associated 'Save' button
  When I click the summary table 'Change' link for 'Address'
  And I enter '10 Downing Street' in the 'Building and street' field
  And I enter 'London' in the 'Town or city' field
  And I enter 'AB1 2CD' in the 'Postcode' field
  And I enter 'United Kingdom' in the 'location-autocomplete' field and click the selected autocomplete option
  And I click the 'Save' button

@with-admin-ccs-data-controller-user @skip-staging
Scenario: Admin CCS Data Controller can edit a supplier's details
  Given I am logged in as the existing admin-ccs-data-controller user
  And I am on the 'Admin' page
  When I click 'View and edit suppliers'
  Then I am on the 'Search for suppliers' page
  When I enter 'DM Functional Test Supplier - Edit company details feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  Then I see an entry in the 'Suppliers' table with:
    | Supplier Name                                              | Users | Services |
    | DM Functional Test Supplier - Edit company details feature | Users | Services |
  When I click the 'DM Functional Test Supplier - Edit company details feature' link
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page

  When I click the summary table 'Change' link for 'Company registered name'
  Then I am on the 'Update registered company name for ‘DM Functional Test Supplier - Edit company details feature’' page
  When I enter 'We Have Edited These Company Details Ltd.' in the 'Registered company name' field and click its associated 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for supplier account' summary table filled with:
    | field                        | value                                           |
    | Company registered name      | We Have Edited These Company Details Ltd.       |
    | Company registration number  | 87654321                                        |
    | DUNS Number                  | <ANY>                                           |
    | Address                      | 10 Downing Street London AB1 2CD United Kingdom |

  When I click the summary table 'Change' link for 'Company registration number'
  Then I am on the 'Update registered company number for ‘DM Functional Test Supplier - Edit company details feature’' page
  And I enter '12345678' in the 'Companies House number' field and click its associated 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for supplier account' summary table filled with:
    | field                        | value                                           |
    | Company registered name      | We Have Edited These Company Details Ltd.       |
    | Company registration number  | 12345678                                        |
    | DUNS Number                  | <ANY>                                           |
    | Address                      | 10 Downing Street London AB1 2CD United Kingdom |

  When I click the summary table 'Change' link for 'DUNS Number'
  Then I see 'You need to contact cloud_digital@crowncommercial.gov.uk to change a supplier DUNS number.' text on the page
  And I click 'Return to ‘DM Functional Test Supplier - Edit company details feature’ company details'
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page

  When I click the summary table 'Change' link for 'Address'
  Then I am on the 'Update registered company address for ‘DM Functional Test Supplier - Edit company details feature’' page
  And I enter '11 Downing Street' in the 'Building and street' field
  And I enter 'New London' in the 'Town or city' field
  And I enter 'EF1 2GH' in the 'Postcode' field
  And I enter 'France' in the 'location-autocomplete' field and click the selected autocomplete option
  And I click the 'Save' button
  Then I am on the 'DM Functional Test Supplier - Edit company details feature' page
  And I see a success banner message containing 'The details for ‘DM Functional Test Supplier - Edit company details feature’ have been updated.'
  And I see the 'Company details for supplier account' summary table filled with:
    | field                        | value                                       |
    | Company registered name      | We Have Edited These Company Details Ltd.   |
    | Company registration number  | 12345678                                    |
    | DUNS Number                  | <ANY>                                       |
    | Address                      | 11 Downing Street New London EF1 2GH France |

  # Reset details for next test run
  When I click the summary table 'Change' link for 'Company registered name'
  When I enter 'We Edit Company Details Ltd.' in the 'Registered company name' field and click its associated 'Save' button
  When I click the summary table 'Change' link for 'Company registration number'
  And I enter '87654321' in the 'Companies House number' field and click its associated 'Save' button
  When I click the summary table 'Change' link for 'Address'
  And I enter '10 Downing Street' in the 'Building and street' field
  And I enter 'London' in the 'Town or city' field
  And I enter 'AB1 2CD' in the 'Postcode' field
  And I enter 'United Kingdom' in the 'location-autocomplete' field and click the selected autocomplete option
  And I click the 'Save' button

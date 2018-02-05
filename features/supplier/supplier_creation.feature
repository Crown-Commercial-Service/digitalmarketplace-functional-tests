@supplier-creation @skip-preview
Feature: Create new supplier account

Background:
  Given There is at least one framework that can be applied to

Scenario: User steps through supplier account creation process
  Given I am on the homepage
  When I click 'Become a supplier'
  Then I am on the 'Become a supplier' page

  When I click 'Create a supplier account'
  Then I am on the 'Create a supplier account' page

  When I click 'Start'
  Then I am on the 'DUNS number' page

  When I enter '000000001' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Companies House number (optional)' page

  When I enter 'SC000001' in the 'companies_house_number' field
  And I click 'Continue'
  Then I am on the 'Company name' page

  When I enter 'This is a test company name' in the 'company_name' field
  And I click 'Continue'
  Then I am on the 'Company contact details' page

  When I enter 'Company contact name' in the 'contact_name' field
  Then I enter 'test.company.email@test.com' in the 'email_address' field
  Then I enter '0123456789' in the 'phone_number' field
  And I click 'Continue'
  Then I am on the 'Create login' page

  When I enter 'test.supplier.email@test.com' in the 'email_address' field
  And I click 'Continue'
  Then I am on the 'Check your information' page
  And I see the 'Your company details' summary table filled with:
    | field                  | value                       |
    | DUNS number            | 000000001                   |
    | Companies House number | SC000001                    |
    | Company name           | This is a test company name |
    | Contact name           | Company contact name        |
    | Contact email          | test.company.email@test.com |
    | Contact phone number   | 0123456789                  |
  And I see the 'Your login details' summary table filled with:
    | field                  | value                        |
    | Email address          | test.supplier.email@test.com |

  When I update the value of 'DUNS number' to '000000002' using the summary table 'Edit' link
  And I update the value of 'Companies House number' to 'SC000002' using the summary table 'Edit' link
  And I update the value of 'Company name' to 'Changed test company name' using the summary table 'Edit' link
  And I update the value of 'Contact name' to 'Changed contact name' using the summary table 'Edit' link
  And I update the value of 'Contact email' to 'test.changed.email@test.com' using the summary table 'Edit' link
  And I update the value of 'Contact phone number' to '9876543210' using the summary table 'Edit' link
  Then I see the 'Your company details' summary table filled with:
    | field                  | value                       |
    | DUNS number            | 000000002                   |
    | Companies House number | SC000002                    |
    | Company name           | Changed test company name   |
    | Contact name           | Changed contact name        |
    | Contact email          | test.changed.email@test.com |
    | Contact phone number   | 9876543210                  |

  When I click the summary table 'Edit' link for 'Email address'
  And I enter 'changed.test.email@test.com' in the 'Your email address' field and click its associated 'Continue' button
  Then I see the 'Your login details' summary table filled with:
    | field                  | value                        |
    | Email address          | changed.test.email@test.com  |

  # We can't ever click the "Create account" button to check the final page because this will create a supplier entry
  # with DUNS number 000000001 and the test will never pass again.




@supplier-creation @skip-preview @skip-staging
Feature: Create new supplier account

Background:
  Given There is at least one framework that can be applied to

Scenario: User steps through supplier account creation process
  Given I am on the homepage
  When I click 'Become a supplier'
  Then I am on the 'Become a supplier' page

  When I click 'Create a supplier account'
  Then I am on the 'Create a supplier account' page

  When I click 'Start'
  Then I am on the 'DUNS number' page

  When I enter '000000001' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Company name' page

  When I enter 'This is a test company name' in the 'company_name' field
  And I click 'Continue'
  Then I am on the 'Company contact details' page

  When I enter 'Company contact name' in the 'contact_name' field
  Then I enter 'test.company.email@test.com' in the 'email_address' field
  Then I enter '0123456789' in the 'phone_number' field
  And I click 'Continue'
  Then I am on the 'Create login' page

  When I enter 'test.supplier.email@test.com' in the 'email_address' field
  And I click 'Continue'
  Then I am on the 'Check your information' page
  And I see the 'Your company details' summary table filled with:
    | field                  | value                       |
    | DUNS number            | 000000001                   |
    | Company name           | This is a test company name |
    | Contact name           | Company contact name        |
    | Contact email          | test.company.email@test.com |
    | Contact phone number   | 0123456789                  |
  And I see the 'Your login details' summary table filled with:
    | field                  | value                        |
    | Email address          | test.supplier.email@test.com |

  When I update the value of 'DUNS number' to '000000002' using the summary table 'Edit' link
  And I update the value of 'Company name' to 'Changed test company name' using the summary table 'Edit' link
  And I update the value of 'Contact name' to 'Changed contact name' using the summary table 'Edit' link
  And I update the value of 'Contact email' to 'test.changed.email@test.com' using the summary table 'Edit' link
  And I update the value of 'Contact phone number' to '9876543210' using the summary table 'Edit' link
  Then I see the 'Your company details' summary table filled with:
    | field                  | value                       |
    | DUNS number            | 000000002                   |
    | Company name           | Changed test company name   |
    | Contact name           | Changed contact name        |
    | Contact email          | test.changed.email@test.com |
    | Contact phone number   | 9876543210                  |

  When I click the summary table 'Edit' link for 'Email address'
  And I enter 'changed.test.email@test.com' in the 'Your email address' field and click its associated 'Continue' button
  Then I see the 'Your login details' summary table filled with:
    | field                  | value                        |
    | Email address          | changed.test.email@test.com  |

  # We can't ever click the "Create account" button to check the final page because this will create a supplier entry
  # with DUNS number 000000001 and the test will never pass again.

@supplier @supplier-creation
Feature: Create new supplier account

Background:
  Given There is at least one framework that can be applied to

Scenario: User steps through supplier account creation process
  Given I visit the homepage
  When I click 'Become a supplier'
  Then I am on the 'Become a supplier' page

  When I click 'Create a supplier account'
  Then I am on the 'Create a supplier account' page

  When I click 'Start'
  Then I am on the 'DUNS number' page

  When I enter '999999999' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Your company details' page

  When I enter 'This is a test company name' in the 'company_name' field
  And I enter 'Company contact name' in the 'contact_name' field
  And I enter 'murphy.and.company@example.com' in the 'email_address' field
  And I enter '0123456789' in the 'phone_number' field
  And I click 'Continue'
  Then I am on the 'Create login' page

  When I enter 'murphy@example.com' in the 'email_address' field
  And I click 'Continue'
  Then I am on the 'Check your information' page
  And I see the 'Your company details' summary table filled with:
    | field                  | value                          |
    | DUNS number            | 999999999                      |
    | Company name           | This is a test company name    |
    | Contact name           | Company contact name           |
    | Contact email          | murphy.and.company@example.com |
    | Contact phone number   | 0123456789                  |
  And I see the 'Your login details' summary table filled with:
    | field                  | value              |
    | Email address          | murphy@example.com |

  When I update the value of 'DUNS number' to '999999998' using the summary table 'Edit' link and the 'Continue' button
  And I update the value of 'Company name' to 'Changed test company name' using the summary table 'Edit' link and the 'Continue' button
  And I update the value of 'Contact name' to 'Changed contact name' using the summary table 'Edit' link and the 'Continue' button
  And I update the value of 'Contact email' to 'murphy.solo.enterprises@example.com' using the summary table 'Edit' link and the 'Continue' button
  And I update the value of 'Contact phone number' to '9876543210' using the summary table 'Edit' link and the 'Continue' button
  Then I see the 'Your company details' summary table filled with:
    | field                  | value                               |
    | DUNS number            | 999999998                           |
    | Company name           | Changed test company name           |
    | Contact name           | Changed contact name                |
    | Contact email          | murphy.solo.enterprises@example.com |
    | Contact phone number   | 9876543210                          |

  When I click the summary table 'Edit' link for 'Email address'
  And I enter 'd.b.murphy@example.com' in the 'Your email address' field and click its associated 'Continue' button
  Then I see the 'Your login details' summary table filled with:
    | field                  | value                   |
    | Email address          | d.b.murphy@example.com  |

  # We can't ever click the "Create account" button to check the final page because this will create a supplier entry
  # with DUNS number 000000001 and the test will never pass again.

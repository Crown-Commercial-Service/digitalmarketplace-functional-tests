@smoulder-tests @supplier @supplier-creation
Feature: User steps through supplier account creation process

Scenario: Create new supplier account (without duns flow) - summary lists
  Given There is at least one framework that can be applied to
  When I visit the homepage

  When I click 'Become a supplier'
  Then I am on the 'Become a supplier' page

  When I click 'Create a supplier account'
  Then I am on the 'Create a supplier account' page

  When I click 'Start'
  Then I am on the 'Enter your DUNS number' page

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
  And I see the 'Your company details' summary list filled with:
    | field                  | value                          |
    | DUNS number            | 999999999                      |
    | Company name           | This is a test company name    |
    | Contact name           | Company contact name           |
    | Contact email          | murphy.and.company@example.com |
    | Contact phone number   | 0123456789                  |
  And I see the 'Your login details' summary list filled with:
    | field                  | value              |
    | Email address          | murphy@example.com |

  When I update the value of 'DUNS number' to '999999998' using the summary list 'Change' link and the 'Continue' button
  And I update the value of 'Company name' to 'Changed test company name' using the summary list 'Change' link and the 'Continue' button
  And I update the value of 'Contact name' to 'Changed contact name' using the summary list 'Change' link and the 'Continue' button
  And I update the value of 'Contact email' to 'murphy.solo.enterprises@example.com' using the summary list 'Change' link and the 'Continue' button
  And I update the value of 'Contact phone number' to '9876543210' using the summary list 'Change' link and the 'Continue' button
  Then I see the 'Your company details' summary list filled with:
    | field                  | value                               |
    | DUNS number            | 999999998                           |
    | Company name           | Changed test company name           |
    | Contact name           | Changed contact name                |
    | Contact email          | murphy.solo.enterprises@example.com |
    | Contact phone number   | 9876543210                          |

  When I click the summary list 'Change' link for 'Email address'
  And I enter 'd.b.murphy@example.com' in the 'Your email address' field and click its associated 'Continue' button
  Then I see the 'Your login details' summary list filled with:
    | field                  | value                   |
    | Email address          | d.b.murphy@example.com  |

  # We can't ever click the "Create account" button to check the final page because this will create a supplier entry
  # with DUNS number 000000001 and the test will never pass again.

Scenario: Create new supplier account (with duns flow) - summary lists
  Given There is at least one framework that can be applied to
  When I visit the homepage
  When I click 'Become a supplier'
  And I click 'Create a supplier account'
  And I click 'Start'
  Then I am on the 'Enter your DUNS number' page

  When I enter '288305220' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'We found these details' page
  And I see the 'We found these details' summary list filled with:
    | field                  | value                          |
    | DUNS number            | 288305220                      |
    | Company name           | SAVE THE CHILDREN FUND         |

  When I choose the 'Yes' radio button for the 'Is this the company you want to create an account for?' question
  And I click 'Continue'
  Then I am on the 'Your company details' page
  And I see the 'Company name' field prefilled with 'SAVE THE CHILDREN FUND'

  When I enter 'Company contact name' in the 'contact_name' field
  And I enter 'murphy.and.company@example.com' in the 'email_address' field
  And I enter '0123456789' in the 'phone_number' field
  And I click 'Continue'
  Then I am on the 'Create login' page

  When I enter 'murphy@example.com' in the 'email_address' field
  And I click 'Continue'
  Then I am on the 'Check your information' page
  And I see the 'Your company details' summary list filled with:
    | field                  | value                          |
    | DUNS number            | 288305220                      |
    | Company name           | SAVE THE CHILDREN FUND         |
    | Contact name           | Company contact name           |
    | Contact email          | murphy.and.company@example.com |
    | Contact phone number   | 0123456789                     |
  And I see the 'Your login details' summary list filled with:
    | field                  | value              |
    | Email address          | murphy@example.com |

  # We can't ever click the "Create account" button to check the final page because this will create a supplier entry
  # with DUNS number 288305220 and the test will never pass again.

Scenario: DUNS Number already exists
  # Uses DUNS Number for CCS
  Given I visit the /suppliers/create/duns-number page
  And I am on the 'Enter your DUNS number' page
  When I enter '232204180' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Enter your DUNS number' page
  And I see a validation message containing 'DUNS number already used'
  And I see the 'DUNS number' field prefilled with '232204180'

Scenario: DUNS Number does not exist
  Given I visit the /suppliers/create/duns-number page
  And I am on the 'Enter your DUNS number' page
  When I enter '333333333' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Enter your DUNS number' page
  And I see a validation message containing 'DUNS number not found'
  And I see the 'DUNS number' field prefilled with '333333333'

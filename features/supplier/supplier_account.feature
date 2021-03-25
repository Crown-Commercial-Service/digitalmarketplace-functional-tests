@supplier @supplier_account
Feature: Supplier can view and edit their supplier account information

Background:
  Given I have a supplier user
  And that supplier is logged in
  And I visit the /suppliers page

Scenario: Supplier user can provide and change supplier details before confirming them for framework applications
  When I click 'Your company details'
  Then I am on the 'Your company details' page
  And I don't see the 'Save and confirm' button

  When I click the summary list 'Edit' link for 'Contact name'
  And I enter 'New name' in the 'Contact name' field
  And I enter 'new-email@example.com' in the 'Contact email address' field
  And I enter '12345678' in the 'Contact phone number' field
  And I enter 'All fresh' in the 'Supplier summary' field
  And I click 'Save and return'
  Then I see the 'What buyers will see' summary list filled with:
    | field                     | value                           |
    | Contact name              | New name                        |
    | Contact email             | new-email@example.com           |
    | Contact phone number      | 12345678                        |
    | Summary                   | All fresh                       |

  When I click the summary list 'Answer required' link for 'Registered company name'
  Then I am on the 'Registered company name' page
  And I enter 'Toys "ᴙ" Us' in the 'Registered company name' field and click its associated 'Save and return' button

  Then I click the summary list 'Edit' link for 'Registered company address'
  And I am on the 'What is your registered office address?' page
  And I enter '101 Toys Street' in the 'Building and street' field
  And I enter 'Toytown' in the 'Town or city' field
  And I enter 'T0 YSZ' in the 'Postcode' field
  And I enter 'United Kingdom' in the 'Country' field and click the selected autocomplete option
  And I click 'Save and return'

  Then I click the summary list 'Answer required' link for 'Registration number'
  And I am on the 'Are you registered with Companies House?' page
  And I choose 'Yes' radio button
  And I enter '18092231' in the 'companies_house_number' field and click its associated 'Save and return' button

  Then I click the summary list 'Answer required' link for 'Trading status'
  And I am on the 'What’s your trading status?' page
  And I choose 'limited company (LTD)' radio button
  And I click 'Save and return'

  Then I click the summary list 'Answer required' link for 'Company size'
  And I am on the 'What size is your organisation?' page
  And I choose 'Large' radio button
  And I click 'Save and return'

  # Not checking DUNS number here, as the value is random
  Then I see the 'Company details for your framework applications' summary list filled with:
    | field                     |  value                                        |
    | Registered company name   | Toys "ᴙ" Us                                   |
    | Registered company address| 101 Toys Street Toytown T0 YSZ United Kingdom |
    | Registration number       | 18092231                                      |
    | Trading status            | Limited company (LTD)                         |
    | Company size              | Large                                         |

  # Can pull the dunsNumber from the supplier and use it with this step
  And I see 'that supplier.dunsNumber' text on the page

  # This button should only appear once all details are filled in.
  And I see the 'Save and confirm' button

  When I click the summary list 'Edit' link for 'Registered company name'
  Then I am on the 'Registered company name' page
  And I enter 'Toys "ᴙ" Not Us' in the 'Registered company name' field and click its associated 'Save and return' button

  Then I click the summary list 'Edit' link for 'Registered company address'
  And I am on the 'What is your registered office address?' page
  And I enter '101 Liquidation Street' in the 'Building and street' field
  And I enter 'Shutdown' in the 'Town or city' field
  And I enter 'N0 TOY' in the 'Postcode' field
  And I enter 'France' in the 'Country' field and click the selected autocomplete option
  And I click 'Save and return'

  Then I click the summary list 'Edit' link for 'Registration number'
  And I am on the 'Are you registered with Companies House?' page
  And I choose 'Yes' radio button
  And I enter '18092232' in the 'companies_house_number' field and click its associated 'Save and return' button

  Then I click the summary list 'Edit' link for 'Trading status'
  And I am on the 'What’s your trading status?' page
  And I choose 'other' radio button
  And I click 'Save and return'

  Then I click the summary list 'Edit' link for 'Company size'
  And I am on the 'What size is your organisation?' page
  And I choose 'Micro' radio button
  And I click 'Save and return'

  # Duns number is never editable
  Then I click the summary list 'Edit' link for 'DUNS number'
  And I am on the 'Correct a mistake in your DUNS number' page
  And I see 'Contact cloud_digital@crowncommercial.gov.uk to correct a mistake in your:' text on the pages
  And I don't see the 'Save and continue' button
  And I click the 'Return to company details' link

  # Not checking DUNS number here, as the value is random
  Then I see the 'Company details for your framework applications' summary list filled with:
    | field                     |  value                                                |
    | Registered company name   | Toys "ᴙ" Not Us                                       |
    | Registered company address| 101 Liquidation Street Shutdown N0 TOY France         |
    | Registration number       | 18092232                                              |
    | Trading status            | Other                                                 |
    | Company size              | Micro                                                 |

  # Can pull the dunsNumber from the supplier and use it with this step
  And I see 'that supplier.dunsNumber' text on the page

  # Confirming company details should redirect you back to the company details page if not currently applying to a
  # framework
  When I click the 'Save and confirm' button
  Then I am on the 'Your company details' page
  And I don't see the 'Save and confirm' button

  # Certain fields can't be changed after supplier details have been confirmed
  When I click the summary list 'Edit' link for 'Registered company name'
  Then I am on the 'Correct a mistake in your registered company name' page
  And I see 'You must create a new supplier account using a different login email address if you want to change your registered company name.' text on the pages
  And I don't see the 'Save and continue' button
  Then I click the 'Return to company details' link

  Then I click the summary list 'Edit' link for 'Registration number'
  Then I am on the 'Correct a mistake in your registration number' page
  And I see 'You must create a new supplier account using a different login email address if you want to change your registration number.' text on the pages
  And I don't see the 'Save and continue' button
  Then I click the 'Return to company details' link

  Then I click the summary list 'Edit' link for 'DUNS number'
  Then I am on the 'Correct a mistake in your DUNS number' page
  And I see 'You must create a new supplier account using a different login email address if you want to change your DUNS number.' text on the pages
  And I don't see the 'Save and continue' button
  Then I click the 'Return to company details' link

  # Other fields can still be changed after supplier details have been confirmed
  Then I click the summary list 'Edit' link for 'Registered company address'
  And I am on the 'What is your registered office address?' page
  And I enter '188-196 Regent Street' in the 'Building and street' field
  And I enter 'London' in the 'Town or city' field
  And I enter 'W1B 5BT' in the 'Postcode' field
  And I enter 'United Kingdom' in the 'Country' field and click the selected autocomplete option
  And I click 'Save and return'

  Then I click the summary list 'Edit' link for 'Trading status'
  And I am on the 'What’s your trading status?' page
  And I choose 'public limited company (PLC)' radio button
  And I click 'Save and return'

  Then I click the summary list 'Edit' link for 'Company size'
  And I am on the 'What size is your organisation?' page
  And I choose 'Large' radio button
  And I click 'Save and return'
  Then I am on the 'Your company details' page

  # Not checking DUNS number here, as the value is random
  Then I see the 'Company details for your framework applications' summary list filled with:
    | field                     |  value                                                |
    | Registered company name   | Toys "ᴙ" Not Us                                       |
    | Registered company address| 188-196 Regent Street London W1B 5BT United Kingdom   |
    | Registration number       | 18092232                                              |
    | Trading status            | Public limited company (PLC)                          |
    | Company size              | Large                                                 |

  # Can pull the dunsNumber from the supplier and use it with this step
  And I see 'that supplier.dunsNumber' text on the page

@requires-credentials @notify
Scenario: Supplier user can add and remove contributors
  When I click 'Contributors'
  Then I am on the 'Invite or remove contributors' page
  And I see 'that user.name' text on the page
  And I see 'that user.emailAddress' text on the page

  When I click 'Invite a contributor'
  Then I am on the 'Invite a contributor' page

  Given I have a random email address
  When I enter that email_address in the 'email_address' field
  And I click 'Send invite'
  Then I see a success flash message containing 'Contributor invited'

  Given I receive a 'create-user-account' email for that email_address
  When I click the link in that email
  Then I am on the 'Add your name and create a password' page

  Given I enter 'New collaborator' in the 'Your name' field
  And I enter 'Password1234' in the 'Password' field
  When I click 'Create account'
  Then I am on that supplier.name page

  When I click 'Contributors'
  Then I see 'that user.emailAddress' text on the page
  And I see 'New collaborator' text on the page
  And I see 'that email_address' text on the page

  When I click 'Remove'
  Then I see a success flash message containing 'has been removed as a contributor.'

  Given I visit the /suppliers page
  When I click 'Contributors'
  Then I don't see 'that user.name' text on the page
  And I don't see 'that user.emailAddress' text on the page

  Given I click 'Log out'
  Then that user can not log in using their correct password
  # TODO: And the user is shown as 'not active' on the admin users page

Scenario: New users should have a link to join the use research mailing list
  Then I see the 'Join the user research mailing list' link

Scenario: Users on the mailing list should have the link to unsubscribe
  Given that user is on the user research mailing list
  When I visit the /suppliers page
  Then I see the 'Unsubscribe from the user research mailing list' link

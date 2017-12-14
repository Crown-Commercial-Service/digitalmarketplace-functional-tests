@supplier_account
Feature: Supplier can view and edit their supplier account information

Background:
  Given I have a supplier user
  And that supplier is logged in
  And I am on the /suppliers page

Scenario: Supplier user can edit supplier information
  When I click 'Supplier details'
  Then I am on the 'Supplier details' page

  When I click 'Edit'
  And I enter 'New name' in the 'Contact name' field
  And I enter 'new-email@example.com' in the 'Contact email' field
  And I enter '12345678' in the 'Contact phone number' field
  And I enter 'New Address 1' in the 'contact_address1' field
  And I enter 'New City' in the 'contact_city' field
  And I enter 'N3W C0DE' in the 'contact_postcode' field
  And I enter 'All fresh' in the 'Supplier summary' field
  And I click 'Save and return'
  Then I see the 'Supplier details' summary table filled with:
    | field                     | value                           |
    | Contact name              | New name                        |
    | Contact email             | new-email@example.com           |
    | Contact phone number      | 12345678                        |
    | Registered office address | New Address 1 New City N3W C0DE |
    | Supplier summary          | All fresh                       |


@notify @skip-staging
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
  Then I see a success banner message containing 'Contributor invited'

  Given I receive a 'create-user-account' email for that email_address
  When I click the link in that email
  Then I am on the 'Add your name and create a password' page

  Given I enter 'New collaborator' in the 'Your name' field
  And I enter 'Password1234' in the 'Password' field
  When I click 'Create account'
  Then I am on the /suppliers page

  When I click 'Contributors'
  Then I see 'that user.emailAddress' text on the page
  And I see 'New collaborator' text on the page
  And I see 'that email_address' text on the page

  When I click 'Remove'
  Then I see a success banner message containing 'has been removed as a contributor.'

  Given I am on the /suppliers page
  When I click 'Contributors'
  Then I don't see 'that user.name' text on the page
  And I don't see 'that user.emailAddress' text on the page

  Given I click 'Log out'
  Then That user can not log in using their correct password
  # TODO: And the user is shown as 'not active' on the admin users page

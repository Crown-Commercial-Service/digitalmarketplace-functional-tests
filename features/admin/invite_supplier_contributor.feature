@invite-supplier-contributor
Feature: Invite a contributor to a supplier account

Scenario Outline: Correct users can invite a contributors to a supplier account
  Given I am logged in as the production <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier 1 |
  And I click the 'Edit supplier accounts or view services' link
  And I enter 'DM Functional Test Supplier 1' in the 'supplier_name_prefix' field and click its associated 'Search' button
  And I click the summary table 'Users' link for 'DM Functional Test Supplier 1'
  When I enter 'simulate-delivered@notifications.service.gov.uk' in the 'Email address' field
  And I click the 'Send invitation' button
  Then I see a success banner message containing 'User invited'

  Examples:
    | role                    |
    | admin                   |

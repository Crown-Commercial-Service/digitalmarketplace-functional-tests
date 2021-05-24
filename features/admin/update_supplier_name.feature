@admin @update-supplier-name
Feature: Update supplier name

Scenario Outline: Correct users can edit a supplier name
  Given I am logged in as the existing <role> user
  And I have a supplier with:
    | name          | DM Functional Test Supplier - Update supplier name feature |
  And I click the '<link-name>' link
  And I enter 'DM Functional Test Supplier - Update supplier name feature' in the 'Find a supplier by name' field
  And I click the 'find_supplier_by_name_search' button
  And I click the 'DM Functional Test Supplier - Update supplier name feature' link
  And I am on the 'DM Functional Test Supplier - Update supplier name feature' page
  When I click the 'Edit supplier name' link
  Then I am on the 'Change supplier name' page
  When I enter 'DM Functional Test Supplier - Update supplier name feature - Changed Name' in the 'New name' field
  And I click the 'Save' button
  Then I am on the 'DM Functional Test Supplier - Update supplier name feature - Changed Name' page
  When I click the 'Edit supplier name' link
  Then I am on the 'Change supplier name' page
  And I enter 'DM Functional Test Supplier - Update supplier name feature' in the 'New name' field
  And I click the 'Save' button
  Then I am on the 'DM Functional Test Supplier - Update supplier name feature' page

  Examples:
    | role                      | link-name                               |
    | admin                     | Edit supplier accounts or view services |

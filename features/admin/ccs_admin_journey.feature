@not-production @functional-test @wip1
Feature: CCS admin user journey through Digital Marketplace

Background:
    Given I have test suppliers
    And The test suppliers have declarations

Scenario: As a CCS Sourcing user, I wish to search for supplier(s) by supplier name prefix
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I enter 'DM Functional Test Supplier' in the 'supplier_name_prefix' field
  And I click the search button for 'supplier_name_prefix'
  Then I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'

Scenario: As a CCS Sourcing user I should be able to edit a supplier declaration
    Given I am logged in as a 'CCS Sourcing' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
    When I click the 'G-Cloud 7 declaration' link for the supplier 'DM Functional Test Supplier'
    Then I am presented with the admin G-Cloud 7 declaration page
    When I click the 'Edit' link for 'G-Cloud 7 essentials'
    And I choose 'No' for 'PR1'
    And I click 'Save and return to summary'
    And I click the 'Edit' link for 'Grounds for discretionary exclusion'
    And I change 'input-SQ3-1k' to 'Everything'
    And I click 'Save and return to summary'
    Then I am presented with the updated admin G-Cloud 7 declaration page

Scenario: CCS Sourcing user can not load Admin specific pages

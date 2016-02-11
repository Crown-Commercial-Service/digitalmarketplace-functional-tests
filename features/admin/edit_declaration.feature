@not-production @functional-test
Feature: CCS Sourcing can edit supplier framework declarations

  The CCS Sourcing team should be able to edit supplier framework declarations.
  No other admin roles should be able to view or edit these declarations

Background:
    Given I have test suppliers
    And The test suppliers have declarations

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

#Scenario: As a normal admin user I should not be able to edit a supplier declaration
#    Given I am logged in as a 'Administrator' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
#    Then there is no 'G-Cloud 7 declaration' link for any supplier

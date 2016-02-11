@not-production @functional-test
Feature: CCS admin user journey through Digital Marketplace

Scenario: Setup for tests
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

Scenario: CCS Sourcing should not have access to Admin specific pages
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  Then There should not be a link for 'Digital Outcomes and Specialists communications'
  And There should not be a link for 'Download user list'

  When I attempt navigate to the page directly via the URL 'admin/communications/digital-outcomes-and-specialists'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt navigate to the page directly via the URL 'admin/users/download'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

Scenario: As a CCS Sourcing user I want to view G-Cloud 7 statistics
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I click 'G-Cloud 7 statistics'
  Then I am presented with the 'G-Cloud 7' statistics page

Scenario: As a CCS Sourcing user I want to view Digital Outcomes and Specialists statistics
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I click 'Digital Outcomes and Specialists statistics'
  Then I am presented with the 'Digital Outcomes and Specialists' statistics page

@not-production @functional-test
Feature: CCS admin user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have declarations

Scenario: As a CCS Category user I want to view Digital Outcomes and Specialists 2 statistics
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I click 'Digital Outcomes and Specialists 2 statistics'
  Then I am presented with the 'Digital Outcomes and Specialists 2' statistics page

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for a service by service ID
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter '1123456789012346' in the 'service_id' field
  And I click the search button for 'service_id'
  Then I am presented with the summary page for that service

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for supplier(s) by supplier name prefix
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter 'DM Functional Test Supplier' in the 'supplier_name_prefix' field
  And I click the search button for 'supplier_name_prefix'
  Then I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to navigate to the Supplier Users page via the supplier(s) by supplier name prefix page
  Given I am logged in as 'CCS Category' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Users' link for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Users' page for the supplier 'DM Functional Test Supplier'

Scenario: CCS Category should not have access to certain admin pages
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  Then There is no 'G-Cloud 7 agreements' link
  And There is no 'Digital Outcomes and Specialists agreements' link
  And There is no 'Digital Outcomes and Specialists communications' link
  And There is no 'Download user list' link

  When I attempt to load the 'G-Cloud 7 agreements' page directly via the URL 'admin/agreements/g-cloud-7'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'Digital Outcomes and Specialists agreements' page directly via the URL 'admin/agreements/digital-outcomes-and-specialists'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'Digital Outcomes and Specialists communications' page directly via the URL 'admin/communications/digital-outcomes-and-specialists'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'Download user list' page directly via the URL 'admin/users/download'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'users by email' page directly via the URL 'admin/users?email_address=testing.supplier.username%40dmtestemail.com'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

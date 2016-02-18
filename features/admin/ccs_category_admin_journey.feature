@not-production @functional-test
Feature: CCS admin user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have declarations

Scenario: As a CCS Category user I want to view G-Cloud 7 statistics
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I click 'G-Cloud 7 statistics'
  Then I am presented with the 'G-Cloud 7' statistics page

Scenario: As a CCS Category user I want to view Digital Outcomes and Specialists statistics
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I click 'Digital Outcomes and Specialists statistics'
  Then I am presented with the 'Digital Outcomes and Specialists' statistics page

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for a service by service ID
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter '1123456789012346' in the 'service_id' field
  And I click the search button for 'service_id'
  Then I am presented with the summary page for that service

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for services by supplier ID
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter '11111' in the 'supplier_id_for_services' field
  And I click the search button for 'supplier_id_for_services'
  Then I am presented with the 'Services' page for the supplier 'DM Functional Test Supplier'
  And I can see all listings ordered by lot name followed by listing name

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for services by supplier ID and view a specific service
  Given I am logged in as a 'CCS Category' and navigated to the 'Services' page by searching on supplier ID '11111'
  When I select 'the' second listing on the page
  Then I am presented with the service page for that specific listing

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for users by supplier ID
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter '11111' in the 'supplier_id_for_users' field
  And I click the search button for 'supplier_id_for_users'
  Then I am presented with the 'Users' page for the supplier 'DM Functional Test Supplier'
  And All users for the supplier ID 11111 are listed on the page

Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to search for supplier(s) by supplier name prefix
  Given I have logged in to Digital Marketplace as a 'CCS Category' user
  When I enter 'DM Functional Test Supplier' in the 'supplier_name_prefix' field
  And I click the search button for 'supplier_name_prefix'
  Then I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'
@wip1
Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to navigate to the Supplier Users page via the supplier(s) by supplier name prefix page
  Given I am logged in as a 'CCS Category' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Users' link for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Users' page for the supplier 'DM Functional Test Supplier'
@wip1
Scenario: As a CCS Category user who has logged in to Digital Marketplace, I wish to navigate to the Supplier Services page via the supplier(s) by supplier name prefix page
  Given I am logged in as a 'CCS Category' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Services' link for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Services' page for the supplier 'DM Functional Test Supplier'
  And I can see all listings ordered by lot name followed by listing name

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
#This should not be available but does not require an immediate fix now. Pivotal story #114000913 raised to address this issue. ****remove # when issue addressed****
  #When I attempt to load the 'users by email' page directly via the URL 'admin/users?email_address=testing.supplier.username%40dmtestemail.com'
  #Then I am presented with the 'You don’t have permission to perform this action' warning page

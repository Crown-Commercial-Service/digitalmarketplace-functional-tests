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
  Given I am logged in as 'CCS Sourcing' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Edit declaration' link in the 'G-Cloud 7' column for the supplier 'DM Functional Test Supplier'
  Then I am presented with the admin G-Cloud 7 declaration page
  When I click the 'Edit' link for 'G-Cloud 7 essentials'
  Then I am presented with the 'G-Cloud 7 essentials' page
  And I choose 'No' for 'PR1'
  And I click 'Save and return to summary'
  And I click the 'Edit' link for 'Grounds for discretionary exclusion'
  Then I am presented with the 'Grounds for discretionary exclusion' page
  And I change 'input-SQ3-1k' to 'Everything'
  And I click 'Save and return to summary'
  Then I am presented with the updated admin G-Cloud 7 declaration page

Scenario: As a CCS Sourcing user I wish to upload G-Cloud 7 countersigned agreements
  Given I am logged in as 'CCS Sourcing' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Countersigned agreement' link in the 'G-Cloud 7' column for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Upload a G-Cloud 7 countersigned agreement' page

  When I choose file 'test.pdf' for 'countersigned_agreement'
  And I click 'Upload file'
  Then I am presented with the message 'Countersigned agreement file was uploaded'

Scenario: As a CCS Sourcing user I wish to remove a countersigned agreement
  Given I am logged in as 'CCS Sourcing' and navigated to the 'Upload a G-Cloud 7 countersigned agreement' page for supplier 'DM Functional Test Supplier'
  When I click 'Remove'
  Then I am presented with the message 'Do you want to remove the countersigned agreement?'

  When I click 'Yes'
  Then I am presented with the 'Upload a G-Cloud 7 countersigned agreement' page
  And There is no agreement available on the page

Scenario: As a CCS Sourcing user I want to download the agreement
  Given I am logged in as 'CCS Sourcing' and navigated to the 'Upload a G-Cloud 7 countersigned agreement' page for supplier 'DM Functional Test Supplier'
  When I choose file 'test2.pdf' for 'countersigned_agreement'
  And I click 'Upload file'
  Then I am presented with the message 'Countersigned agreement file was uploaded'

  When I download the contersigned agreement
  Then The correct file of 'DM_Functional_Test_Supplier-11111-agreement-countersignature.pdf' with file content type of 'application/pdf' is made available

Scenario: As a CCS Sourcing user I want to view Digital Outcomes and Specialists 2 statistics
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I click 'Digital Outcomes and Specialists 2 statistics'
  Then I am presented with the 'Digital Outcomes and Specialists 2' statistics page

Scenario: Most recently uploaded agreements should be shown last: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11112'
  When I click 'G-Cloud 7 agreements'
  Then the last signed agreement should be for supplier 'DM Functional Test Supplier 2'

Scenario: Re-uploading an agreement brings it to the bottom of the list: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11112'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  When I click 'Digital Outcomes and Specialists agreements'
  Then the last signed agreement should be for supplier 'DM Functional Test Supplier'

Scenario: CCS Sourcing should not have access to Administrator specific pages
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  Then There is no 'Digital Outcomes and Specialists communications' link
  And There is no 'Download user list' link

  When I attempt to load the 'Digital Outcomes and Specialists communications' page directly via the URL 'admin/communications/digital-outcomes-and-specialists'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'Download user list' page directly via the URL 'admin/users/download'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'service by service ID' page directly via the URL 'admin/services/1123456789012346'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'services by supplier ID' page directly via the URL 'admin/suppliers/services?supplier_id=11111'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'users by supplier ID' page directly via the URL 'admin/suppliers/users?supplier_id=11111'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

  When I attempt to load the 'users by email' page directly via the URL 'admin/users?email_address=testing.supplier.username%40dmtestemail.com'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

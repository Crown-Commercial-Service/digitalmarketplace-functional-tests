@not-production @functional-test
Feature: CCS admin user journey through Digital Marketplace

  The CCS Sourcing team should be able to edit supplier framework declarations.
  No other admin roles should be able to view or edit these declarations
@wip2
Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have declarations
  And no 'digital-outcomes-and-specialists' framework agreements exist

Scenario: As a CCS Sourcing user, I wish to search for supplier(s) by supplier name prefix
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I enter 'DM Functional Test Supplier' in the 'supplier_name_prefix' field
  And I click the search button for 'supplier_name_prefix'
  Then I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'
@wip2
Scenario: As a CCS Sourcing user I should be able to edit a supplier declaration
  Given I am logged in as a 'CCS Sourcing' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'G-Cloud 7 declaration' link for the supplier 'DM Functional Test Supplier'
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
  Given I am logged in as a 'CCS Sourcing' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Upload G-Cloud 7 countersigned agreement' link for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Upload a G-Cloud 7 countersigned agreement' page

  When I choose file 'test.pdf' for 'countersigned_agreement'
  And I click 'Upload file'
  Then I am presented with the message 'Countersigned agreement file was uploaded'
@wip
Scenario: As a CCS Sourcing user I want to download the agreement
  Given I am logged in as a 'CCS Sourcing' and navigated to the 'Upload a G-Cloud 7 countersigned agreement' page for supplier 'DM Functional Test Supplier'
  When I click 'Download agreement'
  Then The correct file of 'countersigned-framework-agreement.pdf' with file content type of 'application/pdf' is made available

Scenario: As a CCS Sourcing user I wish to remove a countersigned agreement
  Given I am logged in as a 'CCS Sourcing' and navigated to the 'Upload a G-Cloud 7 countersigned agreement' page for supplier 'DM Functional Test Supplier'
  When I click 'Remove'
  Then I am presented with the message 'Do you want to remove the countersigned agreement?'

  When I click 'Yes'
  Then I am presented with the 'Upload a G-Cloud 7 countersigned agreement' page
  And There is no agreement available on the page

Scenario: As a CCS Sourcing user I want to view G-Cloud 7 statistics
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I click 'G-Cloud 7 statistics'
  Then I am presented with the 'G-Cloud 7' statistics page

Scenario: As a CCS Sourcing user I want to view Digital Outcomes and Specialists statistics
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When I click 'Digital Outcomes and Specialists statistics'
  Then I am presented with the 'Digital Outcomes and Specialists' statistics page

Scenario: When there are no framework agreements the list is empty: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  And I click 'Digital Outcomes and Specialists agreements'
  Then the framework agreement list is empty

Scenario: Most recently uploaded agreements should be shown first: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11112'
  When I click 'G-Cloud 7 agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier 2'
  When I click the first download agreement link
  Then I should get redirected to the correct 'g-cloud-7' S3 URL for supplier '11112'

Scenario: Re-uploading an agreement brings it to the top of the list: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11112'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  When I click 'Digital Outcomes and Specialists agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier'
  When I click the first download agreement link
  Then I should get redirected to the correct 'digital-outcomes-and-specialists' S3 URL for supplier '11111'

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

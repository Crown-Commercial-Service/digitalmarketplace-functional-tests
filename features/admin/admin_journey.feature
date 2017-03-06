@not-production @functional-test
Feature: Admin user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  Given The test suppliers have users
  And The test suppliers have live services
  And Test supplier users are active
  And Test supplier users are not locked
  And The user 'DM Functional Test Supplier User 3' is locked

Scenario: As an admin user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Administrator' login page
  When I login as a 'Administrator' user
  Then I am presented with the admin search page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Administrator' user

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to search for a service by service ID
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I enter '1123456789012346' in the 'service_id' field
  And I click the search button for 'service_id'
  Then I am presented with the summary page for that service

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to search for supplier(s) by supplier name prefix
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I enter 'DM Functional Test Supplier' in the 'supplier_name_prefix' field
  And I click the search button for 'supplier_name_prefix'
  Then I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to navigate to the Supplier Users page via the supplier(s) by supplier name prefix page
  Given I am logged in as 'Administrator' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Users' link for the supplier 'DM Functional Test Supplier'
  Then I am presented with the 'Users' page for the supplier 'DM Functional Test Supplier'

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to search for users by email address
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I enter the email address for the 'DM Functional Test Supplier User 1' user in the 'email_address' field
  And I click the search button for 'email_address'
  Then The page for the 'DM Functional Test Supplier User 1' user is presented

  When I enter the email address for the 'DM Functional Test Supplier User 3' user in the 'email_address' field
  And I click the search button for 'email_address'
  Then The page for the 'DM Functional Test Supplier User 3' user is presented

  When I click the 'DM Functional Test Supplier' link
  Then I am presented with the overview page for the supplier 'DM Functional Test Supplier'

Scenario: Admin user should be able to abort an edit and be returned to the service summary page
  Given I am logged in as 'Administrator' and am on the '1123456789012346' service summary page
  When I click the 'Edit' link for 'Description'
  And I click 'Return without saving'
  Then I am presented with the summary page with no changes made to the 'Description'

Scenario: As an admin user I wish to edit the features and benefits of a service
  Given I am logged in as 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Features and benefits' page
  And I change 'input-serviceFeatures-3' to 'Service feature changed'
  And I remove service benefit number 2
  And I add 'New service feature' as a 'serviceFeatures'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Features and benefits'

Scenario: As an admin user I wish to edit the pricing of a service
  Given I am logged in as 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Pricing' page
  And I change 'input-minimum-price' to '100'
  And I change 'input-maximum-price' to '1234'
  And I set 'input-price-unit' as 'Person'
  And I set 'input-pricing-interval' as 'Week'
  And I choose 'No' for 'vatIncluded'
  And I choose 'No' for 'educationPricing'
  And I choose 'Yes' for 'terminationCost'
  And I choose 'Yes' for 'trialOption'
  And I choose 'No' for 'freeOption'
  And I choose 'Other' for 'minimumContractPeriod'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Pricing'

Scenario: As an admin user I wish to change a document for a service
  Given I am logged in as 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Documents' page
  And I change 'pricingDocumentURL' file to '12345-test-new-pricing-document.pdf'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Documents'

Scenario: Admin user is able to view service details page for a service
  Given I am logged in as 'Administrator' and am on the '1123456789012346' service summary page
  When I click 'View service'
  Then I am presented with the service details page for that service

Scenario: As an admin user I want to view Service status changes
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I click 'Service status changes'
  Then I am presented with the Service status changes page for changes made 'today'

  When I navigate to the Service status changes page for changes made yesterday
  Then I am presented with the Service status changes page for changes made 'yesterday'

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to deactivate a supplier user
  Given I am logged in as 'Administrator' and navigated to the 'Users' page for supplier 'DM Functional Test Supplier'
  When I click the 'Deactivate' button for the supplier user 'DM Functional Test Supplier User 2'
  Then The supplier user 'DM Functional Test Supplier User 2' is 'not active'
  And The supplier user 'DM Functional Test Supplier User 2' 'can not' login to Digital Marketplace
  And The supplier user 'DM Functional Test Supplier User 2' 'is not' listed as a contributor on the dashboard of another user of the same supplier

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to activate a deactivated supplier user
  Given I am logged in as 'Administrator' and navigated to the 'Users' page for supplier 'DM Functional Test Supplier'
  When I click the 'Activate' button for the supplier user 'DM Functional Test Supplier User 2'
  Then The supplier user 'DM Functional Test Supplier User 2' is 'active'
  And The supplier user 'DM Functional Test Supplier User 2' 'can' login to Digital Marketplace
  And The supplier user 'DM Functional Test Supplier User 2' 'is' listed as a contributor on the dashboard of another user of the same supplier

Scenario: As an admin user who has logged in to Digital Marketplace, I wish unlock a locked supplier
  Given I am logged in as 'Administrator' and navigated to the 'Users' page for supplier 'DM Functional Test Supplier'
  When I click the 'Unlock' button for the supplier user 'DM Functional Test Supplier User 3'
  Then The supplier user 'DM Functional Test Supplier User 3' is 'not locked'
  And The supplier user 'DM Functional Test Supplier User 3' 'can' login to Digital Marketplace

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to send an invitation email to a new user
  Given I am logged in as 'Administrator' and navigated to the 'Users' page for supplier 'DM Functional Test Supplier'
  When I enter 'testing.supplier.username4@dmtestemail.com' in the 'email_address' field
  And I click 'Send invitation'
  Then I am presented with the message 'User invited'

Scenario: As an admin user I want to view G-Cloud 9 statistics
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I click 'G-Cloud 9 statistics'
  Then I am presented with the 'G-Cloud 9' statistics page

Scenario: As an admin user I want to view Service updates
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I click 'Service updates'
  Then I am presented with the Service updates page

Scenario: As a normal admin user I should not be able to edit a supplier declaration. Link should not exist on the services page.(This is only available to a CCS sourcing admin user)
  Given I am logged in as 'Administrator' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  Then there is no 'G-Cloud 7 declaration' link for any supplier
  Then there is no 'Digital Outcomes and Specialists declaration' link for any supplier

  When I attempt to load the 'Digital Outcomes and Specialists declaration' page directly via the URL 'admin/suppliers/11111/edit/declarations/digital-outcomes-and-specialists'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

Scenario: As a normal admin user I should not be able to upload a contersigned agreement for any supplier. Link should not exist on the services page.(This is only available to a CCS sourcing admin user)
  Given I am logged in as 'Administrator' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  Then there is no 'Upload G-Cloud 7 countersigned agreement' link for any supplier
  Then there is no 'Upload Digital Outcomes and Specialists countersigned agreement' link for any supplier

  When I attempt to load the 'Upload a G-Cloud 7 countersigned agreement' page directly via the URL 'admin/suppliers/11111/countersigned-agreements/g-cloud-7'
  Then I am presented with the 'You don’t have permission to perform this action' warning page

Scenario: As an admin user I want to change the supplier name of a current supplier
  Given I am logged in as 'Administrator' and navigated to the 'Suppliers' page by searching on suppliers by name prefix 'DM Functional Test Supplier'
  When I click the 'Change name' link for the supplier 'DM Functional Test Supplier 2'
  Then I am presented with the 'Change supplier name' page for the supplier 'DM Functional Test Supplier 2'

  When I change 'input-new_supplier_name' to 'DM Functional Test Supplier 2 name changed'
  And I click 'Save'
  Then I am presented with the 'Suppliers' page with the changed supplier name 'DM Functional Test Supplier 2 name changed' listed on the page

Scenario: Re-uploading an agreement brings it to the bottom of the list: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11112'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  When I click 'G-Cloud 7 agreements'
  Then the last signed agreement should be for supplier 'DM Functional Test Supplier'

Scenario: As an admin user I want to upload Digital Outcomes and Specialists 2 communications
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I click 'Digital Outcomes and Specialists 2 communications'
  Then I am presented with the 'Upload Digital Outcomes and Specialists 2 communications' page

  When I choose file 'test.pdf' for 'communication'
  And I click 'Upload files'
  Then I am presented with the message 'New communication was uploaded.'

Scenario: As an admin user I want to download the user list for a specific framework
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I click 'Download user list'
  Then I am presented with the 'Download user list' page

  When I click 'G-Cloud 7'
  Then The correct file of 'users-g-cloud-7.csv' with file content type of 'text/csv' is made available

  When I click 'Digital Outcomes and Specialists 2'
  Then The correct file of 'users-digital-outcomes-and-specialists-2.csv' with file content type of 'text/csv' is made available

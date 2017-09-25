@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have users
  And The test suppliers have live services
  And Test supplier users are active

Scenario: As a logged in supplier user, I can see my active contributors on the contributors page
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'Contributors'
  Then I can see active users associated with 'DM Functional Test Supplier' on the page

Scenario: As a logged in supplier user, I can navigate to the contributors page from my dashboard and I can remove one
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'Contributors'
  Then I am presented with the supplier 'DM Functional Test Supplier' 'Invite or remove contributors' page
  When I remove the supplier user 'DM Functional Test Supplier User 2'
  Then I see a confirmation message after having removed supplier user 'DM Functional Test Supplier User 2'
  And I should not see the supplier user 'DM Functional Test Supplier User 2' on the supplier dashboard page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace
  And The supplier user 'DM Functional Test Supplier User 2' 'can not' login to Digital Marketplace
  Then The supplier user 'DM Functional Test Supplier User 2' is 'not active' on the admin Users page

Scenario: As a logged in supplier user, I can edit my supplier information
  Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'Supplier details'
  Then I am presented with the supplier 'DM Functional Test Supplier' 'Supplier details' page
  And I click 'Edit'
  And I change 'input-description' to 'Supplier changed the service description'
  And I change 'input-contact_contactName' to 'Supplier changed the contact name'
  And I change 'input-contact_email' to 'Supplier.changed.the@email.com'
  And I change 'input-contact_phoneNumber' to 'Supplier changed the phone number'
  And I change 'contact_address1-input' to 'Supplier changed address1'
  And I change 'contact_city-input' to 'Supplier changed the city'
  And I change 'contact_postcode-input' to 'PCC'
  And I click 'Save and return'
  Then I am presented with the supplier details page with the changes that were made to the 'Supplier details'

@wip
Scenario: As a logged in supplier user, I can edit the description of a service
  Given I am logged in as 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Description' page
  And I change 'input-serviceName' to 'Supplier changed the service name'
  And I change 'input-serviceSummary' to 'Supplier changed the service summary'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Description'

@wip
Scenario: As a logged in supplier user, I can edit the features and benefits of a service
  Given I am logged in as 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Features and benefits' page
  And I change 'input-serviceFeatures-3' to 'Supplier changed this service feature'
  And I remove service benefit number 2
  And I add 'This is a new service feature' as a 'serviceFeatures'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Features and benefits'

@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have test suppliers
  And The test suppliers have users
  And The test suppliers have live services
  And Test supplier users are active

Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: As a logged in supplier user, my supplier details are available on the dashboard
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  Then I can see my supplier details on the dashboard

Scenario: As a logged in supplier user, I can navigate to the service listings page from my dashboard and can see all my listings
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'View'
  Then I am presented with the supplier 'DM Functional Test Supplier' 'Current services' page
  And I can see all listings ordered by lot name followed by listing name

Scenario: As a logged in supplier user, I can view the listings page of a specific service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select 'the' second listing on the page
  And I click 'View service'
  Then I am presented with the service page for that specific listing

Scenario: As a logged in supplier user, I can see my active contributors on the dashboard
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  Then I can see active users associated with 'DM Functional Test Supplier' on the dashboard

Scenario: As a logged in supplier user, I can navigate to the contributors page from my dashboard and I can remove one
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'Invite or remove'
  Then I am presented with the supplier 'DM Functional Test Supplier' 'Invite or remove contributors' page
  When I remove the supplier user 'DM Functional Test Supplier User 2'
  Then I see a confirmation message after having removed supplier user 'DM Functional Test Supplier User 2'
  And I should not see the supplier user 'DM Functional Test Supplier User 2' on the supplier dashboard page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Supplier' user
  And The supplier user 'DM Functional Test Supplier User 2' 'can not' login to Digital Marketplace
  Then The supplier user 'DM Functional Test Supplier User 2' is 'not active' on the admin Users page

Scenario: As a logged in supplier user, I can navigate to the service summary page for a specific service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select 'the' second listing on the page
  Then I am presented with the summary page for that service

Scenario: As a logged in supplier user, I can edit my supplier information
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I navigate to the 'Edit' 'Supplier information' page
  And I change 'input-description' to 'Supplier changed the service description'
  And I change 'input-clients-3' to 'Supplier changed the third client'
  And I remove client number 2
  And I add 'This is a new client' as a 'clients'
  And I change 'input-contact_contactName' to 'Supplier changed the contact name'
  And I change 'input-contact_website' to 'Supplier changed the website'
  And I change 'input-contact_email' to 'Supplier.changed.the@email.com'
  And I change 'input-contact_phoneNumber' to 'Supplier changed the phone number'
  And I change 'contact_address1-input' to 'Supplier changed address1'
  And I change 'contact_city-input' to 'Supplier changed the city'
  And I change 'contact_country-input' to 'Supplier changed the country'
  And I change 'contact_postcode-input' to 'PCC'
  And I click 'Save and return'
  Then I am presented with the dashboard page with the changes that were made to the 'Supplier information'

@wip
Scenario: As a logged in supplier user, I can edit the description of a service
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Description' page
  And I change 'input-serviceName' to 'Supplier changed the service name'
  And I change 'input-serviceSummary' to 'Supplier changed the service summary'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Description'

@wip
Scenario: As a logged in supplier user, I can edit the features and benefits of a service
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'Edit' 'Features and benefits' page
  And I change 'input-serviceFeatures-3' to 'Supplier changed this service feature'
  And I remove service benefit number 2
  And I add 'This is a new service feature' as a 'serviceFeatures'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Features and benefits'

Scenario: Supplier user changes service status to 'Removed'. The change is reflected in the admin and/or buyer app
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I click 'Remove service'
  Then I am presented with the message 'Are you sure you want to remove your service?'
  When I click 'Remove service'
  And I am presented with a service removal message for the '1123456789012346' service
  And A message stating the supplier has stopped offering this service on todays date is presented on the 'Supplier' service summary page
  And The service 'can not' be searched
  And The service details page 'can' be viewed
  And A message stating the supplier has stopped offering this service on todays date is presented on the 'Buyer' service summary page
  And The status of the service is presented as 'Private' on the admin users service summary page

Scenario: Supplier user has 5 failed login attempts and is locked. Login is not allowed unless admin unlocks the user
  Given The supplier user 'DM Functional Test Supplier User 3' has 5 failed login attempts
  Then The supplier user 'DM Functional Test Supplier User 3' is 'locked' on the admin Users page
  And The supplier user 'DM Functional Test Supplier User 3' 'can not' login to Digital Marketplace

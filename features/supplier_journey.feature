@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have a test supplier
  And The test supplier has multiple users
  And The test supplier has multiple services
  And Test supplier users are active

Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: As a logged in supplier user, my supplier detail are available on the dashboard
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  Then I can see my supplier details on the dashboard

Scenario: As a logged in supplier user, I can navigate to the service listings page from my dashboard and can see all my listings
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'View'
  Then I am presented with the 'DM Functional Test Supplier' supplier current services page
  And I can see all listings ordered by lot name followed by listing name

Scenario: As a logged in supplier user, I can select a listing and be presented with the listings page
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select the second listing on the page
  Then I am presented with the service page for that specific listing

Scenario: As a logged in supplier user, I can navigate to the service summary page for a specific service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I click Edit for the service '1123456789012346'
  Then I am presented with the summary page for that service

Scenario: As a logged in supplier user, I can edit my supplier information
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I navigate to the 'edit' 'Supplier information' page
  And I change 'description' to 'Supplier changed the service description'
  And I change 'clients-3' to 'Supplier changed the third client'
  And I remove client number 2
  And I add 'This is a new client' as a 'clients'
  And I change 'contact_contactName' to 'Supplier changed the contact name'
  And I change 'contact_website' to 'Supplier changed the website'
  And I change 'contact_email' to 'Supplier.changed.the@email.com'
  And I change 'contact_phoneNumber' to 'Supplier changed the phone number'
  And I change 'contact_address1' to 'Supplier changed address1'
  And I change 'contact_city' to 'Supplier changed the city'
  And I change 'contact_country' to 'Supplier changed the country'
  And I change 'contact_postcode' to 'PCC'
  And I click 'Save and return'
  Then I am presented with the dashboard page with the changes that were made to the 'Supplier information'

Scenario: As a logged in supplier user, I can edit the description of a service
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Description' page
  And I change 'serviceName' to 'Supplier changed the service name'
  And I change 'serviceSummary' to 'Supplier changed the service summary'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Description'

Scenario: As a logged in supplier user, I can edit the features and benefits of a service
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Features and benefits' page
  And I change 'serviceFeatures-3' to 'Supplier changed this service feature'
  And I remove service benefit number 2
  And I add 'This is a new service feature' as a 'serviceFeatures'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Features and benefits'

Scenario: Supplier user changes service status to 'Private'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I select 'Private' as the service status
  And I click the 'Save and return' button
  Then The service status is set as 'Private'
  And I am presented with the message 'Supplier changed the service name is now private'
  And The status of the service is presented as 'Private' on the admin users service summary page
  And The service 'can not' be searched
  And The service details page 'can not' be viewed

Scenario: Admin changes service status to 'Public'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'Supplier' and am on the '1123456789012346' service summary page
  When I select 'Public' as the service status
  And I click the 'Save and return' button
  Then The service status is set as 'Public'
  And I am presented with the message 'Supplier changed the service name is now public'
  And The status of the service is presented as 'Public' on the admin users service summary page
  And The service 'can' be searched
  And The service details page 'can' be viewed

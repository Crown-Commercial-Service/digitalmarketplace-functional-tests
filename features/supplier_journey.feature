@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have a test supplier
  And The test supplier has a user
  And The test supplier has multiple services

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
  Then I am presented with the 'DM Functional Test Supplier' supplier service listings page
  And I can see all my listings ordered by lot name followed by listing name

Scenario: As a logged in supplier user, I can select a listing and be presented with the listings page
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select the second listing on the page
  Then I am presented with the listing page for that specific listing

Scenario: As a logged in supplier user, I can navigate to the service summary page for a specific service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I click Edit for the service '1123456789012353'
  Then I am presented with the summary page for that service
@wip1
Scenario: As a logged in supplier user, I can edit the description of a service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I click Edit for the service '1123456789012353'
  And I navigate to the 'edit' 'Description' page
  And I change 'serviceName' to 'Service name has been changed'
  And I change 'serviceSummary' to 'Service summary has been changed'
  And I click 'Save and return to service'
  Then I am presented with the summary page with the changes that were made to the 'Description'

@wip
Scenario: As a logged in supplier user, I can edit the features and benefits of a service
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page



@wip
Scenario: Supplier user changes service status to 'Private'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select 'Private' as the service status
  And I click the 'Update status' button
  Then The service status is set as 'Private'
  And I am presented with the message 'Service status has been updated to: Private'
  And The status of the service is presented as 'Private' on the supplier users service listings page
  And The service 'can not' be searched
  And The service details page 'can not' be viewed
@wip
Scenario: Admin changes service status to 'Public'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select 'Public' as the service status
  And I click the 'Update status' button
  Then The service status is set as 'Public'
  And I am presented with the message 'Service status has been updated to: Public'
  And The status of the service is presented as 'Public' on the supplier users service listings page
  And The service 'can' be searched
  And The service details page 'can' be viewed

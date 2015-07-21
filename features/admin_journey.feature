@not-production @functional-test
Feature: Admin user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have a test supplier
  And The test supplier has a service

Scenario: As an admin user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Administrator' login page
  When I login as a 'Administrator' user
  Then I am presented with the 'Find a service' page
  When I click 'Log out'
  Then I am logged out of Digital Marketplace as a 'Administrator' user

Scenario: As an admin user who has logged in to Digital Marketplace, I wish to search for a service
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When I enter '1123456789012346' in the 'Service ID' field
  And I click 'Find service'
  Then I am presented with the summary page for that service

Scenario: Admin user should be able to abort an edit and be returned to the service summary page
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I click the 'Edit' link for 'Description'
  And I click 'Return without saving'
  Then I am presented with the summary page with no changes made to the 'Description'

Scenario: As an admin user I wish to edit the description of a service
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Description' page
  And I change 'serviceName' to 'Service name changed'
  And I change 'serviceSummary' to 'Service summary changed'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Description'

Scenario: As an admin user I wish to edit the features and benefits of a service
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Features and benefits' page
  And I change 'serviceFeatures-3' to 'Service feature changed'
  And I remove service benefit number 2
  And I add 'New service feature' as a 'serviceFeatures'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Feature and benefits'

Scenario: As an admin user I wish to edit the pricing of a service
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Pricing' page
  And I change 'priceMin' to '100'
  And I change 'priceMax' to '1234'
  And I set 'priceUnit' as 'Person'
  And I set 'priceInterval' as 'Week'
  And I choose 'No' for 'vatIncluded'
  And I choose 'No' for 'educationPricing'
  And I choose 'Yes' for 'terminationCost'
  And I choose 'Yes' for 'trialOption'
  And I choose 'No' for 'freeOption'
  And I choose 'Other' for 'minimumContractPeriod'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Pricing'

Scenario: As an admin user I wish to change a document of a service
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I navigate to the 'edit' 'Documents' page
  And I change 'pricingDocumentURL' file to '12345-test-new-pricing-document.pdf'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Documents'

Scenario: Admin user is able to view service details page for a service
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I click 'View service'
  Then I am presented with the service details page for that service

Scenario: Admin changes service status to 'Removed'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I select 'Removed' as the service status
  And I click the 'Update status' button
  Then The service status is set as 'Removed'
  And I am presented with the message 'Service status has been updated to: Removed'
  And The status of the service is presented as 'Removed' on the supplier users service listings page
  And The service 'can not' be searched
  And The service details page 'can not' be viewed

Scenario: Admin changes service status to 'Private'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I select 'Private' as the service status
  And I click the 'Update status' button
  Then The service status is set as 'Private'
  And I am presented with the message 'Service status has been updated to: Private'
  And The status of the service is presented as 'Private' on the supplier users service listings page
  And The service 'can not' be searched
  And The service details page 'can not' be viewed

Scenario: Admin changes service status to 'Public'. The change is reflected in the supplier and/or buyer app
  Given I am logged in as a 'Administrator' and am on the '1123456789012346' service summary page
  When I select 'Public' as the service status
  And I click the 'Update status' button
  Then The service status is set as 'Public'
  And I am presented with the message 'Service status has been updated to: Public'
  And The status of the service is presented as 'Public' on the supplier users service listings page
  And The service 'can' be searched
  And The service details page 'can' be viewed

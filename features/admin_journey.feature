Feature: Admin user journey through Digital Marketplace

Scenario: As an admin user I wish to log into Digital Marketplace, search for a service and be able to edit details for that service
  Given I am on the 'Administrator' login page
  When I login as a 'Administrator' user
  Then I am presented with the 'Find a service' page
  When I enter '5126395806089216' in the 'Service ID' field
  And I click 'Find service'
  Then I am presented with the summary page for that service

Scenario: Admin user should be able to abort an edit and be returned to the service summary page
  Given I am on the '/edit/description' page
  When I click 'Return without saving'
  Then I am presented with the summary page with no changes made to the 'Description'

Scenario: As an admin user I wish to edit the description of a service
  Given I click the 'Edit' link for 'Description'
  Then I am presented with the 'edit' 'Description' page for that service
  When I change 'serviceName-text-box' to 'Service name changed'
  And I change 'serviceSummary-text-box' to 'Service summary changed'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Description'

Scenario: As an admin user I wish to edit the features and benefits of a service
  Given I click the 'Edit' link for 'Features and benefits'
  Then I am presented with the 'edit' 'Features and benefits' page for that service
  When I change 'serviceFeatures-1' to 'Service feature changed'
  And I remove 'serviceFeatures-2'
  And I add 'New service benefit' as a 'serviceBenefits'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Feature and benefits'

Scenario: As an admin user I wish to edit the pricing of a service
  Given I click the 'Edit' link for 'Pricing'
  Then I am presented with the 'edit' 'Pricing' page for that service
  When I change 'priceMin' to '100'
  And I change 'priceMax' to '1234'
  And I set 'priceUnit' as 'Person'
  And I set 'priceInterval' as 'Week'
  And I choose 'No' for 'vatIncluded'
  And I choose 'No' for 'educationPricing'
  And I choose 'Yes' for 'trialOption'
  And I choose 'No' for 'freeOption'
  And I choose 'Other' for 'minimumContractPeriod'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Pricing'

Scenario: As an admin user I wish to change a document of a service
  Given I click the 'Edit' link for 'Documents'
  Then I am presented with the 'edit' 'Documents' page for that service
  When I change 'pricingDocumentURL' file to '12345-test-new-pricing-document.pdf'
  And I click 'Save and return to summary'
  Then I am presented with the summary page with the changes that were made to the 'Documents'

Scenario: Admin user is able to view service details page for a service
  When I click 'View service'
  Then I am presented with the service details page for that service

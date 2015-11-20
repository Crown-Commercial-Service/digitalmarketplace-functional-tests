@not-production @functional-test @ssp
Feature: Submitting a new service for SCS
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select lot
    Given I am at '/suppliers'
    When I click 'Continue your G-Cloud 7 application'
    And I click 'Add, edit and delete services'
    And I click 'Add a service'
    When I choose 'Specialist Cloud Services (SCS)' for 'lot'
    And I click 'Save and continue'
    Then I should be on the 'Service name' page

  Scenario: Provide a service name
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Service name' page
    And I fill in 'serviceName' with 'My SCS service name'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Service description' page
    And I fill in 'serviceSummary' with:
      """
      Service summary for my SCS service that does stuff with stuff.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Service type' page
    And I check 'Testing' for 'serviceTypes'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Features and benefits' page
    And I fill in 'input-serviceFeatures-1' with 'Service feature number one'
    And I fill in 'input-serviceBenefits-1' with 'Service benefits number one'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Pricing' page
    And I fill in 'input-priceString-MinPrice' with '100'
    And I fill in 'input-priceString-MaxPrice' with '1000'
    And I select 'Unit' from 'input-priceString-Unit'
    And I select 'Second' from 'input-priceString-Interval'
    And I choose 'Yes' for 'vatIncluded'
    And I choose 'No' for 'educationPricing'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Terms and conditions' page
    And I choose 'No' for 'terminationCost'
    And I choose 'Month' for 'minimumContractPeriod'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the g7 services page
    When I click my service
    Then I should be on the 'My SCS service name' page
    And The string 'Answer required' should be on the page
    And The 'Mark as complete' button should not be on the page

  Scenario: Support
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Support' page
    And I check 'Service desk' for 'supportTypes'
    And I choose 'Yes' for 'supportForThirdParties'
    And I fill in 'supportAvailability' with '24/7 365 days'
    And I fill in 'supportResponseTime' with 'Within 1 hour'
    And I choose 'Yes' for 'incidentEscalation'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Certifications' page
    And I fill in 'input-vendorCertifications-1' with 'Vendor certification one provided.'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page

  Scenario: Service definition document
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Service definition' page
    And I choose file 'test.pdf' for 'serviceDefinitionDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions document' page

  Scenario: Terms and conditions document
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Terms and conditions document' page
    And I choose file 'test.pdf' for 'termsAndConditionsDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Pricing document' page

  Scenario: Pricing document
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'Pricing document' page
    And I choose file 'test.pdf' for 'pricingDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'SFIA rate card' page

  Scenario: SFIA rate card document
    Given I am on ssp page 'scs'
    When I navigate to the 'Edit' 'SFIA rate card document' page
    And I choose file 'test.pdf' for 'sfiaRateDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'My SCS service name' page

  # TODO: Remove WIP once completing services is implemented
  @wip
  Scenario: Mark as complete
    Given I am on the summary page
    Then The string 'Answer required' should not be on the page
    And The 'Mark as complete' button should be on the page

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “My SCS service name”'
    Then I should be on the g7 services page
    And My service should not be in the list

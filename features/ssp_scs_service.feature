@not-production @functional-test
Feature: Submitting a new service for SCS
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select lot
    Given I am at '/suppliers'
    When I click 'Apply to become a G-Cloud 7 supplier and add services'
    And I click 'Add services'
    And I click 'Add a service'
    When I choose 'Specialist Cloud Services (SCS)'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on ssp page 'service_description'
    When I fill in 'serviceName' with 'My SCS service name'
    And I fill in 'serviceSummary' with:
      """
      Service summary for my SCS service that does stuff with stuff.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on ssp page 'service_type'
    When I check 'Testing'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on ssp page 'features_and_benefits'
    When I fill in 'serviceFeatures-1' with 'Service feature number one'
    And I fill in 'serviceBenefits-1' with 'Service benefits number one'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on ssp page 'pricing'
    When I fill in 'priceStringMinPrice' with '100'
    And I fill in 'priceStringMaxPrice' with '1000'
    And I select 'Unit' from 'priceStringUnit'
    And I select 'Second' from 'priceStringInterval'
    And I choose 'vatIncluded-yes'
    And I choose 'educationPricing-no'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'terms_and_conditions'
    When I choose 'terminationCost-no'
    And I choose 'minimumContractPeriod-3'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the g7 supplier dashboard page
    When I click my service
    Then I should be on the 'My SCS service name' page
    And The string 'Answer required' should be on the page
    And The string 'The service is complete' should not be on the page

  Scenario: Support
    Given I am on ssp page 'support'
    When I check 'supportTypes-1'
    And I choose 'supportForThirdParties-yes'
    And I fill in 'supportAvailability' with '24/7 365 days'
    And I fill in 'supportResponseTime' with 'Within 1 hour'
    And I choose 'incidentEscalation-yes'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on ssp page 'certifications'
    When I fill in 'vendorCertifications-1' with 'Vendor certification one provided.'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page

  Scenario: Service definition document
    Given I am on ssp page 'service_definition'
    When I choose file 'test.pdf' for 'serviceDefinitionDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions document' page

  Scenario: Terms and conditions document
    Given I am on ssp page 'terms_and_conditions_document'
    When I choose file 'test.pdf' for 'termsAndConditionsDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Pricing document' page

  Scenario: Pricing document
    Given I am on ssp page 'pricing_document'
    When I choose file 'test.pdf' for 'pricingDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'SFIA rate card' page

  Scenario: SFIA rate card document
    Given I am on ssp page 'sfia_rate_card'
    When I choose file 'test.pdf' for 'sfiaRateDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'My SCS service name' page

  # TODO: Remove WIP once completing services is implemented
  @wip
  Scenario: The service is complete
    Given I am on the summary page
    Then The string 'Answer required' should not be on the page
    And The string 'The service is complete' should be on the page

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “My SCS service name”'
    Then I should be on the g7 services page
    And My service should not be in the list

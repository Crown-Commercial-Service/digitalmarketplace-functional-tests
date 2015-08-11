@not-production @functional-test @ssp
Feature: Submitting a new service for SaaS
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
    When I choose 'Software as a Service (SaaS)' for 'lot'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on ssp page 'service_description'
    When I fill in 'serviceName' with 'My SaaS service'
    And I fill in 'serviceSummary' with:
      """
      It's very SaaSy.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on ssp page 'service_type'
    When I check 'Creative and design'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on ssp page 'features_and_benefits'
    When I fill in 'serviceFeatures-1' with 'Great superness'
    And I fill in 'serviceBenefits-1' with 'Super greatness'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on ssp page 'pricing'
    When I fill in 'priceStringMinPrice' with '99'
    And I fill in 'priceStringMaxPrice' with '100'
    And I select 'Unit' from 'priceStringUnit'
    And I select 'Second' from 'priceStringInterval'
    And I choose 'No' for 'vatIncluded'
    And I choose 'Yes' for 'educationPricing'
    And I choose 'Yes' for 'trialOption'
    And I choose 'No' for 'freeOption'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'terms_and_conditions'
    And I choose 'Month' for 'minimumContractPeriod'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  Scenario: Support
    Given I am on ssp page 'support'
    When I check 'Service desk'
    And I choose 'Yes' for 'supportForThirdParties'
    And I fill in 'supportAvailability' with '24/7'
    And I fill in 'supportResponseTime' with '1 hour'
    And I choose 'No' for 'incidentEscalation'
    And I click 'Save and continue'
    Then I should be on the 'Open standards' page

  Scenario: Open standards
    Given I am on ssp page 'open_standards'
    When I choose 'Yes' for 'openStandardsSupported'
    And I click 'Save and continue'
    Then I should be on the 'Onboarding and offboarding' page

  Scenario: Onboarding and offboarding
    Given I am on ssp page 'onboarding_and_offboarding'
    When I choose 'No' for 'serviceOnboarding'
    And I choose 'Yes' for 'serviceOffboarding'
    And I click 'Save and continue'
    Then I should be on the 'Analytics' page

  Scenario: Analytics
    Given I am on ssp page 'analytics'
    When I choose 'No' for 'analyticsAvailable'
    And I click 'Save and continue'
    Then I should be on the 'Cloud features' page

  Scenario: Cloud features
    Given I am on ssp page 'cloud_features'
    When I choose 'Yes' for 'elasticCloud'
    And I choose 'No' for 'guaranteedResources'
    And I choose 'No' for 'persistentStorage'
    And I click 'Save and continue'
    Then I should be on the 'Provisioning' page

  Scenario: Provisioning
    Given I am on ssp page 'provisioning'
    When I choose 'Yes' for 'selfServiceProvisioning'
    And I fill in 'provisioningTime' with '5 hours'
    And I fill in 'deprovisioningTime' with '6 hours'
    And I click 'Save and continue'
    Then I should be on the 'Open source' page

  Scenario: Open source
    Given I am on ssp page 'open_source'
    When I choose 'Yes' for 'openSource'
    And I click 'Save and continue'
    Then I should be on the 'Code Libraries' page

  Scenario: Code libraries
    Given I am on ssp page 'code_libraries'
    When I fill in 'codeLibraryLanguages-1' with 'XSLT'
    And I click 'Save and continue'
    Then I should be on the 'API Access' page

  Scenario: API access
    Given I am on ssp page 'api_access'
    When I choose 'Yes' for 'apiAccess'
    And I fill in 'apiType' with 'XML'
    And I click 'Save and continue'
    Then I should be on the 'Networks and connectivity' page

  Scenario: Networks and connectivity
    Given I am on ssp page 'networks_and_connectivity'
    When I check 'Internet'
    And I click 'Save and continue'
    Then I should be on the 'Access' page

  Scenario: Access
    Given I am on ssp page 'access'
    When I check 'Opera'
    And I choose 'Yes' for 'offlineWorking'
    And I check 'PC'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on ssp page 'certifications'
    When I fill in 'vendorCertifications-1' with 'Stuff magic'
    And I click 'Save and continue'
    Then I should be on the 'Identity standards' page

  Scenario: Identity standards
    Given I am on ssp page 'identity_standards'
    When I fill in 'identityStandards-1' with 'OAuth'
    And I click 'Save and continue'
    Then I should be on the 'Data storage' page

  Scenario: Data storage
    Given I am on ssp page 'data_storage'
    When I choose 'No' for 'datacentresEUCode'
    And I choose 'Yes' for 'datacentresSpecifyLocation'
    And I choose 'Uptime Institute Tier 1' for 'datacentreTier'
    And I choose 'Yes' for 'dataBackupRecovery'
    And I choose 'Yes' for 'dataExtractionRemoval'
    And I click 'Save and continue'
    Then I should be on the 'Data-in-transit protection' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the g7 services page
    When I click my service
    Then I should be on the 'My SaaS service' page
    And The string 'Answer required' should be on the page
    And The string 'The service is complete' should not be on the page

  Scenario: Data-in-transit protection
    Given I am on ssp page 'data_in_transit_protection'
    When I check 'Encrypted PSN service'
    And I choose 'Independent validation of assertion' for 'dataProtectionBetweenUserAndService--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Asset protection and resilience' page

  Scenario: Asset protection and resilience
    Given I am on ssp page 'asset_protection_and_resilience'
    When I check 'datacentreLocations-1'
    And I choose 'Service provider assertion' for 'datacentreLocations--assurance'
    And I check 'dataManagementLocations-1'
    And I choose 'Service provider assertion' for 'dataManagementLocations--assurance'
    And I choose 'UK' for 'legalJurisdiction'
    And I choose 'Service provider assertion' for 'legalJurisdiction--assurance'
    And I choose 'Yes' for 'datacentreProtectionDisclosure'
    And I choose 'Service provider assertion' for 'datacentreProtectionDisclosure--assurance'
    And I check 'dataAtRestProtections-2'
    And I choose 'Service provider assertion' for 'dataAtRestProtections--assurance'
    And I choose 'CESG or CPNI-approved erasure process' for 'dataSecureDeletion'
    And I choose 'Service provider assertion' for 'dataSecureDeletion--assurance'
    And I fill in 'serviceAvailabilityPercentage' with '99'
    And I choose 'Service provider assertion' for 'serviceAvailabilityPercentage--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation between consumers' page

  Scenario: Separation between consumers
    Given I am on ssp page 'separation_between_consumers'
    When I choose 'Public cloud' for 'cloudDeploymentModel'
    And I choose 'Service provider assertion' for 'cloudDeploymentModel--assurance'
    And I choose 'No other consumer' for 'otherConsumers'
    And I choose 'Service provider assertion' for 'otherConsumers--assurance'
    And I choose 'Yes' for 'servicesSeparation'
    And I choose 'Service provider assertion' for 'servicesSeparation--assurance'
    And I choose 'Yes' for 'servicesManagementSeparation'
    And I choose 'Service provider assertion' for 'servicesManagementSeparation--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Governance' page

  Scenario: Governance
    Given I am on ssp page 'governance'
    When I choose 'Yes' for 'governanceFramework'
    And I choose 'Service provider assertion' for 'governanceFramework--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Configuration and change management' page

  Scenario: Configuration and change management
    Given I am on ssp page 'configuration_and_change_management'
    When I choose 'Yes' for 'changeImpactAssessment'
    And I choose 'Service provider assertion' for 'changeImpactAssessment--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Vulnerabilility management' page

  Scenario: Vulnerabilility management
    Given I am on ssp page 'vulnerabilility_management'
    When I choose 'Yes' for 'vulnerabilityAssessment'
    And I choose 'Service provider assertion' for 'vulnerabilityAssessment--assurance'
    And I choose 'Yes' for 'vulnerabilityMonitoring'
    And I choose 'Service provider assertion' for 'vulnerabilityMonitoring--assurance'
    And I choose 'No' for 'vulnerabilityMitigationPrioritisation'
    And I choose 'Service provider assertion' for 'vulnerabilityMitigationPrioritisation--assurance'
    And I choose 'Yes' for 'vulnerabilityTracking'
    And I choose 'Service provider assertion' for 'vulnerabilityTracking--assurance'
    And I choose 'Yes' for 'vulnerabilityTimescales'
    And I choose 'Service provider assertion' for 'vulnerabilityTimescales--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Event monitoring' page

  Scenario: Event monitoring
    Given I am on ssp page 'event_monitoring'
    When I choose 'Yes' for 'eventMonitoring'
    And I choose 'Service provider assertion' for 'eventMonitoring--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Incident management' page

  Scenario: Incident management
    Given I am on ssp page 'incident_management'
    When I choose 'Yes' for 'incidentManagementProcess'
    And I choose 'Service provider assertion' for 'incidentManagementProcess--assurance'
    And I choose 'No' for 'incidentManagementReporting'
    And I choose 'Service provider assertion' for 'incidentManagementReporting--assurance'
    And I choose 'Yes' for 'incidentDefinitionPublished'
    And I choose 'Service provider assertion' for 'incidentDefinitionPublished--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Personnel security' page

  Scenario: Personnel security
    Given I am on ssp page 'personnel_security'
    When I check 'Security clearance national vetting (SC)'
    And I choose 'Service provider assertion' for 'personnelSecurityChecks--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure development' page

  Scenario: Secure development
    Given I am on ssp page 'secure_development'
    When I choose 'Yes' for 'secureDevelopment'
    And I choose 'Service provider assertion' for 'secureDevelopment--assurance'
    And I choose 'Yes' for 'secureDesign'
    And I choose 'Service provider assertion' for 'secureDesign--assurance'
    And I choose 'Yes' for 'secureConfigurationManagement'
    And I choose 'Service provider assertion' for 'secureConfigurationManagement--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Supply-chain security' page

  Scenario: Supply-chain security
    Given I am on ssp page 'supply_chain_security'
    When I choose 'Yes' for 'thirdPartyDataSharingInformation'
    And I choose 'Service provider assertion' for 'thirdPartyDataSharingInformation--assurance'
    And I choose 'Yes' for 'thirdPartySecurityRequirements'
    And I choose 'Service provider assertion' for 'thirdPartySecurityRequirements--assurance'
    And I choose 'Yes' for 'thirdPartyRiskAssessment'
    And I choose 'Service provider assertion' for 'thirdPartyRiskAssessment--assurance'
    And I choose 'Yes' for 'thirdPartyComplianceMonitoring'
    And I choose 'Service provider assertion' for 'thirdPartyComplianceMonitoring--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Authentication of consumers' page

  Scenario: Authentication of consumers
    Given I am on ssp page 'authentication_of_consumers'
    When I choose 'Yes' for 'userAuthenticateManagement'
    And I choose 'Service provider assertion' for 'userAuthenticateManagement--assurance'
    And I choose 'Yes' for 'userAuthenticateSupport'
    And I choose 'Service provider assertion' for 'userAuthenticateSupport--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation and access control within management interfaces' page

  Scenario: Separation and access control within management interfaces
    Given I am on ssp page 'separation_and_access_control_within_management_interfaces'
    When I choose 'Yes' for 'userAccessControlManagement'
    And I choose 'Service provider assertion' for 'userAccessControlManagement--assurance'
    And I choose 'Yes' for 'restrictAdministratorPermissions'
    And I choose 'Service provider assertion' for 'restrictAdministratorPermissions--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Identity and authentication' page

  Scenario: Identity and authentication
    Given I am on ssp page 'identity_and_authentication'
    When I check 'Username and two-factor authentication'
    And I choose 'Service provider assertion' for 'identityAuthenticationControls--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure service administration' page

  Scenario: Secure service administration
    Given I am on ssp page 'secure_service_administration'
    When I check 'Dedicated devices on a segregated network'
    And I choose 'Service provider assertion' for 'serviceManagementModel--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Audit information provision to consumers' page

  Scenario: Audit information provision to consumers
    Given I am on ssp page 'audit_information_provision_to_consumers'
    When I choose 'None' for 'auditInformationProvided'
    And I choose 'Service provider assertion' for 'auditInformationProvided--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure use of the service by the customer' page

  Scenario: Secure use of the service by the customer
    Given I am on ssp page 'secure_use_of_the_service_by_the_customer'
    When I check 'Corporate/enterprise devices'
    And I choose 'Service provider assertion' for 'deviceAccessMethod--assurance'
    And I choose 'Yes' for 'trainingProvided'
    And I choose 'Service provider assertion' for 'trainingProvided--assurance'
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
    Then I should be on the 'My SaaS service' page

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
    And I click 'Yes, delete “My SaaS service”'
    Then I should be on the g7 services page
    And My service should not be in the list

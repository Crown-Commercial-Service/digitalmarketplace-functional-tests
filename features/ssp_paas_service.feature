@not-production @functional-test
Feature: Submitting a new service for PaaS
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select lot
    Given I am at '/suppliers'
    When I click 'Apply to become a G-Cloud 7 supplier and add services'
    And I click 'Add a service'
    When I choose 'Platform as a Service (PaaS)'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on ssp page 'service_description'
    When I fill in 'serviceName' with 'My PaaS service'
    And I fill in 'serviceSummary' with:
      """
      Platform as a service (PaaS) is a category of cloud computing services that provides a computing platform and a solution stack as a service.
      """
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on ssp page 'features_and_benefits'
    When I fill in 'serviceFeatures-1' with 'Super greatness'
    And I fill in 'serviceBenefits-1' with 'Great superness'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on ssp page 'pricing'
    When I fill in 'priceStringMinPrice' with '99'
    And I fill in 'priceStringMaxPrice' with '100'
    And I select 'Unit' from 'priceStringUnit'
    And I select 'Second' from 'priceStringInterval'
    And I choose 'vatIncluded-no'
    And I choose 'educationPricing-yes'
    And I choose 'trialOption-yes'
    And I choose 'freeOption-no'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'terms_and_conditions'
    When I choose 'terminationCost-yes'
    And I choose 'minimumContractPeriod-3'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  Scenario: Support
    Given I am on ssp page 'support'
    When I check 'supportTypes-1'
    And I choose 'supportForThirdParties-yes'
    And I fill in 'supportAvailability' with '24/7'
    And I fill in 'supportResponseTime' with '1 hour'
    And I choose 'incidentEscalation-no'
    And I click 'Save and continue'
    Then I should be on the 'Open standards' page

  Scenario: Open standards
    Given I am on ssp page 'open_standards'
    When I choose 'openStandardsSupported-yes'
    And I click 'Save and continue'
    Then I should be on the 'Onboarding and offboarding' page

  Scenario: Onboarding and offboarding
    Given I am on ssp page 'onboarding_and_offboarding'
    When I choose 'serviceOnboarding-no'
    And I choose 'serviceOffboarding-yes'
    And I click 'Save and continue'
    Then I should be on the 'Analytics' page

  Scenario: Analytics
    Given I am on ssp page 'analytics'
    When I choose 'analyticsAvailable-no'
    And I click 'Save and continue'
    Then I should be on the 'Cloud features' page

  Scenario: Cloud features
    Given I am on ssp page 'cloud_features'
    When I choose 'elasticCloud-yes'
    And I choose 'guaranteedResources-no'
    And I choose 'persistentStorage-no'
    And I click 'Save and continue'
    Then I should be on the 'Provisioning' page

  Scenario: Provisioning
    Given I am on ssp page 'provisioning'
    When I choose 'selfServiceProvisioning-yes'
    And I fill in 'provisioningTime' with '5 hours'
    And I fill in 'deprovisioningTime' with '6 hours'
    And I click 'Save and continue'
    Then I should be on the 'Open source' page

  Scenario: Open source
    Given I am on ssp page 'open_source'
    When I choose 'openSource-yes'
    And I click 'Save and continue'
    Then I should be on the 'API access' page

  Scenario: API access
    Given I am on ssp page 'api_access'
    When I choose 'apiAccess-yes'
    And I fill in 'apiType' with 'SOAP'
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
    And I choose 'offlineWorking-yes'
    And I check 'PC'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on ssp page 'certifications'
    When I click 'Save and continue'
    Then I should be on the 'Data storage' page

  Scenario: Data storage
    Given I am on ssp page 'data_storage'
    When I choose 'datacentresEUCode-no'
    And I choose 'datacentresSpecifyLocation-yes'
    And I choose 'datacentreTier-5'
    And I choose 'dataBackupRecovery-yes'
    And I choose 'dataExtractionRemoval-yes'
    And I click 'Save and continue'
    Then I should be on the 'Data-in-transit protection' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the g7 supplier dashboard page
    When I click my service
    Then I should be on the 'My PaaS service' page
    And The string 'Answer required' should be on the page
    And The string 'The service is complete' should not be on the page

  Scenario: Data-in-transit protection
    Given I am on ssp page 'data_in_transit_protection'
    When I check 'dataProtectionBetweenUserAndService-1'
    And I choose 'dataProtectionBetweenUserAndService--assurance-2'
    And I check 'dataProtectionWithinService-3'
    And I choose 'dataProtectionWithinService--assurance-2'
    And I check 'dataProtectionBetweenServices-1'
    And I choose 'dataProtectionBetweenServices--assurance-4'
    And I click 'Save and continue'
    Then I should be on the 'Asset protection and resilience' page

  Scenario: Asset protection and resilience
    Given I am on ssp page 'asset_protection_and_resilience'
    When I check 'datacentreLocations-1'
    And I choose 'datacentreLocations--assurance-1'
    And I check 'dataManagementLocations-1'
    And I choose 'dataManagementLocations--assurance-1'
    And I choose 'legalJurisdiction-1'
    And I choose 'legalJurisdiction--assurance-1'
    And I choose 'datacentreProtectionDisclosure-yes'
    And I choose 'datacentreProtectionDisclosure--assurance-1'
    And I check 'dataAtRestProtections-1'
    And I choose 'dataAtRestProtections--assurance-1'
    And I choose 'dataSecureDeletion-2'
    And I choose 'dataSecureDeletion--assurance-1'
    And I choose 'dataStorageMediaDisposal-1'
    And I choose 'dataStorageMediaDisposal--assurance-1'
    And I choose 'dataSecureEquipmentDisposal-yes'
    And I choose 'dataSecureEquipmentDisposal--assurance-1'
    And I choose 'dataRedundantEquipmentAccountsRevoked-no'
    And I choose 'dataRedundantEquipmentAccountsRevoked--assurance-1'
    And I fill in 'serviceAvailabilityPercentage' with '99.99'
    And I choose 'serviceAvailabilityPercentage--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Separation between consumers' page

  Scenario: Separation between consumers
    Given I am on ssp page 'separation_between_consumers'
    When I choose 'cloudDeploymentModel-1'
    And I choose 'cloudDeploymentModel--assurance-1'
    And I choose 'otherConsumers-1'
    And I choose 'otherConsumers--assurance-1'
    And I choose 'servicesSeparation-yes'
    And I choose 'servicesSeparation--assurance-1'
    And I choose 'servicesManagementSeparation-yes'
    And I choose 'servicesManagementSeparation--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Governance' page

  Scenario: Governance
    Given I am on ssp page 'governance'
    When I choose 'governanceFramework-yes'
    And I choose 'governanceFramework--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Configuration and change management' page

  Scenario: Configuration and change management
    Given I am on ssp page 'configuration_and_change_management'
    When I choose 'configurationTracking-yes'
    And I choose 'configurationTracking--assurance-1'
    And I choose 'changeImpactAssessment-yes'
    And I choose 'changeImpactAssessment--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Vulnerabilility management' page

  Scenario: Vulnerabilility management
    Given I am on ssp page 'vulnerabilility_management'
    When I choose 'vulnerabilityAssessment-yes'
    And I choose 'vulnerabilityAssessment--assurance-1'
    And I choose 'vulnerabilityMonitoring-yes'
    And I choose 'vulnerabilityMonitoring--assurance-1'
    And I choose 'vulnerabilityMitigationPrioritisation-no'
    And I choose 'vulnerabilityMitigationPrioritisation--assurance-1'
    And I choose 'vulnerabilityTracking-yes'
    And I choose 'vulnerabilityTracking--assurance-1'
    And I choose 'vulnerabilityTimescales-yes'
    And I choose 'vulnerabilityTimescales--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Event monitoring' page

  Scenario: Event monitoring
    Given I am on ssp page 'event_monitoring'
    When I choose 'eventMonitoring-yes'
    And I choose 'eventMonitoring--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Incident management' page

  Scenario: Incident management
    Given I am on ssp page 'incident_management'
    When I choose 'incidentManagementProcess-yes'
    And I choose 'incidentManagementProcess--assurance-1'
    And I choose 'incidentManagementReporting-no'
    And I choose 'incidentManagementReporting--assurance-1'
    And I choose 'incidentDefinitionPublished-yes'
    And I choose 'incidentDefinitionPublished--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Personnel security' page

  Scenario: Personnel security
    Given I am on ssp page 'personnel_security'
    When I check 'Security clearance national vetting (SC)'
    And I choose 'personnelSecurityChecks--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Secure development' page

  Scenario: Secure development
    Given I am on ssp page 'secure_development'
    When I choose 'secureDevelopment-yes'
    And I choose 'secureDevelopment--assurance-1'
    And I choose 'secureDesign-yes'
    And I choose 'secureDesign--assurance-1'
    And I choose 'secureConfigurationManagement-yes'
    And I choose 'secureConfigurationManagement--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Supply-chain security' page

  Scenario: Supply-chain security
    Given I am on ssp page 'supply_chain_security'
    When I choose 'thirdPartyDataSharingInformation-yes'
    And I choose 'thirdPartyDataSharingInformation--assurance-1'
    And I choose 'thirdPartySecurityRequirements-yes'
    And I choose 'thirdPartySecurityRequirements--assurance-1'
    And I choose 'thirdPartyRiskAssessment-yes'
    And I choose 'thirdPartyRiskAssessment--assurance-1'
    And I choose 'thirdPartyComplianceMonitoring-yes'
    And I choose 'thirdPartyComplianceMonitoring--assurance-1'
    And I choose 'hardwareSoftwareVerification-yes'
    And I choose 'hardwareSoftwareVerification--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Authentication of consumers' page

  Scenario: Authentication of consumers
    Given I am on ssp page 'authentication_of_consumers'
    When I choose 'userAuthenticateManagement-yes'
    And I choose 'userAuthenticateManagement--assurance-1'
    And I choose 'userAuthenticateSupport-yes'
    And I choose 'userAuthenticateSupport--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Separation and access control within management interfaces' page

  Scenario: Separation and access control within management interfaces
    Given I am on ssp page 'separation_and_access_control_within_management_interfaces'
    When I choose 'userAccessControlManagement-yes'
    And I choose 'userAccessControlManagement--assurance-1'
    And I choose 'restrictAdministratorPermissions-yes'
    And I choose 'restrictAdministratorPermissions--assurance-1'
    And I choose 'managementInterfaceProtection-yes'
    And I choose 'managementInterfaceProtection--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Identity and authentication' page

  Scenario: Identity and authentication
    Given I am on ssp page 'identity_and_authentication'
    When I check 'Username and two-factor authentication'
    And I choose 'identityAuthenticationControls--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'External interface protection' page

  Scenario: External interface protection
    Given I am on ssp page 'external_interface_protection'
    When I choose 'onboardingGuidance-yes'
    And I choose 'onboardingGuidance--assurance-1'
    And I check 'Encrypted PSN service'
    And I choose 'interconnectionMethods--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Secure service administration' page

  Scenario: Secure service administration
    Given I am on ssp page 'secure_service_administration'
    When I check 'Dedicated devices on a segregated network'
    And I choose 'serviceManagementModel--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Audit information provision to consumers' page

  Scenario: Audit information provision to consumers
    Given I am on ssp page 'audit_information_provision_to_consumers'
    When I choose 'auditInformationProvided-1'
    And I choose 'auditInformationProvided--assurance-1'
    And I click 'Save and continue'
    Then I should be on the 'Secure use of the service by the customer' page

  Scenario: Secure use of the service by the customer
    Given I am on ssp page 'secure_use_of_the_service_by_the_customer'
    When I check 'Corporate/enterprise devices'
    And I choose 'deviceAccessMethod--assurance-1'
    And I choose 'serviceConfigurationGuidance-yes'
    And I choose 'serviceConfigurationGuidance--assurance-1'
    And I choose 'trainingProvided-yes'
    And I choose 'trainingProvided--assurance-1'
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
    Then I should be on the 'My PaaS service' page

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
    And I click 'Yes, delete “My PaaS service”'
    Then I should be on the g7 supplier dashboard page
    And My service should not be in the list

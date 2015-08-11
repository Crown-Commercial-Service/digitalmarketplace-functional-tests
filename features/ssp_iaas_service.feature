@not-production @functional-test @ssp
Feature: Submitting a new service for IaaS
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
    When I choose 'Infrastructure as a Service (IaaS)'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page


  Scenario: Provide a service description
    Given I am on ssp page 'service_description'
    When I fill in 'serviceName' with 'My IaaS service'
    And I fill in 'serviceSummary' with:
      """
      My IaaS service that does stuff with stuff.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on ssp page 'service_type'
    When I check 'Compute'
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
    When I fill in 'priceStringMinPrice' with '100'
    And I fill in 'priceStringMaxPrice' with '1000'
    And I select 'Unit' from 'priceStringUnit'
    And I select 'Second' from 'priceStringInterval'
    And I choose 'vatIncluded-yes'
    And I choose 'educationPricing-no'
    And I choose 'trialOption-yes'
    And I choose 'freeOption-no'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'terms_and_conditions'
    When I choose 'terminationCost-no'
    And I choose 'minimumContractPeriod-3'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  Scenario: Support
    Given I am on ssp page 'support'
    When I check 'Service desk'
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
    And I fill in 'apiType' with 'JSON'
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
    When I fill in 'vendorCertifications-1' with 'Stuff magic'
    And I click 'Save and continue'
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

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the g7 services page
    When I click my service
    Then I should be on the 'My IaaS service' page
    And The string 'Answer required' should be on the page
    And The string 'The service is complete' should not be on the page

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
    Then I should be on the 'My IaaS service' page

  # TODO: Remove WIP once completing services is implemented
  @wip
  Scenario: The service is complete
    Given I am on the summary page
    Then The string 'Answer required' should not be on the page
    And The string 'The service is complete' should be on the page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Service type' should contain 'IaaS'
    And Summary row 'Service name' should contain 'My IaaS service'
    And Summary row 'Service summary' should contain 'My IaaS service that does stuff with stuff.'
    # TODO: Uncomment once serviceType bug has been fixed
    # And Summary row 'Service type' should contain 'Compute'
    And Summary row 'Service features' should contain 'Super greatness'
    And Summary row 'Service benefits' should contain 'Great superness'
    And Summary row 'Service price' should contain '£100 to £1000 per unit per second'
    And Summary row 'VAT included' should contain 'Yes'
    And Summary row 'Education pricing' should contain 'No'
    And Summary row 'Trial option' should contain 'Yes'
    And Summary row 'Free option' should contain 'No'
    And Summary row 'Termination cost' should contain 'No'
    And Summary row 'Minimum contract period' should contain 'Month'
    And Summary row 'Support service type' should contain 'Service desk'
    And Summary row 'Support accessible to any third-party suppliers' should contain 'Yes'
    And Summary row 'Support availability' should contain '24/7'
    And Summary row 'Standard support response times' should contain '1 hour'
    And Summary row 'Incident escalation process available' should contain 'No'
    And Summary row 'Open standards supported and documented' should contain 'Yes'
    And Summary row 'Service onboarding process included' should contain 'No'
    And Summary row 'Service offboarding process included' should contain 'Yes'
    And Summary row 'Real-time management information available' should contain 'No'
    And Summary row 'Elastic cloud approach supported' should contain 'Yes'
    And Summary row 'Guaranteed resources defined' should contain 'No'
    And Summary row 'Persistent storage supported' should contain 'No'
    And Summary row 'Self-service provisioning supported' should contain 'Yes'
    And Summary row 'Service provisioning time' should contain '5 hours'
    And Summary row 'Service deprovisioning time' should contain '6 hours'
    And Summary row 'Open-source software used and supported' should contain 'Yes'
    And Summary row 'API access available and supported' should contain 'Yes'
    And Summary row 'API type' should contain 'JSON'
    And Summary row 'Networks the service is directly connected to' should contain 'Internet'
    And Summary row 'Supported web browsers' should contain 'Opera'
    And Summary row 'Offline working and syncing supported' should contain 'Yes'
    And Summary row 'Supported devices' should contain 'PC'
    And Summary row 'Vendor certification(s)' should contain 'Stuff magic'
    And Summary row 'Datacentres adhere to EU Code of Conduct for Operations' should contain 'No'
    And Summary row 'User-defined data location' should contain 'Yes'
    And Summary row 'Datacentre tier' should contain 'Uptime Institute Tier 1'
    And Summary row 'Backup, disaster recovery and resilience plan in place' should contain 'Yes'
    And Summary row 'Data extraction/removal plan in place' should contain 'Yes'
    And Summary row 'Data protection between user device and service' should contain 'Encrypted PSN service, assured by independent validation of assertion'
    And Summary row 'Data protection within service' should contain 'VLAN, assured by independent validation of assertion'
    And Summary row 'Data protection between services' should contain 'Encrypted PSN service, assured by CESG-assured components'
    And Summary row 'Datacentre location' should contain 'UK'
    And Summary row 'Data management location' should contain 'UK'
    And Summary row 'Legal jurisdiction of service provider' should contain 'UK'
    And Summary row 'Datacentre protection' should contain 'Yes'
    And Summary row 'Data-at-rest protection' should contain 'CPA Foundation-grade assured components'
    And Summary row 'Secure data deletion' should contain 'CESG or CPNI-approved erasure process'
    And Summary row 'Storage media disposal' should contain 'CESG-assured destruction service (CAS(T))'
    And Summary row 'Secure equipment disposal' should contain 'Yes'
    And Summary row 'Redundant equipment accounts revoked' should contain 'No'
    And Summary row 'Service availability' should contain '99.99%'
    And Summary row 'Cloud deployment model' should contain 'Public cloud'
    And Summary row 'Type of consumer' should contain 'No other consumer'
    And Summary row 'Services separation' should contain 'Yes'
    And Summary row 'Services management separation' should contain 'Yes'
    And Summary row 'Governance framework' should contain 'Yes'
    And Summary row 'Configuration and change management tracking' should contain 'Yes'
    And Summary row 'Change impact assessment' should contain 'Yes'
    And Summary row 'Vulnerability assessment' should contain 'Yes'
    And Summary row 'Vulnerability monitoring' should contain 'Yes'
    And Summary row 'Vulnerability mitigation prioritisation' should contain 'No'
    And Summary row 'Vulnerability tracking' should contain 'Yes'
    And Summary row 'Vulnerability mitigation timescales' should contain 'Yes'
    And Summary row 'Event monitoring' should contain 'Yes'
    And Summary row 'Incident management processes' should contain 'Yes'
    And Summary row 'Consumer reporting of security incidents' should contain 'No'
    And Summary row 'Security incident definition published' should contain 'Yes'
    And Summary row 'Personnel security checks' should contain 'Security clearance national vetting (SC)'
    And Summary row 'Secure development' should contain 'Yes'
    And Summary row 'Secure design, coding, testing and deployment' should contain 'Yes'
    And Summary row 'Software configuration management' should contain 'Yes'
    And Summary row 'Visibility of data shared with third-party suppliers' should contain 'Yes'
    And Summary row 'Third-party supplier security requirements' should contain 'Yes'
    And Summary row 'Third-party supplier risk assessment' should contain 'Yes'
    And Summary row 'Third-party supplier compliance monitoring' should contain 'Yes'
    And Summary row 'Hardware and software verification' should contain 'Yes'
    And Summary row 'User authentication and access management' should contain 'Yes'
    And Summary row 'User access control through support channels' should contain 'Yes'
    And Summary row 'User access control within management interfaces' should contain 'Yes'
    And Summary row 'Administrator permissions' should contain 'Yes'
    And Summary row 'Management interface protection' should contain 'Yes'
    And Summary row 'Identity and authentication controls' should contain 'Username and two-factor authentication'
    And Summary row 'Onboarding guidance provided' should contain 'Yes'
    And Summary row 'Interconnection method provided' should contain 'Encrypted PSN service'
    And Summary row 'Service management model' should contain 'Dedicated devices on a segregated network'
    And Summary row 'Audit information provided' should contain 'None'
    And Summary row 'Device access method' should contain 'Corporate/enterprise devices'
    And Summary row 'Service configuration guidance' should contain 'Yes'
    And Summary row 'Training' should contain 'Yes'
    And Summary row 'Service definition document' should not contain 'Answer required'
    # TODO: Uncomment once SSP content change has been merged
    # And Summary row 'Terms and conditions document' should not contain 'Answer required'
    And Summary row 'Pricing document' should not contain 'Answer required'
    And Summary row 'Skills Framework for the Information Age (SFIA) rate card' should not be empty

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “My IaaS service”'
    Then I should be on the g7 services page
    And My service should not be in the list

@not-production @functional-test @ssp-gcloud
Feature: Submitting a new service for IaaS
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Digital Marketplace' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select lot
    Given I am at '/suppliers'
    When I click 'Continue your G-Cloud 8 application'
    And I click 'Add, edit and complete services'

    When I click 'Infrastructure as a Service (IaaS)'
    And I click 'Add a service'
    Then I am taken to the 'Service name' page

  Scenario: Provide a service name
    Given I am on the service name page for 'iaas'
    When I fill in 'serviceName' with 'My IaaS'
    And I click 'Save and continue'
    Then I should be on the 'My IaaS' page

  Scenario: Edit a service name
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Service name'
    Then I should be on the 'Service name' page

    When I fill in 'serviceName' with 'My IaaS service'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Service description'
    Then I should be on the 'Service description' page

    When I fill in 'serviceSummary' with:
      """
      My IaaS service that does stuff with stuff.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Service type'
    Then I should be on the 'Service type' page

    When I 'check' 'Compute' for 'serviceTypes'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Features and benefits'
    Then I should be on the 'Features and benefits' page

    When I fill in 'input-serviceFeatures-1' with 'Super greatness'
    And I fill in 'input-serviceBenefits-1' with 'Great superness'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Pricing'
    Then I should be on the 'Pricing' page

    When I fill in 'priceMin' with '100'
    And I fill in 'priceMax' with '1000'
    And I select 'Unit' from 'priceUnit'
    And I select 'Second' from 'priceInterval'
    And I choose 'Yes' for 'vatIncluded'
    And I choose 'No' for 'educationPricing'
    And I choose 'Yes' for 'trialOption'
    And I choose 'No' for 'freeOption'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Terms and conditions'
    Then I should be on the 'Terms and conditions' page

    When I choose 'No' for 'terminationCost'
    And I choose 'Month' for 'minimumContractPeriod'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  Scenario: Support
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Support'
    Then I should be on the 'Support' page

    When I 'check' 'Service desk' for 'supportTypes'
    And I choose 'Yes' for 'supportForThirdParties'
    And I fill in 'supportAvailability' with '24/7'
    And I fill in 'supportResponseTime' with '1 hour'
    And I choose 'No' for 'incidentEscalation'
    And I click 'Save and continue'
    Then I should be on the 'Open standards' page

  Scenario: Open standards
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Open standards'
    Then I should be on the 'Open standards' page

    When I choose 'Yes' for 'openStandardsSupported'
    And I click 'Save and continue'
    Then I should be on the 'Onboarding and offboarding' page

  Scenario: Onboarding and offboarding
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Onboarding and offboarding'
    Then I should be on the 'Onboarding and offboarding' page

    When I choose 'No' for 'serviceOnboarding'
    And I choose 'Yes' for 'serviceOffboarding'
    And I click 'Save and continue'
    Then I should be on the 'Analytics' page

  Scenario: Analytics
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Analytics'
    Then I should be on the 'Analytics' page

    When I choose 'No' for 'analyticsAvailable'
    And I click 'Save and continue'
    Then I should be on the 'Cloud features' page

  Scenario: Cloud features
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Cloud features'
    Then I should be on the 'Cloud features' page

    When I choose 'Yes' for 'elasticCloud'
    And I choose 'No' for 'guaranteedResources'
    And I choose 'No' for 'persistentStorage'
    And I click 'Save and continue'
    Then I should be on the 'Provisioning' page

  Scenario: Provisioning
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Provisioning'
    Then I should be on the 'Provisioning' page

    When I choose 'Yes' for 'selfServiceProvisioning'
    And I fill in 'provisioningTime' with '5 hours'
    And I fill in 'deprovisioningTime' with '6 hours'
    And I click 'Save and continue'
    Then I should be on the 'Open source' page

  Scenario: Open source
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Open source'
    Then I should be on the 'Open source' page

    When I choose 'Yes' for 'openSource'
    And I click 'Save and continue'
    Then I should be on the 'API access' page

  Scenario: API access
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'API access'
    Then I should be on the 'API access' page

    When I choose 'Yes' for 'apiAccess'
    And I fill in 'apiType' with 'JSON'
    And I click 'Save and continue'
    Then I should be on the 'Networks and connectivity' page

  Scenario: Networks and connectivity
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Networks and connectivity'
    Then I should be on the 'Networks and connectivity' page

    When I 'check' 'Internet' for 'networksConnected'
    And I click 'Save and continue'
    Then I should be on the 'Access' page

  Scenario: Access
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Access'
    Then I should be on the 'Access' page

    When I 'check' 'Opera' for 'supportedBrowsers'
    And I choose 'Yes' for 'offlineWorking'
    And I 'check' 'PC' for 'supportedDevices'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Certifications'
    Then I should be on the 'Certifications' page

    When I fill in 'input-vendorCertifications-1' with 'Stuff magic'
    And I click 'Save and continue'
    Then I should be on the 'Data storage' page

  Scenario: Data storage
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Data storage'
    Then I should be on the 'Data storage' page

    When I choose 'No' for 'datacentresEUCode'
    And I choose 'Yes' for 'datacentresSpecifyLocation'
    And I choose 'Uptime Institute Tier 1' for 'datacentreTier'
    And I choose 'Yes' for 'dataBackupRecovery'
    And I choose 'Yes' for 'dataExtractionRemoval'
    And I click 'Save and continue'
    Then I should be on the 'Data-in-transit protection' page

  Scenario: Data-in-transit protection
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Data-in-transit protection'
    Then I should be on the 'Data-in-transit protection' page

    When I 'check' 'input-dataProtectionBetweenUserAndService-1' for 'dataProtectionBetweenUserAndService'
    And I choose 'independent validation of assertion' for 'dataProtectionBetweenUserAndService--assurance'
    And I 'check' 'input-dataProtectionWithinService-3' for 'dataProtectionWithinService'
    And I choose 'independent validation of assertion' for 'dataProtectionWithinService--assurance'
    And I 'check' 'input-dataProtectionBetweenServices-1' for 'dataProtectionBetweenServices'
    And I choose 'CESG-assured components' for 'dataProtectionBetweenServices--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Asset protection and resilience' page

  Scenario: Asset protection and resilience
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Asset protection and resilience'
    Then I should be on the 'Asset protection and resilience' page

    When I 'check' 'input-datacentreLocations-1' for 'datacentreLocations'
    And I choose 'service provider assertion' for 'datacentreLocations--assurance'
    And I 'check' 'input-dataManagementLocations-1' for 'dataManagementLocations'
    And I choose 'service provider assertion' for 'dataManagementLocations--assurance'
    And I choose 'UK' for 'legalJurisdiction'
    And I choose 'service provider assertion' for 'legalJurisdiction--assurance'
    And I choose 'Yes' for 'datacentreProtectionDisclosure'
    And I choose 'service provider assertion' for 'datacentreProtectionDisclosure--assurance'
    And I 'check' 'input-dataAtRestProtections-1' for 'dataAtRestProtections'
    And I choose 'service provider assertion' for 'dataAtRestProtections--assurance'
    And I choose 'CESG or CPNI-approved erasure process' for 'dataSecureDeletion'
    And I choose 'service provider assertion' for 'dataSecureDeletion--assurance'
    And I choose 'CESG-assured destruction service (CAS(T))' for 'dataStorageMediaDisposal'
    And I choose 'service provider assertion' for 'dataStorageMediaDisposal--assurance'
    And I choose 'Yes' for 'dataSecureEquipmentDisposal'
    And I choose 'service provider assertion' for 'dataSecureEquipmentDisposal--assurance'
    And I choose 'No' for 'dataRedundantEquipmentAccountsRevoked'
    And I choose 'service provider assertion' for 'dataRedundantEquipmentAccountsRevoked--assurance'
    And I fill in 'serviceAvailabilityPercentage' with '99.99'
    And I choose 'service provider assertion' for 'serviceAvailabilityPercentage--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation between consumers' page

  Scenario: Separation between consumers
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Separation between consumers'
    Then I should be on the 'Separation between consumers' page

    When I choose 'Public cloud' for 'cloudDeploymentModel'
    And I choose 'service provider assertion' for 'cloudDeploymentModel--assurance'
    And I choose 'No other consumer' for 'otherConsumers'
    And I choose 'service provider assertion' for 'otherConsumers--assurance'
    And I choose 'Yes' for 'servicesSeparation'
    And I choose 'service provider assertion' for 'servicesSeparation--assurance'
    And I choose 'Yes' for 'servicesManagementSeparation'
    And I choose 'service provider assertion' for 'servicesManagementSeparation--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Governance' page

  Scenario: Governance
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Governance'
    Then I should be on the 'Governance' page

    When I choose 'Yes' for 'governanceFramework'
    And I choose 'service provider assertion' for 'governanceFramework--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Configuration and change management' page

  Scenario: Configuration and change management
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Configuration and change management'
    Then I should be on the 'Configuration and change management' page

    When I choose 'Yes' for 'configurationTracking'
    And I choose 'service provider assertion' for 'configurationTracking--assurance'
    And I choose 'Yes' for 'changeImpactAssessment'
    And I choose 'service provider assertion' for 'changeImpactAssessment--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Vulnerability management' page

  Scenario: Vulnerability management
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Vulnerability management'
    Then I should be on the 'Vulnerability management' page

    When I choose 'Yes' for 'vulnerabilityAssessment'
    And I choose 'service provider assertion' for 'vulnerabilityAssessment--assurance'
    And I choose 'Yes' for 'vulnerabilityMonitoring'
    And I choose 'service provider assertion' for 'vulnerabilityMonitoring--assurance'
    And I choose 'No' for 'vulnerabilityMitigationPrioritisation'
    And I choose 'service provider assertion' for 'vulnerabilityMitigationPrioritisation--assurance'
    And I choose 'Yes' for 'vulnerabilityTracking'
    And I choose 'service provider assertion' for 'vulnerabilityTracking--assurance'
    And I choose 'Yes' for 'vulnerabilityTimescales'
    And I choose 'service provider assertion' for 'vulnerabilityTimescales--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Event monitoring' page

  Scenario: Event monitoring
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Event monitoring'
    Then I should be on the 'Event monitoring' page

    When I choose 'Yes' for 'eventMonitoring'
    And I choose 'service provider assertion' for 'eventMonitoring--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Incident management' page

  Scenario: Incident management
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Incident management'
    Then I should be on the 'Incident management' page

    When I choose 'Yes' for 'incidentManagementProcess'
    And I choose 'service provider assertion' for 'incidentManagementProcess--assurance'
    And I choose 'No' for 'incidentManagementReporting'
    And I choose 'service provider assertion' for 'incidentManagementReporting--assurance'
    And I choose 'Yes' for 'incidentDefinitionPublished'
    And I choose 'service provider assertion' for 'incidentDefinitionPublished--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Personnel security' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the 'Infrastructure as a Service services' page
    Then My service should be in the list

    When I click my service
    Then I should be on the 'My IaaS service' page
    And The string 'Answer required' should be on the page
    And The 'Mark as complete' button should not be on the page

  Scenario: Personnel security
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Personnel security'
    Then I should be on the 'Personnel security' page

    When I 'check' 'Security clearance national vetting (SC)' for 'personnelSecurityChecks'
    And I choose 'service provider assertion' for 'personnelSecurityChecks--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure development' page

  Scenario: Secure development
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Secure development'
    Then I should be on the 'Secure development' page

    When I choose 'Yes' for 'secureDevelopment'
    And I choose 'service provider assertion' for 'secureDevelopment--assurance'
    And I choose 'Yes' for 'secureDesign'
    And I choose 'service provider assertion' for 'secureDesign--assurance'
    And I choose 'Yes' for 'secureConfigurationManagement'
    And I choose 'service provider assertion' for 'secureConfigurationManagement--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Supply-chain security' page

  Scenario: Supply-chain security
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Supply-chain security'
    Then I should be on the 'Supply-chain security' page

    When I choose 'Yes' for 'thirdPartyDataSharingInformation'
    And I choose 'service provider assertion' for 'thirdPartyDataSharingInformation--assurance'
    And I choose 'Yes' for 'thirdPartySecurityRequirements'
    And I choose 'service provider assertion' for 'thirdPartySecurityRequirements--assurance'
    And I choose 'Yes' for 'thirdPartyRiskAssessment'
    And I choose 'service provider assertion' for 'thirdPartyRiskAssessment--assurance'
    And I choose 'Yes' for 'thirdPartyComplianceMonitoring'
    And I choose 'service provider assertion' for 'thirdPartyComplianceMonitoring--assurance'
    And I choose 'Yes' for 'hardwareSoftwareVerification'
    And I choose 'service provider assertion' for 'hardwareSoftwareVerification--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Authentication of consumers' page

  Scenario: Authentication of consumers
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Authentication of consumers'
    Then I should be on the 'Authentication of consumers' page

    When I choose 'Yes' for 'userAuthenticateManagement'
    And I choose 'service provider assertion' for 'userAuthenticateManagement--assurance'
    And I choose 'Yes' for 'userAuthenticateSupport'
    And I choose 'service provider assertion' for 'userAuthenticateSupport--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation and access control within management interfaces' page

  Scenario: Separation and access control within management interfaces
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Separation and access control within management interfaces'
    Then I should be on the 'Separation and access control within management interfaces' page

    When I choose 'Yes' for 'userAccessControlManagement'
    And I choose 'service provider assertion' for 'userAccessControlManagement--assurance'
    And I choose 'Yes' for 'restrictAdministratorPermissions'
    And I choose 'service provider assertion' for 'restrictAdministratorPermissions--assurance'
    And I choose 'Yes' for 'managementInterfaceProtection'
    And I choose 'service provider assertion' for 'managementInterfaceProtection--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Identity and authentication' page

  Scenario: Identity and authentication
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Identity and authentication'
    Then I should be on the 'Identity and authentication' page

    When I 'check' 'Username and two-factor authentication' for 'identityAuthenticationControls'
    And I choose 'service provider assertion' for 'identityAuthenticationControls--assurance'
    And I click 'Save and continue'
    Then I should be on the 'External interface protection' page

  Scenario: External interface protection
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'External interface protection'
    Then I should be on the 'External interface protection' page

    When I choose 'Yes' for 'onboardingGuidance'
    And I choose 'service provider assertion' for 'onboardingGuidance--assurance'
    And I 'check' 'PSN assured service' for 'interconnectionMethods'
    And I choose 'service provider assertion' for 'interconnectionMethods--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure service administration' page

  Scenario: Secure service administration
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Secure service administration'
    Then I should be on the 'Secure service administration' page

    When I 'check' 'Dedicated devices on a segregated network' for 'serviceManagementModel'
    And I choose 'service provider assertion' for 'serviceManagementModel--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Audit information provision to consumers' page

  Scenario: Audit information provision to consumers
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Audit information provision to consumers'
    Then I should be on the 'Audit information provision to consumers' page

    When I choose 'None' for 'auditInformationProvided'
    And I choose 'service provider assertion' for 'auditInformationProvided--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure use of the service by the customer' page

  Scenario: Secure use of the service by the customer
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Secure use of the service by the customer'
    Then I should be on the 'Secure use of the service by the customer' page

    When I 'check' 'Corporate/enterprise devices' for 'deviceAccessMethod'
    And I choose 'service provider assertion' for 'deviceAccessMethod--assurance'
    And I choose 'Yes' for 'serviceConfigurationGuidance'
    And I choose 'service provider assertion' for 'serviceConfigurationGuidance--assurance'
    And I choose 'Yes' for 'trainingProvided'
    And I choose 'service provider assertion' for 'trainingProvided--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page

  Scenario: Service definition
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Service definition'
    Then I should be on the 'Service definition' page

    When I choose file 'test.pdf' for 'serviceDefinitionDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions document' page

  Scenario: Terms and conditions document
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Terms and conditions document'
    Then I should be on the 'Terms and conditions document' page

    When I choose file 'test.pdf' for 'termsAndConditionsDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Pricing document' page

  Scenario: Pricing document
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'Pricing document'
    Then I should be on the 'Pricing document' page

    When I choose file 'test.pdf' for 'pricingDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'SFIA rate card' page

  Scenario: SFIA rate card document
    Given I am on the ssp page for the 'iaas' service
    When I click the 'Edit' link for 'SFIA rate card'
    Then I should be on the 'SFIA rate card' page

    When I choose file 'test.pdf' for 'sfiaRateDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'My IaaS service' page

  Scenario: Mark as complete
    Given I am on the summary page
    Then The string 'Answer required' should not be on the page
    And The 'Mark as complete' button should be on the page
    
  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary table row 'Service type' under the heading 'Service attributes' should contain 'Infrastructure as a Service'
    And Summary table row 'Service name' under the heading 'Service name' should contain 'My IaaS service'
    And Summary table row 'Service summary' under the heading 'Service description' should contain 'My IaaS service that does stuff with stuff.'
    And Summary table row 'Choose the categories that apply to your service' under the heading 'Service type' should contain 'Compute'
    And Summary table row 'Service features' under the heading 'Features and benefits' should contain 'Super greatness'
    And Summary table row 'Service benefits' under the heading 'Features and benefits' should contain 'Great superness'
    And Summary table row 'Service price' under the heading 'Pricing' should contain '£100 to £1000 per unit per second'
    And Summary table row 'VAT included' under the heading 'Pricing' should contain 'Yes'
    And Summary table row 'Education pricing' under the heading 'Pricing' should contain 'No'
    And Summary table row 'Trial option' under the heading 'Pricing' should contain 'Yes'
    And Summary table row 'Free option' under the heading 'Pricing' should contain 'No'
    And Summary table row 'Termination cost' under the heading 'Terms and conditions' should contain 'No'
    And Summary table row 'Minimum contract period' under the heading 'Terms and conditions' should contain 'Month'
    And Summary table row 'Support service type' under the heading 'Support' should contain 'Service desk'
    And Summary table row 'Support accessible to any third-party suppliers' under the heading 'Support' should contain 'Yes'
    And Summary table row 'Support availability' under the heading 'Support' should contain '24/7'
    And Summary table row 'Standard support response times' under the heading 'Support' should contain '1 hour'
    And Summary table row 'Incident escalation process available' under the heading 'Support' should contain 'No'
    And Summary table row 'Open standards supported and documented' under the heading 'Open standards' should contain 'Yes'
    And Summary table row 'Service onboarding process included' under the heading 'Onboarding and offboarding' should contain 'No'
    And Summary table row 'Service offboarding process included' under the heading 'Onboarding and offboarding' should contain 'Yes'
    And Summary table row 'Real-time management information available' under the heading 'Analytics' should contain 'No'
    And Summary table row 'Elastic cloud approach supported' under the heading 'Cloud features' should contain 'Yes'
    And Summary table row 'Guaranteed resources defined' under the heading 'Cloud features' should contain 'No'
    And Summary table row 'Persistent storage supported' under the heading 'Cloud features' should contain 'No'
    And Summary table row 'Self-service provisioning supported' under the heading 'Provisioning' should contain 'Yes'
    And Summary table row 'Service provisioning time' under the heading 'Provisioning' should contain '5 hours'
    And Summary table row 'Service deprovisioning time' under the heading 'Provisioning' should contain '6 hours'
    And Summary table row 'Open-source software used and supported' under the heading 'Open source' should contain 'Yes'
    And Summary table row 'API access available and supported' under the heading 'API access' should contain 'Yes'
    And Summary table row 'API type' under the heading 'API access' should contain 'JSON'
    And Summary table row 'Networks the service is directly connected to' under the heading 'Networks and connectivity' should contain 'Internet'
    And Summary table row 'Supported web browsers' under the heading 'Access' should contain 'Opera'
    And Summary table row 'Offline working and syncing supported' under the heading 'Access' should contain 'Yes'
    And Summary table row 'Supported devices' under the heading 'Access' should contain 'PC'
    And Summary table row 'Vendor certification(s)' under the heading 'Certifications' should contain 'Stuff magic'
    And Summary table row 'Datacentres adhere to the EU code of conduct for energy-efficient datacentres' under the heading 'Data storage' should contain 'No'
    And Summary table row 'User-defined data location' under the heading 'Data storage' should contain 'Yes'
    And Summary table row 'Datacentre tier' under the heading 'Data storage' should contain 'Uptime Institute Tier 1'
    And Summary table row 'Backup, disaster recovery and resilience plan in place' under the heading 'Data storage' should contain 'Yes'
    And Summary table row 'Data extraction/removal plan in place' under the heading 'Data storage' should contain 'Yes'
    And Summary table row 'Data protection between user device and service' under the heading 'Data-in-transit protection' should contain 'PSN assured service, assured by Independent validation of assertion'
    And Summary table row 'Data protection within service' under the heading 'Data-in-transit protection' should contain 'VLAN, assured by Independent validation of assertion'
    And Summary table row 'Data protection between services' under the heading 'Data-in-transit protection' should contain 'PSN assured service, assured by CESG-assured components'
    And Summary table row 'Datacentre location' under the heading 'Asset protection and resilience' should contain 'UK'
    And Summary table row 'Data management location' under the heading 'Asset protection and resilience' should contain 'UK'
    And Summary table row 'Legal jurisdiction of service provider' under the heading 'Asset protection and resilience' should contain 'UK'
    And Summary table row 'Datacentre protection' under the heading 'Asset protection and resilience' should contain 'Yes'
    And Summary table row 'Data-at-rest protection' under the heading 'Asset protection and resilience' should contain 'CPA Foundation-grade assured components'
    And Summary table row 'Secure data deletion' under the heading 'Asset protection and resilience' should contain 'CESG or CPNI-approved erasure process'
    And Summary table row 'Storage media disposal' under the heading 'Asset protection and resilience' should contain 'CESG-assured destruction service (CAS(T))'
    And Summary table row 'Secure equipment disposal' under the heading 'Asset protection and resilience' should contain 'Yes'
    And Summary table row 'Redundant equipment accounts revoked' under the heading 'Asset protection and resilience' should contain 'No'
    And Summary table row 'Service availability' under the heading 'Asset protection and resilience' should contain '99.99%'
    And Summary table row 'Cloud deployment model' under the heading 'Separation between consumers' should contain 'Public cloud'
    And Summary table row 'Type of consumer' under the heading 'Separation between consumers' should contain 'No other consumer'
    And Summary table row 'Services separation' under the heading 'Separation between consumers' should contain 'Yes'
    And Summary table row 'Services management separation' under the heading 'Separation between consumers' should contain 'Yes'
    And Summary table row 'Governance framework' under the heading 'Governance' should contain 'Yes'
    And Summary table row 'Configuration and change management tracking' under the heading 'Configuration and change management' should contain 'Yes'
    And Summary table row 'Change impact assessment' under the heading 'Configuration and change management' should contain 'Yes'
    And Summary table row 'Vulnerability assessment' under the heading 'Vulnerability management' should contain 'Yes'
    And Summary table row 'Vulnerability monitoring' under the heading 'Vulnerability management' should contain 'Yes'
    And Summary table row 'Vulnerability mitigation prioritisation' under the heading 'Vulnerability management' should contain 'No'
    And Summary table row 'Vulnerability tracking' under the heading 'Vulnerability management' should contain 'Yes'
    And Summary table row 'Vulnerability mitigation timescales' under the heading 'Vulnerability management' should contain 'Yes'
    And Summary table row 'Event monitoring' under the heading 'Event monitoring' should contain 'Yes'
    And Summary table row 'Incident management processes' under the heading 'Incident management' should contain 'Yes'
    And Summary table row 'Consumer reporting of security incidents' under the heading 'Incident management' should contain 'No'
    And Summary table row 'Security incident definition published' under the heading 'Incident management' should contain 'Yes'
    And Summary table row 'Personnel security checks' under the heading 'Personnel security' should contain 'Security clearance national vetting (SC)'
    And Summary table row 'Secure development' under the heading 'Secure development' should contain 'Yes'
    And Summary table row 'Secure design, coding, testing and deployment' under the heading 'Secure development' should contain 'Yes'
    And Summary table row 'Software configuration management' under the heading 'Secure development' should contain 'Yes'
    And Summary table row 'Visibility of data shared with third-party suppliers' under the heading 'Supply-chain security' should contain 'Yes'
    And Summary table row 'Third-party supplier security requirements' under the heading 'Supply-chain security' should contain 'Yes'
    And Summary table row 'Third-party supplier risk assessment' under the heading 'Supply-chain security' should contain 'Yes'
    And Summary table row 'Third-party supplier compliance monitoring' under the heading 'Supply-chain security' should contain 'Yes'
    And Summary table row 'Hardware and software verification' under the heading 'Supply-chain security' should contain 'Yes'
    And Summary table row 'User authentication and access management' under the heading 'Authentication of consumers' should contain 'Yes'
    And Summary table row 'User access control through support channels' under the heading 'Authentication of consumers' should contain 'Yes'
    And Summary table row 'User access control within management interfaces' under the heading 'Separation and access control within management interfaces' should contain 'Yes'
    And Summary table row 'Administrator permissions' under the heading 'Separation and access control within management interfaces' should contain 'Yes'
    And Summary table row 'Management interface protection' under the heading 'Separation and access control within management interfaces' should contain 'Yes'
    And Summary table row 'Identity and authentication controls' under the heading 'Identity and authentication' should contain 'Username and two-factor authentication'
    And Summary table row 'Onboarding guidance provided' under the heading 'External interface protection' should contain 'Yes'
    And Summary table row 'Interconnection method provided' under the heading 'External interface protection' should contain 'PSN assured service'
    And Summary table row 'Service management model' under the heading 'Secure service administration' should contain 'Dedicated devices on a segregated network'
    And Summary table row 'Audit information provided' under the heading 'Audit information provision to consumers' should contain 'None'
    And Summary table row 'Device access method' under the heading 'Secure use of the service by the customer' should contain 'Corporate/enterprise devices'
    And Summary table row 'Service configuration guidance' under the heading 'Secure use of the service by the customer' should contain 'Yes'
    And Summary table row 'Training' under the heading 'Secure use of the service by the customer' should contain 'Yes'
    And Summary row 'Service definition document' should not contain 'Answer required'
    And Summary row 'Terms and conditions document' should not contain 'Answer required'
    And Summary row 'Pricing document' should not contain 'Answer required'
    And Summary row 'Skills Framework for the Information Age (SFIA) rate card' under 'SFIA rate card' should not be empty

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete'
    And I click 'Yes, delete'
    Then I am returned to the 'Infrastructure as a Service services' page
    And My service should not be in the list

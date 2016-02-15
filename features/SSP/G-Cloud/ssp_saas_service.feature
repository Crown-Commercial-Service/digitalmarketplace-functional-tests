@not-production @functional-test @ssp-gcloud
Feature: Submitting a new service for SaaS
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Digital Marketplace' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select lot
    Given I am at '/suppliers'
    When I click 'Continue your G-Cloud 7 application'
    And I click 'Add, edit and complete services'

    When I click 'Software as a Service (SaaS)'
    And I click 'Add a service'
    Then I am taken to the 'Service name' page

  Scenario: Provide a service name
    Given I am on the service name page for 'saas'
    When I fill in 'serviceName' with 'My SaaS'
    And I click 'Save and continue'
    Then I should be on the 'My SaaS' page

  Scenario: Edit a service name
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Service name'
    Then I should be on the 'Service name' page

    When I fill in 'serviceName' with 'My SaaS service'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page

  Scenario: Provide a service description
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Service description'
    Then I should be on the 'Service description' page

    When I fill in 'serviceSummary' with:
      """
      It's very SaaSy.
      """
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Select a service type
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Service type'
    Then I should be on the 'Service type' page

    When I check 'Creative and design' for 'serviceTypes'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Features and benefits
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Features and benefits'
    Then I should be on the 'Features and benefits' page

    When I fill in 'input-serviceFeatures-1' with 'Great superness'
    And I fill in 'input-serviceBenefits-1' with 'Super greatness'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page

  Scenario: Pricing
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Pricing'
    Then I should be on the 'Pricing' page

    When I fill in 'priceMin' with '99'
    And I fill in 'priceMax' with '100'
    And I select 'Unit' from 'priceUnit'
    And I select 'Second' from 'priceInterval'
    And I choose 'No' for 'vatIncluded'
    And I choose 'Yes' for 'educationPricing'
    And I choose 'Yes' for 'trialOption'
    And I choose 'No' for 'freeOption'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page

  Scenario: Terms and conditions
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Terms and conditions'
    Then I should be on the 'Terms and conditions' page

    When I choose 'Month' for 'minimumContractPeriod'
    And I click 'Save and continue'
    Then I should be on the 'Support' page

  Scenario: Support
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Support'
    Then I should be on the 'Support' page

    When I check 'Service desk' for 'supportTypes'
    And I choose 'Yes' for 'supportForThirdParties'
    And I fill in 'supportAvailability' with '24/7'
    And I fill in 'supportResponseTime' with '1 hour'
    And I choose 'No' for 'incidentEscalation'
    And I click 'Save and continue'
    Then I should be on the 'Open standards' page

  Scenario: Open standards
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Open standards'
    Then I should be on the 'Open standards' page

    When I choose 'Yes' for 'openStandardsSupported'
    And I click 'Save and continue'
    Then I should be on the 'Onboarding and offboarding' page

  Scenario: Onboarding and offboarding
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Onboarding and offboarding'
    Then I should be on the 'Onboarding and offboarding' page

    When I choose 'No' for 'serviceOnboarding'
    And I choose 'Yes' for 'serviceOffboarding'
    And I click 'Save and continue'
    Then I should be on the 'Analytics' page

  Scenario: Analytics
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Analytics'
    Then I should be on the 'Analytics' page

    When I choose 'No' for 'analyticsAvailable'
    And I click 'Save and continue'
    Then I should be on the 'Cloud features' page

  Scenario: Cloud features
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Cloud features'
    Then I should be on the 'Cloud features' page

    When I choose 'Yes' for 'elasticCloud'
    And I choose 'No' for 'guaranteedResources'
    And I choose 'No' for 'persistentStorage'
    And I click 'Save and continue'
    Then I should be on the 'Provisioning' page

  Scenario: Provisioning
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Provisioning'
    Then I should be on the 'Provisioning' page

    When I choose 'Yes' for 'selfServiceProvisioning'
    And I fill in 'provisioningTime' with '5 hours'
    And I fill in 'deprovisioningTime' with '6 hours'
    And I click 'Save and continue'
    Then I should be on the 'Open source' page

  Scenario: Open source
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Open source'
    Then I should be on the 'Open source' page

    When I choose 'Yes' for 'openSource'
    And I click 'Save and continue'
    Then I should be on the 'Code libraries' page

  Scenario: Code libraries
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Code libraries'
    Then I should be on the 'Code libraries' page

    When I fill in 'input-codeLibraryLanguages-1' with 'XSLT'
    And I click 'Save and continue'
    Then I should be on the 'API access' page

  Scenario: API access
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'API access'
    Then I should be on the 'API access' page

    When I choose 'Yes' for 'apiAccess'
    And I fill in 'apiType' with 'XML'
    And I click 'Save and continue'
    Then I should be on the 'Networks and connectivity' page

  Scenario: Networks and connectivity
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Networks and connectivity'
    Then I should be on the 'Networks and connectivity' page

    When I check 'Internet' for 'networksConnected'
    And I click 'Save and continue'
    Then I should be on the 'Access' page

  Scenario: Access
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Access'
    Then I should be on the 'Access' page

    When I check 'Opera' for 'supportedBrowsers'
    And I choose 'Yes' for 'offlineWorking'
    And I check 'PC' for 'supportedDevices'
    And I click 'Save and continue'
    Then I should be on the 'Certifications' page

  Scenario: Certifications
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Certifications'
    Then I should be on the 'Certifications' page

    When I fill in 'input-vendorCertifications-1' with 'Stuff magic'
    And I click 'Save and continue'
    Then I should be on the 'Identity standards' page

  Scenario: Identity standards
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Identity standards'
    Then I should be on the 'Identity standards' page

    When I fill in 'input-identityStandards-1' with 'OAuth'
    And I click 'Save and continue'
    Then I should be on the 'Data storage' page

  Scenario: Data storage
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Data storage'
    Then I should be on the 'Data storage' page

    When I choose 'No' for 'datacentresEUCode'
    And I choose 'Yes' for 'datacentresSpecifyLocation'
    And I choose 'Uptime Institute Tier 1' for 'datacentreTier'
    And I choose 'Yes' for 'dataBackupRecovery'
    And I choose 'Yes' for 'dataExtractionRemoval'
    And I click 'Save and continue'
    Then I should be on the 'Data-in-transit protection' page

  @listing_page
  Scenario: Go to listing page and the service is not complete
    Given I am at the 'Software as a Service services' page
    Then My service should be in the list

    When I click 'My SaaS service'
    Then I should be on the 'My SaaS service' page
    And The string 'Answer required' should be on the page
    And The 'Mark as complete' button should not be on the page

  Scenario: Data-in-transit protection
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Data-in-transit protection'
    Then I should be on the 'Data-in-transit protection' page

    When I check 'Encrypted PSN service' for 'dataProtectionBetweenUserAndService'
    And I choose 'independent validation of assertion' for 'dataProtectionBetweenUserAndService--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Asset protection and resilience' page

  Scenario: Asset protection and resilience
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Asset protection and resilience'
    Then I should be on the 'Asset protection and resilience' page

    When I check 'input-datacentreLocations-1' for 'datacentreLocations'
    And I choose 'service provider assertion' for 'datacentreLocations--assurance'
    And I check 'input-dataManagementLocations-1' for 'dataManagementLocations'
    And I choose 'service provider assertion' for 'dataManagementLocations--assurance'
    And I choose 'UK' for 'legalJurisdiction'
    And I choose 'service provider assertion' for 'legalJurisdiction--assurance'
    And I choose 'Yes' for 'datacentreProtectionDisclosure'
    And I choose 'service provider assertion' for 'datacentreProtectionDisclosure--assurance'
    And I check 'input-dataAtRestProtections-2' for 'dataAtRestProtections'
    And I choose 'service provider assertion' for 'dataAtRestProtections--assurance'
    And I choose 'CESG or CPNI-approved erasure process' for 'dataSecureDeletion'
    And I choose 'service provider assertion' for 'dataSecureDeletion--assurance'
    And I fill in 'serviceAvailabilityPercentage' with '99'
    And I choose 'service provider assertion' for 'serviceAvailabilityPercentage--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation between consumers' page

  Scenario: Separation between consumers
    Given I am on ssp page 'saas'
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
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Governance'
    Then I should be on the 'Governance' page

    When I choose 'Yes' for 'governanceFramework'
    And I choose 'service provider assertion' for 'governanceFramework--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Configuration and change management' page

  Scenario: Configuration and change management
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Configuration and change management'
    Then I should be on the 'Configuration and change management' page

    When I choose 'Yes' for 'changeImpactAssessment'
    And I choose 'service provider assertion' for 'changeImpactAssessment--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Vulnerability management' page

  Scenario: Vulnerability management
    Given I am on ssp page 'saas'
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
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Event monitoring'
    Then I should be on the 'Event monitoring' page

    When I choose 'Yes' for 'eventMonitoring'
    And I choose 'service provider assertion' for 'eventMonitoring--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Incident management' page

  Scenario: Incident management
    Given I am on ssp page 'saas'
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

  Scenario: Personnel security
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Personnel security'
    Then I should be on the 'Personnel security' page

    When I check 'Security clearance national vetting (SC)' for 'personnelSecurityChecks'
    And I choose 'service provider assertion' for 'personnelSecurityChecks--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure development' page

  Scenario: Secure development
    Given I am on ssp page 'saas'
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
    Given I am on ssp page 'saas'
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
    And I click 'Save and continue'
    Then I should be on the 'Authentication of consumers' page

  Scenario: Authentication of consumers
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Authentication of consumers'
    Then I should be on the 'Authentication of consumers' page

    When I choose 'Yes' for 'userAuthenticateManagement'
    And I choose 'service provider assertion' for 'userAuthenticateManagement--assurance'
    And I choose 'Yes' for 'userAuthenticateSupport'
    And I choose 'service provider assertion' for 'userAuthenticateSupport--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Separation and access control within management interfaces' page

  Scenario: Separation and access control within management interfaces
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Separation and access control within management interfaces'
    Then I should be on the 'Separation and access control within management interfaces' page

    When I choose 'Yes' for 'userAccessControlManagement'
    And I choose 'service provider assertion' for 'userAccessControlManagement--assurance'
    And I choose 'Yes' for 'restrictAdministratorPermissions'
    And I choose 'service provider assertion' for 'restrictAdministratorPermissions--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Identity and authentication' page

  Scenario: Identity and authentication
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Identity and authentication'
    Then I should be on the 'Identity and authentication' page

    When I check 'Username and two-factor authentication' for 'identityAuthenticationControls'
    And I choose 'service provider assertion' for 'identityAuthenticationControls--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure service administration' page

  Scenario: Secure service administration
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Secure service administration'
    Then I should be on the 'Secure service administration' page

    When I check 'Dedicated devices on a segregated network' for 'serviceManagementModel'
    And I choose 'service provider assertion' for 'serviceManagementModel--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Audit information provision to consumers' page

  Scenario: Audit information provision to consumers
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Audit information provision to consumers'
    Then I should be on the 'Audit information provision to consumers' page

    When I choose 'None' for 'auditInformationProvided'
    And I choose 'service provider assertion' for 'auditInformationProvided--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Secure use of the service by the customer' page

  Scenario: Secure use of the service by the customer
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Secure use of the service by the customer'
    Then I should be on the 'Secure use of the service by the customer' page

    When I check 'Corporate/enterprise devices' for 'deviceAccessMethod'
    And I choose 'service provider assertion' for 'deviceAccessMethod--assurance'
    And I choose 'Yes' for 'trainingProvided'
    And I choose 'service provider assertion' for 'trainingProvided--assurance'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page

  Scenario: Service definition
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Service definition'
    Then I should be on the 'Service definition' page

    When I choose file 'test.pdf' for 'serviceDefinitionDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions document' page

  Scenario: Terms and conditions document
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Terms and conditions document'
    Then I should be on the 'Terms and conditions document' page

    When I choose file 'test.pdf' for 'termsAndConditionsDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'Pricing document' page

  Scenario: Pricing document
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'Pricing document'
    Then I should be on the 'Pricing document' page

    When I choose file 'test.pdf' for 'pricingDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'SFIA rate card' page

  Scenario: SFIA rate card
    Given I am on ssp page 'saas'
    When I click the 'Edit' link for 'SFIA rate card'
    Then I should be on the 'SFIA rate card' page

    When I choose file 'test.pdf' for 'sfiaRateDocumentURL'
    And I click 'Save and continue'
    Then I should be on the 'My SaaS service' page

  Scenario: Mark as complete
    Given I am on the summary page
    Then The string 'Answer required' should not be on the page
    And The 'Mark as complete' button should be on the page

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “My SaaS service”'
    Then I am returned to the 'Software as a Service services' page
    And My service should not be in the list

# encoding: utf-8
require "rubygems"
require "rest_client"
require "json"
require "test/unit"


SUPPLIERS_JSON = '
{
   "suppliers":
      {
         "id":11111,
         "name":"DM Functional Test Supplier",
         "description":"This is a test supplier, which will be used solely for the purpose of running functional test.",
         "contactInformation": [
             {
               "website": "www.dmfunctionaltestsupplier.com",
               "contactName": "Testing Supplier Name",
               "email": "Testing.supplier.NaMe@DMtestemail.com",
               "phoneNumber": "+44 (0) 123456789",
               "address1": "125 Kingsway",
               "city": "London",
               "country": "United Kingdom",
               "postcode": "WC2B 6NH"
             }
           ],
         "dunsNumber":"930123456789"
      }
}
'

USERS_JSON = '
{
    "users":
      {
          "name": "Testing.supplier.USERNaMe@DMtestemail.com",
          "password": "testuserpassword",
          "emailAddress": "Testing.supplier.USERNaMe@DMtestemail.com",
          "supplierId": 11111,
          "role": "supplier"
      }
}
'

SERVICES_JSON = '
{
   "update_details": {
      "updated_by": "Test User",
      "update_reason": "For testing"},
   "services": {
      "id":"1122334455667788",
      "supplierId":11111,
      "lot":"IaaS",
      "title":"DM Functional Test Use",
      "lastUpdated":"2014-12-12T08:45:42Z",
      "lastUpdatedByEmail":"Testing.supplier.NaMe@DMtestemail.com",
      "lastCompleted":"2014-12-16T20:49:50Z",
      "lastCompletedByEmail":"Testing.supplier.NaMe@DMtestemail.com",
      "serviceTypes":[
         "Compute"
      ],
      "serviceBenefits":[
         "First service benefit. Testing use only",
         "2nd service benefit",
         "Third service benefit"
      ],
      "serviceFeatures":[
         "First service feature. Testing use only",
         "2nd service feature",
         "Third service feature",
         "4th service feature",
         "Fifth service feature",
         "6th service feature. Testing use only",
         "Seventh service feature",
         "8th service feature",
         "Ninth service feature"
      ],
      "serviceDefinitionDocument":"Basic Managed VM IaaS Service Description.pdf",
      "serviceDefinitionDocumentURL":"https:\/\/assets.digitalmarketplace.service.gov.uk\/documents\/11111\/1122334455667788-service-definition-document.pdf",
      "termsAndConditionsDocument":"T&Cs.pdf",
      "minimumContractPeriod":"Hour",
      "terminationCost":false,
      "termsAndConditionsDocumentURL":"https:\/\/assets.digitalmarketplace.service.gov.uk\/documents\/11111\/1122334455667788-terms-and-conditions.pdf",
      "priceInterval":"Month",
      "trialOption":false,
      "priceUnit":"Virtual machine",
      "educationPricing":true,
      "vatIncluded":true,
      "priceString":"\u00a3220 per virtual machine per month",
      "sfiaRateDocument":"Digital SFIA Rate Card.pdf",
      "pricingDocument":"Pricing Guide.pdf",
      "priceMin":220,
      "freeOption":true,
      "sfiaRateDocumentURL":"https:\/\/assets.digitalmarketplace.service.gov.uk\/documents\/11111\/1122334455667788-sfia-rate-card.pdf",
      "pricingDocumentURL":"https:\/\/assets.digitalmarketplace.service.gov.uk\/documents\/11111\/1122334455667788-pricing-document.pdf",
      "openStandardsSupported":true,
      "supportForThirdParties":true,
      "supportAvailability":"DM Functional Test Supplier provide 24\/7 support for Priority 1 incidents and 12\/5 support for non Priority 1 incidents",
      "supportResponseTime":"DM Functional Test Supplier provide response times from 15 minutes depending on the priority\/severity of the incident or request.",
      "incidentEscalation":true,
      "supportTypes":[
         "Service desk",
         "Email",
         "Phone"
      ],
      "serviceOffboarding":true,
      "serviceOnboarding":true,
      "analyticsAvailable":true,
      "persistentStorage":true,
      "elasticCloud":true,
      "guaranteedResources":true,
      "selfServiceProvisioning":true,
      "provisioningTime":"1 month",
      "deprovisioningTime":"1 month",
      "openSource":true,
      "apiType":"RESTful ",
      "apiAccess":true,
      "networksConnected":[
         "Internet",
         "Public Services Network (PSN)",
         "Government Secure intranet (GSi)",
         "Police National Network (PNN)",
         "New NHS Network (N3)",
         "Other"
      ],
      "supportedDevices":[
         "PC",
         "Mac",
         "Smartphone",
         "Tablet"
      ],
      "offlineWorking":true,
      "supportedBrowsers":[
         "Internet Explorer 6",
         "Internet Explorer 7",
         "Internet Explorer 8",
         "Internet Explorer 9",
         "Internet Explorer 10+",
         "Firefox",
         "Chrome",
         "Safari",
         "Opera"
      ],
      "vendorCertifications":[
         "ISO20000 (IT Service Management)\t\t\t\t\t\t\t",
         "ISO9000 (Quality)",
         "ISO27000 (Information Security)",
         "Cloud Security Alliance",
         "Cyber Essentials Plus",
         "VMware vCloud Powered",
         "VMware Certified Professionals",
         "Microsoft Service Provider License Agreement (SPLA)",
         "RedHat Certified Cloud Provider (RCCP)\t",
         "Cisco Managed Service & Cloud Providers"
      ],
      "dataExtractionRemoval":true,
      "dataBackupRecovery":true,
      "datacentreTier":"TIA-942 Tier 3",
      "datacentresSpecifyLocation":true,
      "datacentresEUCode":true,
      "dataProtectionBetweenServices":{
         "value":[
            "Encrypted PSN service"
         ],
         "assurance":"Independent testing of implementation"
      },
      "dataProtectionWithinService":{
         "value":[
            "Other network protection"
         ],
         "assurance":"CESG-assured components"
      },
      "dataProtectionBetweenUserAndService":{
         "value":[
            "Encrypted PSN service"
         ],
         "assurance":"Independent testing of implementation"
      },
      "dataRedundantEquipmentAccountsRevoked":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "dataSecureEquipmentDisposal":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "dataStorageMediaDisposal":{
         "value":"CPNI-approved destruction service",
         "assurance":"CESG-assured components"
      },
      "dataSecureDeletion":{
         "value":"Other secure erasure process",
         "assurance":"Independent testing of implementation"
      },
      "dataAtRestProtections":{
         "value":[
            "Physical access control"
         ],
         "assurance":"Independent validation of assertion"
      },
      "datacentreProtectionDisclosure":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "legalJurisdiction":{
         "value":"UK",
         "assurance":"Independent validation of assertion"
      },
      "serviceAvailabilityPercentage":{
         "value":99.5,
         "assurance":"Independent validation of assertion"
      },
      "dataManagementLocations":{
         "value":[
            "UK"
         ],
         "assurance":"Independent validation of assertion"
      },
      "datacentreLocations":{
         "value":[
            "UK"
         ],
         "assurance":"Independent validation of assertion"
      },
      "otherConsumers":{
         "value":"Only government consumers",
         "assurance":"Independent validation of assertion"
      },
      "servicesSeparation":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "servicesManagementSeparation":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "cloudDeploymentModel":{
         "value":"Community cloud",
         "assurance":"Independent validation of assertion"
      },
      "governanceFramework":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "configurationTracking":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "changeImpactAssessment":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "vulnerabilityAssessment":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "vulnerabilityMonitoring":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "vulnerabilityTimescales":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "vulnerabilityMitigationPrioritisation":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "vulnerabilityTracking":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "eventMonitoring":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "incidentDefinitionPublished":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "incidentManagementReporting":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "incidentManagementProcess":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "personnelSecurityChecks":{
         "value":[
            "Security clearance national vetting (SC)",
            "Baseline personnel security standard (BPSS)",
            "Background checks in accordance with BS7858:2012",
            "Employment checks"
         ],
         "assurance":"Independent validation of assertion"
      },
      "secureDesign":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "secureConfigurationManagement":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "secureDevelopment":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "hardwareSoftwareVerification":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "thirdPartyRiskAssessment":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "thirdPartyComplianceMonitoring":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "thirdPartyDataSharingInformation":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "thirdPartySecurityRequirements":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "userAuthenticateSupport":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "userAuthenticateManagement":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "managementInterfaceProtection":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "restrictAdministratorPermissions":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "userAccessControlManagement":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "identityAuthenticationControls":{
         "value":[
            "Username and two-factor authentication"
         ],
         "assurance":"Independent testing of implementation"
      },
      "interconnectionMethods":{
         "value":[
            "Encrypted PSN service",
            "PSN service",
            "Private WAN"
         ],
         "assurance":"Independent validation of assertion"
      },
      "onboardingGuidance":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "serviceManagementModel":{
         "value":[
            "Dedicated devices on a segregated network"
         ],
         "assurance":"Independent validation of assertion"
      },
      "auditInformationProvided":{
         "value":"Data made available by negotiation",
         "assurance":"Independent validation of assertion"
      },
      "serviceConfigurationGuidance":{
         "value":true,
         "assurance":"Independent testing of implementation"
      },
      "deviceAccessMethod":{
         "value":[
            "Corporate\/enterprise devices"
         ],
         "assurance":"Independent validation of assertion"
      },
      "trainingProvided":{
         "value":true,
         "assurance":"Independent validation of assertion"
      },
      "serviceName":"DM Functional Test Service Name",
      "serviceSummary":"This is the summary created for a fictional listing which will be used solely for the purpose of functional testing"
   }
}
'

Given /^I have a test supplier$/ do
    url = dm_api_domain
    token = dm_api_access_token
    response = RestClient.put(url + "/suppliers/11111", SUPPLIERS_JSON,
                              {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
                              ){|response, request, result| response }  # Don't raise exceptions but return the response
    response.code.should == 201
end


Given /^The test supplier has a service$/ do
    create_service("1122334455667788")
end

And /^The test supplier has a user$/ do
  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  users_data = JSON.parse(USERS_JSON)
  email = users_data ["users"]["emailAddress"]
  user_url = "#{url}/users?email=#{email}"

  response = RestClient.get(user_url, headers){|response, request, result| response }
  if response.code != 200
    user_url = "#{url}/users"
    response = RestClient.post(user_url, USERS_JSON, headers){|response, request, result| response }
    response.code.should == 200
  end
end

Given /^The test supplier has multiple services$/ do
    create_service("1122334455667788")
    create_service("1122334455667789")
end

def create_service (service_id)
  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  service_url = "#{url}/services/#{service_id}"

  service_data = JSON.parse(SERVICES_JSON)
  service_data ["services"]["id"] = service_id
  service_data ["services"]["serviceName"] = "#{service_data ["services"]["serviceName"]} #{service_id}"
  response = RestClient.get(service_url, headers){|response, request, result| response }
  if response.code == 404
    response = RestClient.put(service_url, service_data.to_json, headers){|response, request, result| response }
    response.code.should == 201
  else
    response = RestClient.post(service_url, service_data.to_json, headers){|response, request, result| response }
    response.code.should == 200
  end
end

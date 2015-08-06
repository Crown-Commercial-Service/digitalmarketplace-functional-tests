#################################################################################
#                                                                               #
# NOTE: THIS IS CURRENTLY JUST A COPY OF THE VALIDATION FEATURE FROM THE G6 SSP #
#                                                                               #
#################################################################################

@wip
Feature: Page validation

  Scenario: Select lot
    Given I am logged in as a 'supplier'
    And I am at '/addservice'
    When I choose 'Infrastructure as a Service (IaaS)'
    And I click 'Save and continue'
    Then I should be on the 'Service type' page

  Scenario: Service type - no data
    Given I am on ssp page '1'
    And I click 'Save and continue'
    Then I should be on the 'Service type' page
    And I get a summary error of 'Choose the categories that apply to your service' and an inline error of 'This question requires an answer.' for question 'p1q1'

  Scenario: Service description - no data
    Given I am on ssp page '4'
    And I click 'Save and continue'
    Then I should be on the 'Service description' page
    And I get a summary error of 'Service name' and an inline error of 'This question requires an answer.' for question 'p4q1'
    And I get a summary error of 'Service summary' and an inline error of 'This question requires an answer.' for question 'p4q2'

  Scenario: Provide a service description so we can delete it later
    Given I am on ssp page '4'
    When I fill in 'p4q1' with 'My IaaS service'
    And I fill in 'p4q2' with:
    """
    My service that does stuff with stuff.
    """
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page

  Scenario: Service description - too many characters
    Given I am on ssp page '4'
    When I fill in 'p4q1' with 'Way too many characters.Way too many characters.Way too many characters.Way too many characters.Way too many characters.'
    And I fill in 'p4q2' with:
    """
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    Way too many characters.Way too many characters.Way too many characters.Way too many characters.
    """
    And I click 'Save and continue'
    Then I should be on the 'Service description' page
    And I get a summary error of 'Service name' and an inline error of 'Your answer must be less than 100 characters in length.' for question 'p4q1'
    And I get a summary error of 'Service summary' and an inline error of 'Your answer must be less than 50 words.' for question 'p4q2'

  Scenario: Features and benefits - no data
    Given I am on ssp page '5'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page
    And I get a summary error of 'Service features' and an inline error of 'This question requires an answer.' for question 'p5q1'
    And I get a summary error of 'Service benefits' and an inline error of 'This question requires an answer.' for question 'p5q2'

  Scenario: Features and benefits - too many words
    Given I am on ssp page '5'
    When I fill in 'p5q1val1' with 'way too many characters way too many characters way too many characters'
    And I fill in 'p5q2val1' with 'way too many characters way too many characters way too many characters'
    And I click 'Save and continue'
    Then I should be on the 'Features and benefits' page
    And I get a summary error of 'Service features' and an inline error of 'Each feature must be less than 10 words.' for question 'p5q1'
    And I get a summary error of 'Service benefits' and an inline error of 'Each benefit must be less than 10 words.' for question 'p5q2'

  Scenario: Service definition - no data
    Given I am on ssp page '6'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page
    And I get a summary error of 'Service definition document' and an inline error of 'This question requires an answer.' for question 'p6q1'

  Scenario: Service definition - file size too large (greater than 5mb)
    Given I am on ssp page '6'
    When I choose file 'greater-than-5-mb.pdf' for 'p6q1'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page
    And I get a summary error of 'Service definition document' and an inline error of 'Your document exceeds the 5MB limit. Please reduce file size.' for question 'p6q1'

  Scenario: Service definition - unsupported file format
    Given I am on ssp page '6'
    When I choose file 'a-docx.docx' for 'p6q1'
    And I click 'Save and continue'
    Then I should be on the 'Service definition' page
    And I get a summary error of 'Service definition document' and an inline error of 'Your document is not in an open format. Please save as an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).' for question 'p6q1'

  Scenario: Terms and conditions - no data
    Given I am on ssp page '7'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page
    Then I get a summary error of 'Termination cost' and an inline error of 'This question requires an answer.' for question 'p7q1'
    And I get a summary error of 'Minimum contract period' and an inline error of 'This question requires an answer.' for question 'p7q2'
    And I get a summary error of 'Please upload your terms and conditions document' and an inline error of 'This question requires an answer.' for question 'p7q3'

  Scenario: Terms and conditions - file size too large
    Given I am on ssp page '7'
    And I choose file 'greater-than-5-mb.pdf' for 'p7q3'
    And I click 'Save and continue'
    Then I should be on the 'Terms and conditions' page
    And I get a summary error of 'Please upload your terms and conditions document' and an inline error of 'Your document exceeds the 5MB limit. Please reduce file size.' for question 'p7q3'

  Scenario: Pricing - no data
    Given I am on ssp page '8'
    When I click 'Save and continue'
    Then I should be on the 'Pricing' page
    And I get a summary error of 'Service price' and an inline error of 'Minimum price requires an answer.' for question 'p8q1'
    And I get a summary error of 'VAT included' and an inline error of 'This question requires an answer.' for question 'p8q2'
    And I get a summary error of 'Education pricing' and an inline error of 'This question requires an answer.' for question 'p8q3'
    And I get a summary error of 'Trial option' and an inline error of 'This question requires an answer.' for question 'p8q4'
    And I get a summary error of 'Free option' and an inline error of 'This question requires an answer.' for question 'p8q5'
    And I get a summary error of 'Pricing document' and an inline error of 'This question requires an answer.' for question 'p8q6'

  Scenario: Pricing - no data 2
    Given I am on ssp page '8'
    When I fill in 'p8q1MinPrice' with '100'
    And I choose 'p8q2-option-1'
    And I choose 'p8q3-option-1'
    And I choose 'p8q4-option-1'
    And I choose 'p8q5-option-1'
    And I choose file 'a-pdf.pdf' for 'p8q6'
    And I choose file 'a-pdf.pdf' for 'p8q7'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page
    And I get a summary error of 'Service price' and an inline error of 'Pricing unit requires an answer. If none of the provided units apply, please choose 'Unit'.' for question 'p8q1'

  Scenario: Pricing - unsupported file format
    Given I am on ssp page '8'
    And I choose file 'a-docx.docx' for 'p8q6'
    And I choose file 'a-docx.docx' for 'p8q7'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page
    And I get a summary error of 'Pricing document' and an inline error of 'Your document is not in an open format. Please save as an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).' for question 'p8q6'
    And I get a summary error of 'Skills Framework for the Information Age (SFIA) rate card' and an inline error of 'Your document is not in an open format. Please save as an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).' for question 'p8q7'

  Scenario: Pricing - file size too large (greater than 5mb)
    Given I am on ssp page '8'
    And I choose file 'greater-than-5-mb.pdf' for 'p8q6'
    And I choose file 'greater-than-5-mb.pdf' for 'p8q7'
    And I click 'Save and continue'
    Then I should be on the 'Pricing' page
    And I get a summary error of 'Pricing document' and an inline error of 'Your document exceeds the 5MB limit. Please reduce file size.' for question 'p8q6'
    And I get a summary error of 'Skills Framework for the Information Age (SFIA) rate card' and an inline error of 'Your document exceeds the 5MB limit. Please reduce file size.' for question 'p8q7'

  Scenario: Open standards - no data
    Given I am on ssp page '9'
    When I click 'Save and continue'
    Then I should be on the 'Open standards' page
    And I get a summary error of 'Open standards supported and documented' and an inline error of 'This question requires an answer.' for question 'p9q1'

  Scenario: Support - no data
    Given I am on ssp page '10'
    When I click 'Save and continue'
    Then I should be on the 'Support' page
    And I get a summary error of 'Support service type' and an inline error of 'This question requires an answer.' for question 'p10q1'
    And I get a summary error of 'Support accessible to any third-party suppliers' and an inline error of 'This question requires an answer.' for question 'p10q2'
    And I get a summary error of 'Support availablility' and an inline error of 'This question requires an answer.' for question 'p10q3'
    And I get a summary error of 'Standard support response times' and an inline error of 'This question requires an answer.' for question 'p10q4'
    And I get a summary error of 'Incident escalation process available' and an inline error of 'This question requires an answer.' for question 'p10q5'

  Scenario: Support - exceeds 20 words
    Given I am on ssp page '10'
    And I fill in 'p10q3' with:
     """
     Way too many characters.Way too many characters. Way too many characters.Way too many characters. Way too many characters.Way too many characters. Way too many characters. Way too many characters. Way too many characters.
     """
    And I fill in 'p10q4' with:
     """
     Way too many characters.Way too many characters. Way too many characters.Way too many characters. Way too many characters.Way too many characters. Way too many characters. Way too many characters. Way too many characters.
     """
    And I choose 'p10q5-option-1'
    And I click 'Save and continue'
    Then I should be on the 'Support' page
    And I get a summary error of 'Support availablility' and an inline error of 'Your answer must be less than 20 words.' for question 'p10q3'
    And I get a summary error of 'Standard support response times' and an inline error of 'Your answer must be less than 20 words.' for question 'p10q4'

  Scenario: Onboarding and offboarding - no data
    Given I am on ssp page '11'
    When I click 'Save and continue'
    Then I should be on the 'Onboarding and offboarding' page
    And I get a summary error of 'Service onboarding process included' and an inline error of 'This question requires an answer.' for question 'p11q1'
    And I get a summary error of 'Service offboarding process included' and an inline error of 'This question requires an answer.' for question 'p11q2'

  Scenario: Analytics - no data
    Given I am on ssp page '12'
    When I click 'Save and continue'
    Then I should be on the 'Analytics' page
    And I get a summary error of 'Real-time management information available' and an inline error of 'This question requires an answer.' for question 'p12q1'

  Scenario: Cloud features - no data
    Given I am on ssp page '13'
    When I click 'Save and continue'
    Then I should be on the 'Cloud features' page
    And I get a summary error of 'Elastic cloud approach supported' and an inline error of 'This question requires an answer.' for question 'p13q1'
    And I get a summary error of 'Guaranteed resources defined' and an inline error of 'This question requires an answer.' for question 'p13q2'
    And I get a summary error of 'Persistent storage supported' and an inline error of 'This question requires an answer.' for question 'p13q3'

  Scenario: Provisioning - no data
    Given I am on ssp page '14'
    When I click 'Save and continue'
    Then I should be on the 'Provisioning' page
    And I get a summary error of 'Self-service provisioning supported' and an inline error of 'This question requires an answer.' for question 'p14q1'
    And I get a summary error of 'Service provisioning time' and an inline error of 'This question requires an answer.' for question 'p14q2'
    And I get a summary error of 'Service deprovisioning time' and an inline error of 'This question requires an answer.' for question 'p14q3'

  Scenario: Open source - no data
    Given I am on ssp page '15'
    When I click 'Save and continue'
    Then I should be on the 'Open source' page
    And I get a summary error of 'Open-source software used and supported' and an inline error of 'This question requires an answer.' for question 'p15q1'

  Scenario: API access - no data
    Given I am on ssp page '17'
    When I click 'Save and continue'
    Then I should be on the 'API access' page
    And I get a summary error of 'API access available and supported' and an inline error of 'This question requires an answer.' for question 'p17q1'

  Scenario: API access - if yes type required
    Given I am on ssp page '17'
    When I choose 'p17q1-option-1'
    And I click 'Save and continue'
    Then I should be on the 'API access' page
    And I get a summary error of 'API type' and an inline error of 'This question requires an answer.' for question 'p17q2'

  Scenario: Networks and connectivity - no data
    Given I am on ssp page '18'
    When I click 'Save and continue'
    Then I should be on the 'Networks and connectivity' page
    And I get a summary error of 'Networks the service is directly connected to' and an inline error of 'This question requires an answer.' for question 'p18q1'

  Scenario: Access - no data
    Given I am on ssp page '19'
    When I click 'Save and continue'
    Then I should be on the 'Access' page
    And I get a summary error of 'Supported web browsers' and an inline error of 'This question requires an answer.' for question 'p19q1'
    And I get a summary error of 'Offline working and syncing supported' and an inline error of 'This question requires an answer.' for question 'p19q2'
    And I get a summary error of 'Supported devices' and an inline error of 'This question requires an answer.' for question 'p19q3'

  Scenario: Certifications - too much data
    Given I am on ssp page '20'
    When I fill in 'p20q1val1' with 'Way too many characters.Way too many characters.Way too many characters.Way too many characters.Way too many characters.'
    When I click 'Save and continue'
    Then I should be on the 'Certifications' page
    And I get a summary error of 'Vendor certification(s)' and an inline error of 'Each certification must be less than 100 characters in length.' for question 'p20q1'

  Scenario: Data storage - no data
    Given I am on ssp page '22'
    When I click 'Save and continue'
    Then I should be on the 'Data storage' page
    And I get a summary error of 'Datacentres adhere to EU Code of Conduct for Operations' and an inline error of 'This question requires an answer.' for question 'p22q1'
    And I get a summary error of 'User-defined data location' and an inline error of 'This question requires an answer.' for question 'p22q2'
    And I get a summary error of 'Datacentre tier' and an inline error of 'This question requires an answer.' for question 'p22q3'
    And I get a summary error of 'Backup, disaster recovery and resilience plan in place' and an inline error of 'Please answer if plans for backup, disaster recovery and resilience are in place' for question 'p22q4'
    And I get a summary error of 'Data extraction/removal plan in place' and an inline error of 'This question requires an answer.' for question 'p22q5'

  Scenario: Data-in-transit protection - no data
    Given I am on ssp page '23'
    When I click 'Save and continue'
    Then I should be on the 'Data-in-transit protection' page
    And I get a summary error of 'Data protection between user device and service' and an inline error of 'This question requires an answer.' for question 'p23q1'
    And I get a summary error of 'Data protection within service' and an inline error of 'This question requires an answer.' for question 'p23q2'
    And I get a summary error of 'Data protection between services' and an inline error of 'This question requires an answer.' for question 'p23q3'

  Scenario: Asset protection and resilience - no data
    Given I am on ssp page '24'
    When I click 'Save and continue'
    Then I should be on the 'Asset protection and resilience' page
    And I get a summary error of 'Datacentre location' and an inline error of 'This question requires an answer.' for question 'p24q1'
    And I get a summary error of 'Data management location' and an inline error of 'This question requires an answer.' for question 'p24q2'
    And I get a summary error of 'Legal jurisdiction of service provider' and an inline error of 'This question requires an answer.' for question 'p24q3'
    And I get a summary error of 'Datacentre protection' and an inline error of 'This question requires an answer.' for question 'p24q4'
    And I get a summary error of 'Data-at-rest protection' and an inline error of 'This question requires an answer.' for question 'p24q5'
    And I get a summary error of 'Secure data deletion' and an inline error of 'This question requires an answer.' for question 'p24q6'
    And I get a summary error of 'Storage media disposal' and an inline error of 'This question requires an answer.' for question 'p24q7'
    And I get a summary error of 'Secure equipment disposal' and an inline error of 'This question requires an answer.' for question 'p24q8'
    And I get a summary error of 'Redundant equipment accounts revoked' and an inline error of 'This question requires an answer.' for question 'p24q9'
    And I get a summary error of 'Service availability' and an inline error of 'This question requires an answer.' for question 'p24q10'

  Scenario: Separation between consumers - no data
    Given I am on ssp page '25'
    When I click 'Save and continue'
    Then I should be on the 'Separation between consumers' page
    And I get a summary error of 'Cloud deployment model' and an inline error of 'This question requires an answer.' for question 'p25q1'
    And I get a summary error of 'Type of consumer' and an inline error of 'This question requires an answer.' for question 'p25q2'
    And I get a summary error of 'Services separation' and an inline error of 'This question requires an answer.' for question 'p25q3'
    And I get a summary error of 'Services management separation' and an inline error of 'This question requires an answer.' for question 'p25q4'

  Scenario: Governance - no data
    Given I am on ssp page '26'
    When I click 'Save and continue'
    Then I should be on the 'Governance' page
    And I get a summary error of 'Governance framework' and an inline error of 'This question requires an answer.' for question 'p26q1'

  Scenario: Configuration and change management - no data
    Given I am on ssp page '27'
    When I click 'Save and continue'
    Then I should be on the 'Configuration and change management' page
    And I get a summary error of 'Configuration and change management tracking' and an inline error of 'This question requires an answer.' for question 'p27q1'
    And I get a summary error of 'Change impact assessment' and an inline error of 'This question requires an answer.' for question 'p27q2'

  Scenario: Vulnerabilility management - no data
    Given I am on ssp page '28'
    When I click 'Save and continue'
    Then I should be on the 'Vulnerabilility management' page
    And I get a summary error of 'Vulnerability assessment' and an inline error of 'This question requires an answer.' for question 'p28q1'
    And I get a summary error of 'Vulnerability monitoring' and an inline error of 'This question requires an answer.' for question 'p28q2'
    And I get a summary error of 'Vulnerability mitigation prioritisation' and an inline error of 'This question requires an answer.' for question 'p28q3'
    And I get a summary error of 'Vulnerability tracking' and an inline error of 'This question requires an answer.' for question 'p28q4'
    And I get a summary error of 'Vulnerability mitigation timescales' and an inline error of 'This question requires an answer.' for question 'p28q5'

  Scenario: Event monitoring - no data
    Given I am on ssp page '29'
    When I click 'Save and continue'
    Then I should be on the 'Event monitoring' page
    And I get a summary error of 'Event monitoring' and an inline error of 'This question requires an answer.' for question 'p29q1'

  Scenario: Incident management - no data
    Given I am on ssp page '30'
    When I click 'Save and continue'
    Then I should be on the 'Incident management' page
    And I get a summary error of 'Incident management processes' and an inline error of 'This question requires an answer.' for question 'p30q1'
    And I get a summary error of 'Consumer reporting of security incidents' and an inline error of 'This question requires an answer.' for question 'p30q2'
    And I get a summary error of 'Security incident definition published' and an inline error of 'This question requires an answer.' for question 'p30q3'

  Scenario: Personnel security - no data
    Given I am on ssp page '31'
    When I click 'Save and continue'
    Then I should be on the 'Personnel security' page
    And I get a summary error of 'Personnel security checks' and an inline error of 'This question requires an answer.' for question 'p31q1'

  Scenario: Secure development - no data
    Given I am on ssp page '32'
    When I click 'Save and continue'
    Then I should be on the 'Secure development' page
    And I get a summary error of 'Secure development' and an inline error of 'This question requires an answer.' for question 'p32q1'
    And I get a summary error of 'Secure design, coding, testing and deployment' and an inline error of 'This question requires an answer.' for question 'p32q2'
    And I get a summary error of 'Software configuration management' and an inline error of 'This question requires an answer.' for question 'p32q3'

  Scenario: Supply-chain security - no data
    Given I am on ssp page '33'
    When I click 'Save and continue'
    Then I should be on the 'Supply-chain security' page
    And I get a summary error of 'Visibility of data shared with third-party suppliers' and an inline error of 'This question requires an answer.' for question 'p33q1'
    And I get a summary error of 'Third-party supplier security requirements' and an inline error of 'This question requires an answer.' for question 'p33q2'
    And I get a summary error of 'Third-party supplier risk assessment' and an inline error of 'This question requires an answer.' for question 'p33q3'
    And I get a summary error of 'Third-party supplier compliance monitoring' and an inline error of 'This question requires an answer.' for question 'p33q4'
    And I get a summary error of 'Hardware and software verification' and an inline error of 'This question requires an answer.' for question 'p33q5'

  Scenario: Authentication of consumers - no data
    Given I am on ssp page '34'
    When I click 'Save and continue'
    Then I should be on the 'Authentication of consumers' page
    And I get a summary error of 'User authentication and access management' and an inline error of 'This question requires an answer.' for question 'p34q1'
    And I get a summary error of 'User access control through support channels' and an inline error of 'This question requires an answer.' for question 'p34q2'

  Scenario: Separation and access control within management interfaces - no data
    Given I am on ssp page '35'
    When I click 'Save and continue'
    Then I should be on the 'Separation and access control within management interfaces' page
    And I get a summary error of 'User access control within management interfaces' and an inline error of 'This question requires an answer.' for question 'p35q1'
    And I get a summary error of 'Administrator permissions' and an inline error of 'This question requires an answer.' for question 'p35q2'
    And I get a summary error of 'Management interface protection' and an inline error of 'This question requires an answer.' for question 'p35q3'

  Scenario: Identity and authentication - no data
    Given I am on ssp page '36'
    When I click 'Save and continue'
    Then I should be on the 'Identity and authentication' page
    And I get a summary error of 'Identity and authentication controls' and an inline error of 'This question requires an answer.' for question 'p36q1'

  Scenario: External interface protection - no data
    Given I am on ssp page '37'
    When I click 'Save and continue'
    Then I should be on the 'External interface protection' page
    And I get a summary error of 'Onboarding guidance provided' and an inline error of 'This question requires an answer.' for question 'p37q1'
    And I get a summary error of 'Interconnection method provided' and an inline error of 'This question requires an answer.' for question 'p37q2'

  Scenario: Secure service administration - no data
    Given I am on ssp page '38'
    When I click 'Save and continue'
    Then I should be on the 'Secure service administration' page
    And I get a summary error of 'Service management model' and an inline error of 'This question requires an answer.' for question 'p38q1'

  Scenario: Audit information provision to consumers - no data
    Given I am on ssp page '39'
    When I click 'Save and continue'
    Then I should be on the 'Audit information provision to consumers' page
    And I get a summary error of 'Audit information provided' and an inline error of 'This question requires an answer.' for question 'p39q1'

  Scenario: Secure use of the service by the customer - no data
    Given I am on ssp page '40'
    When I click 'Save and continue'
    Then I should be on the 'Secure use of the service by the customer' page
    And I get a summary error of 'Device access method' and an inline error of 'This question requires an answer.' for question 'p40q1'
    And I get a summary error of 'Service configuration guidance' and an inline error of 'This question requires an answer.' for question 'p40q2'
    And I get a summary error of 'Training' and an inline error of 'This question requires an answer.' for question 'p40q3'

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “My IaaS service”'
    Then I should be on the listing page
    And My service should not be in the list

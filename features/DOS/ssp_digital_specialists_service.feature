@not-production @functional-test @ssp @wip2
Feature: Submitting a new DOS service for Digital specialists
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select Digital specialists as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and delete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'Digital specialists'
    Then I should be on the 'Digital specialists' page

  Scenario: Provide Service essentials
    Given I am on ssp page 'digital-specialists'
    When I navigate to the 'Edit' 'Service essentials' page
    And I choose 'No' for 'helpGovernmentImproveServices'
    And I choose 'Yes' for 'bespokeSystemInformation'
    And I choose 'No' for 'dataProtocols'
    And I choose 'No' for 'openStandardsPrinciples'
    And I choose 'Yes' for 'openSourceLicence'
    And I click 'Save and continue'
    Then I should be on the 'Individual specialist roles' page

  Scenario: A draft service has been created
    Given I am at '/suppliers/frameworks/digital-outcomes-and-specialists/submissions'
    Then There is 'a' draft 'Digital specialists' service

  Scenario: Provide Individual specialist roles
    Given I am on ssp page 'digital-specialists'
    When I navigate to the 'Edit' 'Individual specialist roles' page
    And I check 'Data analysis' for 'performanceAnalysisTypes'
    And I check 'Statistical modelling' for 'performanceAnalysisTypes'
    And I check 'A/B and multivariate testing' for 'performanceAnalysisTypes'
    And I check 'Risk management' for 'securityTypes'
    And I check 'Firewall review / audit' for 'securityTypes'
    And I check 'Project management' for 'deliveryTypes'
    And I check 'Frontend web application development' for 'softwareDevelopmentTypes'
    And I check 'API development' for 'softwareDevelopmentTypes'
    And I check 'Customer relationship management' for 'softwareDevelopmentTypes'
    And I check 'Mainframe (Cobol / etc)' for 'softwareDevelopmentTypes'
    And I check 'Incident management' for 'supportAndOperationsTypes'
    And I check 'Application testing (Automated/Exploratory)' for 'testingAndAuditingTypes'
    And I check 'Prototyping' for 'userExperienceAndDesignTypes'
    And I check 'User needs and insights' for 'userResearchTypes'
    And I check 'User journey mapping' for 'userResearchTypes'
    And I check 'Creating personas' for 'userResearchTypes'
    And I check 'Usability testing' for 'userResearchTypes'
    And I check 'Quantitative research' for 'userResearchTypes'
    And I check 'Surveys' for 'userResearchTypes'
    And I click 'Save and continue'
    Then I should be on the 'Outcomes locations' page

  Scenario: Provide Outcomes locations
    Given I am on ssp page 'digital-specialists'
    When I navigate to the 'Edit' 'Outcomes locations' page
    And I check 'Scotland' for 'outcomesLocations'
    And I check 'Wales' for 'outcomesLocations'
    And I check 'London' for 'outcomesLocations'
    And I check 'Northern Ireland' for 'outcomesLocations'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page
@wip2
  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Can you, if asked, recruit participants without revealing details of the organisation you're recruiting for?' should contain 'Yes'
    And Summary row 'Do you agree to manage any incentives to user research participants? ' should contain 'No'
    And Summary row 'Where can you recruit participants from?' should contain 'North East England'
    And Summary row 'How do you recruit participants?' should contain 'Yes'
    And Summary row 'Are you willing to recruit participants based on a list provided to you by the buyer?' should contain 'Yes'

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “Digital specialists'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And There is 'no' draft 'Digital specialists' service

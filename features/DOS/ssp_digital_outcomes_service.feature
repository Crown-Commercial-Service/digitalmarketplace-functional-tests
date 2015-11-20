@not-production @functional-test @ssp
Feature: Submitting a new DOS service for Digital outcomes
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select Digital outcomes as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and delete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'Digital outcomes'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Service essentials
    Given I am on ssp page 'digital-outcomes'
    When I navigate to the 'Edit' 'Service essentials' page
    And I choose 'Yes' for 'helpGovernmentImproveServices'
    And I choose 'No' for 'bespokeSystemInformation'
    And I choose 'Yes' for 'dataProtocols'
    And I choose 'Yes' for 'openStandardsPrinciples'
    And I choose 'No' for 'openSourceLicence'
    And I click 'Save and continue'
    Then I should be on the 'Team capabilities' page

  Scenario: Provide Team capabilities
    Given I am on ssp page 'digital-outcomes'
    When I navigate to the 'Edit' 'Team capabilities' page
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
    Given I am on ssp page 'digital-outcomes'
    When I navigate to the 'Edit' 'Outcomes locations' page
    And I check 'Scotland' for 'outcomesLocations'
    And I check 'Wales' for 'outcomesLocations'
    And I check 'London' for 'outcomesLocations'
    And I check 'Northern Ireland' for 'outcomesLocations'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

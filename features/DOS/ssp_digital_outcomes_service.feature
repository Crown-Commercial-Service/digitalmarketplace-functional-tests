@not-production @functional-test @ssp-dos1
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

    When I click 'Add, edit and complete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'Apply to provide teams for digital outcomes'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Service essentials
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Edit' link for 'Service essentials'
    Then I should be on the 'Service essentials' page

    When I choose 'Yes' for 'helpGovernmentImproveServices'
    And I choose 'No' for 'bespokeSystemInformation'
    And I choose 'Yes' for 'dataProtocols'
    And I choose 'Yes' for 'openStandardsPrinciples'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Outcomes locations
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Edit' link for 'Outcomes locations'
    Then I should be on the 'Outcomes locations' page

    When I check 'Scotland' for 'outcomesLocations'
    And I check 'Wales' for 'outcomesLocations'
    And I check 'London' for 'outcomesLocations'
    And I check 'Northern Ireland' for 'outcomesLocations'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

    #Service can't be completed unless at least one "Team capability" has been defined
    And The 'Mark as complete' button should not be on the page
    #And The service 'can't' be marked as complete

  Scenario: A draft service has been created
    Given I am at '/suppliers/frameworks/digital-outcomes-and-specialists/submissions'
    Then There is 'a' draft 'Digital outcomes' service

  Scenario: Provide Team capabilities-Performance analysis and data
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Performance analysis and data'
    Then I should be on the 'Performance analysis and data' page

    When I check 'Data analysis' for 'performanceAnalysisTypes'
    And I check 'Statistical modelling' for 'performanceAnalysisTypes'
    And I check 'A/B and multivariate testing' for 'performanceAnalysisTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

    #Service can now be completed as one "Team capability" has been defined
    And The 'Mark as complete' button should be on the page
    #And The service 'can' be marked as complete

  Scenario: Provide Team capabilities-Security
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Security'
    Then I should be on the 'Security' page

    When I check 'Security policy' for 'securityTypes'
    And I check 'Firewall audit' for 'securityTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Service delivery
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Service delivery'
    Then I should be on the 'Service delivery' page

    When I check 'Agile coaching and training' for 'deliveryTypes'
    And I check 'Project management' for 'deliveryTypes'
    And I check 'Digital communication and engagement' for 'deliveryTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Software development
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Software development'
    Then I should be on the 'Software development' page

    When I check 'Frontend web application development' for 'softwareDevelopmentTypes'
    And I check 'API development' for 'softwareDevelopmentTypes'
    And I check 'Geographic information systems (GIS) development' for 'softwareDevelopmentTypes'
    And I check 'Mainframe' for 'softwareDevelopmentTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Support and operations
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Support and operations'
    Then I should be on the 'Support and operations' page

    When I check 'Incident management' for 'supportAndOperationsTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Testing and auditing
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'Testing and auditing'
    Then I should be on the 'Testing and auditing' page

    When I check 'Application testing' for 'testingAndAuditingTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-User experience and design
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'User experience and design'
    Then I should be on the 'User experience and design' page

    When I check 'User experience and design strategy' for 'userExperienceAndDesignTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-User research
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Add' link for 'User research'
    Then I should be on the 'User research' page

    When I check 'User needs and insights' for 'userResearchTypes'
    And I check 'User journey mapping' for 'userResearchTypes'
    And I check 'Creating personas' for 'userResearchTypes'
    And I check 'Usability testing' for 'userResearchTypes'
    And I check 'Quantitative research' for 'userResearchTypes'
    And I check 'Surveys' for 'userResearchTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Share non-personal data' under 'Service essentials' should contain 'Yes'
    And Summary row 'Share systems information' under 'Service essentials' should contain 'No'
    And Summary row 'Standard data protocols' under 'Service essentials' should contain 'Yes'
    And Summary row 'Use of open standards' under 'Service essentials' should contain 'Yes'
    And Summary row 'Performance analysis and data' under 'Team capabilities' should contain 'A/B and multivariate testing'
    And Summary row 'Performance analysis and data' under 'Team capabilities' should contain 'Data analysis'
    And Summary row 'Performance analysis and data' under 'Team capabilities' should contain 'Statistical modelling'
    And Summary row 'Security' under 'Team capabilities' should contain 'Firewall audit'
    And Summary row 'Security' under 'Team capabilities' should contain 'Security policy'
    And Summary row 'Service delivery' under 'Team capabilities' should contain 'Agile coaching and training'
    And Summary row 'Service delivery' under 'Team capabilities' should contain 'Digital communication and engagement'
    And Summary row 'Service delivery' under 'Team capabilities' should contain 'Project management'
    And Summary row 'Software development' under 'Team capabilities' should contain 'API development'
    And Summary row 'Software development' under 'Team capabilities' should contain 'Frontend web application development'
    And Summary row 'Software development' under 'Team capabilities' should contain 'Geographic information systems (GIS) development'
    And Summary row 'Software development' under 'Team capabilities' should contain 'Mainframe'
    And Summary row 'Support and operations' under 'Team capabilities' should contain 'Incident management'
    And Summary row 'Testing and auditing' under 'Team capabilities' should contain 'Application testing'
    And Summary row 'User experience and design' under 'Team capabilities' should contain 'User experience and design strategy'
    And Summary row 'User research' under 'Team capabilities' should contain 'Creating personas'
    And Summary row 'User research' under 'Team capabilities' should contain 'Quantitative research'
    And Summary row 'User research' under 'Team capabilities' should contain 'Surveys'
    And Summary row 'User research' under 'Team capabilities' should contain 'Usability testing'
    And Summary row 'User research' under 'Team capabilities' should contain 'User journey mapping'
    And Summary row 'User research' under 'Team capabilities' should contain 'User needs and insights'

  Scenario: Remove Team capabilities-Testing and auditing
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Remove' link for 'Testing and auditing'
    Then I am presented with the message 'Are you sure you want to remove testing and auditing?'

    When I click 'Yes – remove testing and auditing'
    Then I am presented with the message 'Testing and auditing was deleted'
    And Summary row 'Testing and auditing' under 'Team capabilities' should contain 'You haven't added any testing and auditing capabilities'

  @mark_as_complete
  Scenario: Mark service as complete
    Given I am on ssp page 'digital-outcomes'
    When I click the 'Mark as complete' button at the 'bottom' of the page
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And I am presented with the message 'Digital outcomes was marked as complete'
    And There is 'a' complete 'Digital outcomes' service
    And There is 'no' draft 'Digital outcomes' service

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete ‘digital outcomes’'
    Then I am presented with the message 'Are you sure you want to delete this service?'

    When I click 'Yes, delete digital outcomes'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And I am presented with the message 'Digital outcomes was deleted'
    And There is 'no' draft 'Digital outcomes' service

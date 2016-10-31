@not-production @functional-test @ssp-dos
Feature: Submitting a new DOS service for Digital outcomes
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Digital Marketplace' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select Digital outcomes as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists 2 application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and complete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists 2 services' page

    When I click 'Apply to provide teams for digital outcomes'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Service essentials
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Edit' link for 'Service essentials'
    Then I should be on the 'Service essentials' page

    When I choose 'Yes' for 'helpGovernmentImproveServices'
    And I choose 'No' for 'bespokeSystemInformation'
    And I choose 'Yes' for 'dataProtocols'
    And I choose 'Yes' for 'openStandardsPrinciples'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Outcomes locations
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Edit' link for 'Outcomes locations'
    Then I should be on the 'Outcomes locations' page

    When I 'check' 'Scotland' for 'locations'
    And I 'check' 'Wales' for 'locations'
    And I 'check' 'London' for 'locations'
    And I 'check' 'Northern Ireland' for 'locations'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

    #Service can't be completed unless at least one "Team capability" has been defined
    And The 'Mark as complete' button should not be on the page

  Scenario: A draft service has been created
    Given I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'is a' draft 'digital outcomes' service(s)
    And There 'is no' completed 'digital outcomes' service(s)

  Scenario: Provide Team capabilities-Performance analysis and data
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Performance analysis and data'
    Then I should be on the 'Performance analysis and data' page

    When I 'check' 'Data analysis' for 'performanceAnalysisTypes'
    And I 'check' 'Statistical modelling' for 'performanceAnalysisTypes'
    And I 'check' 'A/B and multivariate testing' for 'performanceAnalysisTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

    #Service can now be completed as one "Team capability" has been defined
    And The 'Mark as complete' button should be on the page

  Scenario: Provide Team capabilities-Security
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Security'
    Then I should be on the 'Security' page

    When I 'check' 'Security policy' for 'securityTypes'
    And I 'check' 'Firewall audit' for 'securityTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Service delivery
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Service delivery'
    Then I should be on the 'Service delivery' page

    When I 'check' 'Agile coaching' for 'deliveryTypes'
    And I 'check' 'Project management' for 'deliveryTypes'
    And I 'check' 'Digital communication and engagement' for 'deliveryTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Software development
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Software development'
    Then I should be on the 'Software development' page

    When I 'check' 'Front-end web application development' for 'softwareDevelopmentTypes'
    And I 'check' 'API development' for 'softwareDevelopmentTypes'
    And I 'check' 'Geographic information systems (GIS) development' for 'softwareDevelopmentTypes'
    And I 'check' 'Mainframe' for 'softwareDevelopmentTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Support and operations
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Support and operations'
    Then I should be on the 'Support and operations' page

    When I 'check' 'Incident management' for 'supportAndOperationsTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-Testing and auditing
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'Testing and auditing'
    Then I should be on the 'Testing and auditing' page

    When I 'check' 'Application testing' for 'testingAndAuditingTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-User experience and design
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'User experience and design'
    Then I should be on the 'User experience and design' page

    When I 'check' 'User experience and design strategy' for 'userExperienceAndDesignTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Provide Team capabilities-User research
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Add' link for 'User research'
    Then I should be on the 'User research' page

    When I 'check' 'User needs and insights' for 'userResearchTypes'
    And I 'check' 'User journey mapping' for 'userResearchTypes'
    And I 'check' 'Creating personas' for 'userResearchTypes'
    And I 'check' 'Usability testing' for 'userResearchTypes'
    And I 'check' 'Quantitative research' for 'userResearchTypes'
    And I 'check' 'Quantitative research' for 'userResearchTypes'
    And I click 'Save and continue'
    Then I should be on the 'Digital outcomes' page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary table row 'Share non-personal data' under the heading 'Service essentials' should contain 'Yes'
    And Summary table row 'Share systems information' under the heading 'Service essentials' should contain 'No'
    And Summary table row 'Standard data protocols' under the heading 'Service essentials' should contain 'Yes'
    And Summary table row 'Use of open standards' under the heading 'Service essentials' should contain 'Yes'
    And Summary table row 'Performance analysis and data' under the heading 'Team capabilities' should contain 'A/B and multivariate testing'
    And Summary table row 'Performance analysis and data' under the heading 'Team capabilities' should contain 'Data analysis'
    And Summary table row 'Performance analysis and data' under the heading 'Team capabilities' should contain 'Statistical modelling'
    And Summary table row 'Security' under the heading 'Team capabilities' should contain 'Firewall audit'
    And Summary table row 'Security' under the heading 'Team capabilities' should contain 'Security policy'
    And Summary table row 'Service delivery' under the heading 'Team capabilities' should contain 'Agile coaching'
    And Summary table row 'Service delivery' under the heading 'Team capabilities' should contain 'Digital communication and engagement'
    And Summary table row 'Service delivery' under the heading 'Team capabilities' should contain 'Project management'
    And Summary table row 'Software development' under the heading 'Team capabilities' should contain 'API development'
    And Summary table row 'Software development' under the heading 'Team capabilities' should contain 'Front-end web application development'
    And Summary table row 'Software development' under the heading 'Team capabilities' should contain 'Geographic information systems (GIS) development'
    And Summary table row 'Software development' under the heading 'Team capabilities' should contain 'Mainframe'
    And Summary table row 'Support and operations' under the heading 'Team capabilities' should contain 'Incident management'
    And Summary table row 'Testing and auditing' under the heading 'Team capabilities' should contain 'Application testing'
    And Summary table row 'User experience and design' under the heading 'Team capabilities' should contain 'User experience and design strategy'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'Creating personas'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'Quantitative research'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'Quantitative research'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'Usability testing'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'User journey mapping'
    And Summary table row 'User research' under the heading 'Team capabilities' should contain 'User needs and insights'

  Scenario: Remove Team capabilities-Testing and auditing
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Remove' link for 'Testing and auditing'
    Then I am presented with the message 'Are you sure you want to remove testing and auditing?'

    When I click 'Yes – remove testing and auditing'
    Then I am presented with the message 'Testing and auditing was deleted'
    And Summary table row 'Testing and auditing' under the heading 'Team capabilities' should contain 'You haven’t added any testing and auditing capabilities'

  @mark_as_complete
  Scenario: Mark service as complete
    Given I am on the ssp page for the 'digital-outcomes' service
    When I click the 'Mark as complete' button at the 'bottom' of the page
    Then I am taken to the 'Your Digital Outcomes and Specialists 2 services' page
    And I am presented with the message 'Digital outcomes was marked as complete'
    And There 'is a' completed 'digital outcomes' service(s)
    And There 'is no' draft 'digital outcomes' service(s)

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete'
    Then I am presented with the message 'Are you sure you want to delete digital outcomes?'

    When I click 'Yes, delete'
    Then I am taken to the 'Your Digital Outcomes and Specialists 2 services' page
    And I am presented with the message 'Digital outcomes was deleted'
    And There 'is no' draft 'digital outcomes' service(s)
    And There 'is no' completed 'digital outcomes' service(s)

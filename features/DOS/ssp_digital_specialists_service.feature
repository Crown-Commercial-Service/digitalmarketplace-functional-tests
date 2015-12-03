@not-production @functional-test @ssp-dos
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

    When I click 'Add, edit and complete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'Digital specialists'
    Then I should be on the 'Digital specialists' page

  Scenario: Provide Service essentials
    Given I am on ssp page 'digital-specialists'
    When I click the 'Edit' link for 'Service essentials'
    Then I should be on the 'Service essentials' page

    When I choose 'No' for 'helpGovernmentImproveServices'
    And I choose 'Yes' for 'bespokeSystemInformation'
    And I choose 'No' for 'dataProtocols'
    And I choose 'No' for 'openStandardsPrinciples'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: A draft service has been created
    Given I am at '/suppliers/frameworks/digital-outcomes-and-specialists/submissions'
    Then There is 'a' draft 'Digital specialists' service

  Scenario: Provide Individual specialist roles-Agile coach
    Given I am on ssp page 'digital-specialists'
    When I click the 'Add' link for 'Agile coach'
    Then I should be on the 'Agile coach' page

    When I check 'Scotland' for 'agileCoachLocations'
    And I check 'London' for 'agileCoachLocations'
    And I check 'Northern Ireland' for 'agileCoachLocations'
    And I check 'Wales' for 'agileCoachLocations'
    And I check 'Off-site' for 'agileCoachLocations'
    And I fill in 'agileCoachPriceMin' with '214'
    And I fill in 'agileCoachPriceMax' with '581'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: Provide Individual specialist roles-User researcher
    Given I am on ssp page 'digital-specialists'
    When I click the 'Add' link for 'User researcher'
    Then I should be on the 'User researcher' page

    When I check 'The Midlands' for 'userResearcherLocations'
    And I check 'Yorkshire and the Humber' for 'userResearcherLocations'
    And I fill in 'userResearcherPriceMin' with '187'
    And I fill in 'userResearcherPriceMax' with '345'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: Edit-User researcher price
    Given I am on ssp page 'digital-specialists'
    When I click the 'Edit' link for 'User researcher'
    Then I should be on the 'User researcher' page

    And I fill in 'userResearcherPriceMin' with '198'
    And I fill in 'userResearcherPriceMax' with '345'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: Provide Individual specialist roles-User researcher
    Given I am on ssp page 'digital-specialists'
    When I click the 'Add' link for 'Web operations engineer'
    Then I should be on the 'Web operations engineer' page

    When I check 'The Midlands' for 'webOperationsLocations'
    And I check 'South East England' for 'webOperationsLocations'
    And I fill in 'webOperationsPriceMin' with '310'
    And I fill in 'webOperationsPriceMax' with '701'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Share non-personal data' under 'Service essentials' should contain 'No'
    And Summary row 'Share systems information' under 'Service essentials' should contain 'Yes'
    And Summary row 'Standard data protocols' under 'Service essentials' should contain 'No'
    And Summary row 'Use of open standards' under 'Service essentials' should contain 'No'

    Then Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Off-site'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Scotland'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Wales'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'London'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Northern Ireland'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain '£214 to £581 per person per day'

    Then Summary row 'User researcher' under 'Individual specialist roles' should contain 'Yorkshire and the Humber'
    And Summary row 'User researcher' under 'Individual specialist roles' should contain 'The Midlands'
    And Summary row 'User researcher' under 'Individual specialist roles' should contain '£198 to £345 per person per day'

    Then Summary row 'Web operations engineer' under 'Individual specialist roles' should contain 'South East England'
    And Summary row 'Web operations engineer' under 'Individual specialist roles' should contain '£310 to £701 per person per day'

  Scenario: Edit-Agile coach locations
    Given I am on ssp page 'digital-specialists'
    When I click the 'Edit' link for 'Agile coach'
    Then I should be on the 'Agile coach' page

    When I uncheck 'Scotland' for 'agileCoachLocations'
    And I uncheck 'Northern Ireland' for 'agileCoachLocations'
    And I check 'West England' for 'agileCoachLocations'
    And I click 'Save and continue'
    Then I should be on the 'Digital specialists' page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Off-site'
    And Summary row 'Agile coach' under 'Individual specialist roles' should not contain 'Scotland'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'Wales'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'London'
    And Summary row 'Agile coach' under 'Individual specialist roles' should not contain 'Northern Ireland'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain 'West England'
    And Summary row 'Agile coach' under 'Individual specialist roles' should contain '£214 to £581 per person per day'

    Then Summary row 'User researcher' under 'Individual specialist roles' should contain 'Yorkshire and the Humber'
    And Summary row 'User researcher' under 'Individual specialist roles' should contain 'The Midlands'
    And Summary row 'User researcher' under 'Individual specialist roles' should contain '£198 to £345 per person per day'

    Then Summary row 'Web operations engineer' under 'Individual specialist roles' should contain 'South East England'
    And Summary row 'Web operations engineer' under 'Individual specialist roles' should contain '£310 to £701 per person per day'

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete ‘digital specialists’'
    Then I am presented with the message 'Are you sure you want to delete this service?'

    When I click 'Yes, delete digital specialists'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And I am presented with the message 'Digital specialists was deleted'
    And There is 'no' draft 'Digital specialists' service

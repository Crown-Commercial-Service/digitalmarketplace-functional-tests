@not-production @functional-test @ssp-dos
Feature: Submitting a new DOS service for User research participants
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Digital Marketplace' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select User research participants as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and complete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'Apply to provide user research participant recruitment'
    Then I should be on the 'User research participants' page

  Scenario: Provide User research participants essentials
    Given I am on the ssp page for the 'user-research-participants' service
    When I click the 'Edit' link for 'User research participants essentials'
    Then I should be on the 'User research participants essentials' page

    When I choose 'Yes' for 'anonymousRecruitment'
    And I choose 'No' for 'manageIncentives'
    And I click 'Save and continue'
    Then I should be on the 'User research participants' page

  Scenario: A draft service has been created
    Given I am at the 'Your Digital Outcomes and Specialists services' page
    Then There 'is a' draft 'user research participant recruitment' service(s)
    And There 'is no' completed 'user research participant recruitment' service(s)

  Scenario: Provide Location
    Given I am on the ssp page for the 'user-research-participants' service
    When I click the 'Edit' link for 'Location'
    Then I should be on the 'Location' page

    When I check 'North East England' for 'locations'
    And I check 'Yorkshire and the Humber' for 'locations'
    And I click 'Save and continue'
    Then I should be on the 'User research participants' page

    #Service can't be completed unless "Recruitment approach" has also been defined
    And The 'Mark as complete' button should not be on the page

  Scenario: Provide Recruitment approach
    Given I am on the ssp page for the 'user-research-participants' service
    When I click the 'Edit' link for 'Recruitment approach'
    Then I should be on the 'Recruitment approach' page

    When I choose 'Initial recruitment offline, but then contact them online' for 'recruitMethods'
    And I choose 'Yes' for 'recruitFromList'
    And I click 'Save and continue'
    Then I should be on the 'User research participants' page

    #Service can now be completed as all questions have been answered
    And The 'Mark as complete' button should be on the page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary row 'Provide discreet recruitment' under 'User research participants essentials' should contain 'Yes'
    And Summary row 'Manage incentives' under 'User research participants essentials' should contain 'No'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'North East England'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'Yorkshire and the Humber'
    And Summary row 'How do you recruit participants?' under 'Recruitment approach' should contain 'Initial recruitment offline, but then contact them online'
    And Summary row 'Are you willing to recruit participants based on a list provided to you by the buyer?' under 'Recruitment approach' should contain 'Yes'

  Scenario: Edit answers to all questions
    Given I am on the ssp page for the 'user-research-participants' service
    When I click the 'Edit' link for 'User research participants essentials'
    And I choose 'No' for 'anonymousRecruitment'
    And I choose 'Yes' for 'manageIncentives'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Recruitment approach'
    And I choose 'Entirely online' for 'recruitMethods'
    And I 'uncheck' 'Initial recruitment offline, but then contact them online' for 'recruitMethods'
    And I choose 'No' for 'recruitFromList'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Location'
    And I 'uncheck' 'North East England' for 'locations'
    And I 'uncheck' 'Yorkshire and the Humber' for 'locations'
    And I check 'Scotland' for 'locations'
    And I check 'Wales' for 'locations'
    And I check 'London' for 'locations'
    And I check 'International (outside the UK)' for 'locations'
    And I click 'Save and continue'

  Scenario: Verify text on summary page after edit
    Given I am on the summary page
    #Previous answeres should no longer be presented
    Then Summary row 'Provide discreet recruitment' under 'User research participants essentials' should not contain 'Yes'
    And Summary row 'Manage incentives' under 'User research participants essentials' should not contain 'No'
    And Summary row 'Where can you recruit participants from?' under 'Location' should not contain 'North East England'
    And Summary row 'Where can you recruit participants from?' under 'Location' should not contain 'Yorkshire and the Humber'
    And Summary row 'How do you recruit participants?' under 'Recruitment approach' should not contain 'Initial recruitment offline, but then contact them online'
    And Summary row 'Are you willing to recruit participants based on a list provided to you by the buyer?' under 'Recruitment approach' should not contain 'Yes'

    #New answeres should be presented
    Then Summary row 'Provide discreet recruitment' under 'User research participants essentials' should contain 'No'
    And Summary row 'Manage incentives' under 'User research participants essentials' should contain 'Yes'
    And Summary row 'How do you recruit participants?' under 'Recruitment approach' should contain 'Entirely online'
    And Summary row 'Are you willing to recruit participants based on a list provided to you by the buyer?' under 'Recruitment approach' should contain 'No'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'Scotland'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'Wales'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'London'
    And Summary row 'Where can you recruit participants from?' under 'Location' should contain 'International (outside the UK)'

  @mark_as_complete
  Scenario: Mark service as complete
    Given I am on the ssp page for the 'user-research-participants' service
    When I click the 'Mark as complete' button at the 'bottom' of the page
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And I am presented with the message 'User research participants was marked as complete'
    And There 'is a' completed 'user research participant recruitment' service(s)
    And There 'is no' draft 'user research participant recruitment' service(s)

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete'
    Then I am presented with the message 'Are you sure you want to delete user research participants?'

    When I click 'Yes, delete'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And I am presented with the message 'User research participants was deleted'
    And There 'is no' draft 'user research participant recruitment' service(s)
    And There 'is no' completed 'user research participant recruitment' service(s)

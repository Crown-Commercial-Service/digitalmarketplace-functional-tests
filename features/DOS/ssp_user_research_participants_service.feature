@not-production @functional-test @ssp @wip1
Feature: Submitting a new DOS service for User research participants
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Supplier' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select User research participants as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and delete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page

    When I click 'User research participants'
    Then I should be on the 'User research participants' page

  Scenario: Provide User research participants essentials
    Given I am on ssp page 'user-research-participants'
    When I navigate to the 'Edit' 'User research participants essentials' page
    And I choose 'Yes' for 'anonymousRecruitment'
    And I choose 'No' for 'manageIncentives'
    And I click 'Save and continue'
    Then I should be on the 'Location' page

  Scenario: A draft service has been created
    Given I am at '/suppliers/frameworks/digital-outcomes-and-specialists/submissions'
    Then There is 'a' draft 'User research participants' service

  Scenario: Provide Location
    Given I am on ssp page 'user-research-participants'
    When I navigate to the 'Edit' 'Location' page
    And I check 'North East England' for 'recruitLocations'
    And I check 'Yorkshire and the Humber' for 'recruitLocations'
    And I click 'Save and continue'
    Then I should be on the 'Recruitment approach' page

  Scenario: Provide Recruitment approach
    Given I am on ssp page 'user-research-participants'
    When I navigate to the 'Edit' 'Recruitment approach' page
    And I choose 'Yes' for 'recruitMethods'
    And I choose 'Yes' for 'recruitFromList'
    And I click 'Save and continue'
    Then I should be on the 'User research participants' page

  @delete_service
  Scenario: Delete the service
    Given I am on the summary page
    When I click 'Delete this service'
    And I click 'Yes, delete “User research participants”'
    Then I am taken to the 'Your Digital Outcomes and Specialists services' page
    And There is 'no' draft 'User research participants' service

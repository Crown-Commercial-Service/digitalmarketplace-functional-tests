@not-production @functional-test
Feature: Published requirements can be viewed by the public

Background: Publish requirements
    Given I have a buyer user account
    And I have deleted all draft buyer requirements
    And I have a 'published' set of requirements

Scenario: Public views the publish requirements. Details presented matches what was publisehd.
    Given I am on the 'Digital Marketplace' landing page
    When I am on the public view of the opportunity
    Then Summary row 'Published' 'should' contain 'the published at date of the opportunity'
    Then The Organisation name 'Driver and Vehicle Licensing Agency' is presented on the page
    And The Requirements title 'Individual Specialist-Buyer Requirements' is presented on the page

    And Summary row 'Start date' 'should' contain '31/12/2016'
    And Summary row 'Contract length' 'should' contain '1 day'
    #Public view currently displays 'Location' twice. Reinstate after issue resolved.
    #And Summary row 'Location' 'should' contain 'Scotland'

    And Summary row 'Background information' 'should' contain 'Make a flappy bird clone except where the bird drives very safely'
    And Summary row 'Important dates' 'should' contain 'Yesterday'

    And Summary row 'Essential requirements' 'should' contain 'Can you do coding?'
    And Summary row 'Essential requirements' 'should' contain 'Can you do Python?'
    And Summary row 'Nice-to-have requirements' 'should' contain 'Do you like cats?'
    And Summary row 'Nice-to-have requirements' 'should' contain 'Is your cat named Eva?'

    And Summary row 'Specialist role' 'should' contain 'developer'
    And Summary row 'Evaluating suppliers' 'should' contain 'pitch'

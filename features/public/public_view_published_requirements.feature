@not-production @functional-test @view-brief
Feature: Published requirements can be viewed by the public

Background: Publish requirements
    Given I have a buyer user account
    And I have deleted all draft buyer requirements
    And I have a 'published' set of requirements

Scenario: Public views the publish requirements. Details presented matches what was publisehd.
    Given I am on the 'Digital Marketplace' landing page
    When I am on the public view of the opportunity
    Then Summary row 'Published' should contain 'the published at date of the opportunity'
    And The Requirements title 'Individual Specialist-Buyer Requirements' is presented on the page

    And Summary row 'Latest start date' should contain '31/12/2016'
    And Summary row 'Expected contract length' should contain '1 day'

    And Summary row 'Organisation the work is for' should contain 'Driver and Vehicle Licensing Agency'
    And Summary row 'What the specialist will work on' should contain 'Work on the Digital Marketplace'
    And Summary row 'Who the specialist will work with' should contain 'Digital Marketplace team'
    And Summary row 'Region' should contain 'Scotland'

    And Summary row 'Summary of the work' should contain 'Make a flappy bird clone except where the bird drives very safely'

    And Summary row 'Technical competence: essential skills and experience' should contain 'Can you do coding?'
    And Summary row 'Technical competence: essential skills and experience' should contain 'Can you do Python?'
    And Summary row 'Technical competence: nice-to-have skills and experience' should contain 'Do you like cats?'
    And Summary row 'Technical competence: nice-to-have skills and experience' should contain 'Is your cat named Eva?'

    And Summary row 'Specialist role' should contain 'Developer'
    And Summary row 'Assessment methods' should contain 'Reference'

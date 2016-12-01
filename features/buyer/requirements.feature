@requirements
Feature: Create and publish a requirement
  In order to find individuals and teams that can provide the needed services
  As a buyer within government
  I want to be able to create and publish a requirement

Scenario: Create individual specialist requirement
  Given I am logged in as a buyer user
    And I have created an individual specialist requirement
   Then I answer the following questions:
      | question                                        |
      | Specialist role                                 |
      | Location                                        |
      | Set how long your requirements will be open for |

  Given 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Description of work' should be ticked

  Given 'Shortlist and evaluation process' should not be ticked
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 5     |
      | priceWeighting     | 85    |
   When I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be ticked

  Given 'Describe question and answer session' should not be ticked
   When I click 'Describe question and answer session'
   And I answer all summary questions
   And I click 'Return to overview'
   Then 'Describe question and answer session' should be ticked

   When I click 'Review and publish your requirements'
    And I click 'Publish requirements'
   
  Then I don't see the 'Title' link
   And I don't see the 'Specialist role' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Set how long your requirements will be open for' link
   And I don't see the 'Describe question and answer session' link
   And I don't see the 'Review and publish your requirements' link


Scenario: Create team to provide an outcome
  Given I am logged in as a buyer user
    And I use the following substitutions:
      | value          | substitution   |
      | not_applicable | Not applicable |
      | not_started    | Not started    |
      | discovery      | Discovery      |
      | alpha          | Alpha          |
      | beta           | Beta           |
      | live           | Live           |
    And I have created a team to provide an outcome requirement
   Then I answer the following questions:
      | question                                        |
      | Location                                        |

  Given 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Description of work' should be ticked

  Given 'Shortlist and evaluation process' should not be ticked
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 5     |
      | priceWeighting     | 85    |
    And I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be ticked

  Given 'Describe question and answer session' should not be ticked
   When I click 'Describe question and answer session'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Describe question and answer session' should be ticked

   When I click 'Review and publish your requirements'
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Review and publish your requirements' link


Scenario: Create team to provide an outcome
  Given I am logged in as a buyer user
    And I use the following substitutions:
      | value          | substitution   |
      | not_applicable | Not applicable |
      | not_started    | Not started    |
      | discovery      | Discovery      |
      | alpha          | Alpha          |
      | beta           | Beta           |
      | live           | Live           |
    And I have created a team to provide an outcome requirement
   Then I answer the following questions:
      | question                                        |
      | Location                                        |

  Given 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Description of work' should be ticked

  Given 'Shortlist and evaluation process' should not be ticked
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 5     |
      | priceWeighting     | 85    |
    And I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be ticked

  Given 'Describe question and answer session' should not be ticked
   When I click 'Describe question and answer session'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Describe question and answer session' should be ticked

   When I click 'Review and publish your requirements'
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Review and publish your requirements' link


Scenario: Create user research participants
  Given I am logged in as a buyer user
    And I have created user research participants requirement
   Then I answer the following questions:
      | question                                        |
      | Location                                        |

  Given 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Description of work' should be ticked

  Given 'Shortlist and evaluation process' should not be ticked
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 10    |
      | priceWeighting     | 80    |
    And I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be ticked

  Given 'Describe question and answer session' should not be ticked
   When I click 'Describe question and answer session'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Describe question and answer session' should be ticked

   When I click 'Review and publish your requirements'
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Review and publish your requirements' link



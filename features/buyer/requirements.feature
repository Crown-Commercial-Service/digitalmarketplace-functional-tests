@requirements
Feature: Create and publish a requirement
  In order to find individuals and teams that can provide the needed services
  As a buyer within government
  I want to be able to create and publish a requirement

Scenario Outline: Create a draft requirement for each lot
  Given I am logged in as a buyer user
  When I click '<link_name>'
  Then I am on the '<link_name>' page
  When I click 'Create requirement'
  Then I am on the 'What you want to call your requirements' page
  When I enter 'Green Tea Drinker' in the 'input-title' field and click its associated 'Save and continue' button
  Then I am on the 'Green Tea Drinker' page
  When I click 'View your account'
  Then I am on the /buyers page
  And I see 'Green Tea Drinker' in the 'Unpublished requirements' summary table

  Examples:
    | link_name                         |
    | Find an individual specialist     |
    | Find a team to provide an outcome |
    | Find user research participants   |


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
    And I answer all summary questions with:
      | field                 | value       | expected_summary_table_value |
      | startDate-day         | 08          | Tuesday 8                    |
      | startDate-month       | 9           | September                    |
      | startDate-year        | 2020        | 2020                         |

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
    And I have created a team to provide an outcome requirement
   Then I answer the following questions:
      | question |
      | Location |

  Given 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer all summary questions with:
      | field                 | value       | expected_summary_table_value |
      | startDate-day         | 9           | Wednesday 9                    |
      | startDate-month       | 9           | September                    |
      | startDate-year        | 2020        | 2020                         |
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
      | question |
      | Location |

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
   Then I see the 'Publish requirements' button
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Review and publish your requirements' link


Scenario Outline: Copy requirements
  Given I have a live digital outcomes and specialists framework
  And I have a buyer
  And that buyer is logged in
  And I have a <status> digital-specialists brief
  And I am on the /buyers page
  When I click the 'Make a copy' button
  Then I am on the 'What you want to call your requirements' page
  And I see 'Tea drinker copy' as the value of the 'title' field
  When I click the 'Save and continue' button
  Then I am on the 'Tea drinker copy' page

  Examples:
    | status    |
    | live      |
    | withdrawn |
    | draft     |


Scenario Outline: View requirement in a dashboard
  Given I have a live digital outcomes and specialists framework
  And I have a buyer
  And that buyer is logged in
  And I have a <status> digital-specialists brief
  When I click 'View your account'
  Then I am on the /buyers page
  And I see 'Tea drinker' in the '<table heading>' summary table

  Examples:
    | status    | table heading            |
    | live      | Published requirements   |
    | withdrawn | Closed requirements      |
    | draft     | Unpublished requirements |


Scenario: Delete a draft requirement
  Given I am logged in as a buyer user
  And I have created an individual specialist requirement

  When I click 'Delete'
  Then I see a destructive banner message containing 'Are you sure you want to delete these requirements?'
  When I click 'Yes, delete'
  Then I see a success banner message containing 'were deleted'


Scenario: Edit a draft requirement
  Given I am logged in as a buyer user
  And I have created an individual specialist requirement
  When I click 'Title'
  Then I am on the 'What you want to call your requirements' page
  When I enter 'Green Tea Drinker' in the 'input-title' field and click its associated 'Save and continue' button
  Then I am on the 'Green Tea Drinker' page


Scenario: There is no 'Publish requirements' button for an incomplete requirement draft
  Given I am logged in as a buyer user
  And I have created an individual specialist requirement
  When I click 'Review and publish your requirements'
  Then I don't see the 'Publish requirements' button

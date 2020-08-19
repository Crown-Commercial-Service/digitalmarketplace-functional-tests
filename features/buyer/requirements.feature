@buyer @requirements
Feature: Create and publish a requirement
  In order to find individuals and teams that can provide the needed services
  As a buyer within government
  I want to be able to create and publish a requirement


Scenario: Create individual specialist requirement
  Given I am logged in as a buyer user
    And I have created an individual specialist requirement
   Then I complete the following tasks:
      | task_name                                       |
      | Specialist role                                 |
      | Location                                        |
      | Set how long your requirements will be open for |

  Given 'Description of work' should not be completed
   When I click 'Description of work'
    And I answer all summary questions with:
      | field                 | value       | expected_summary_table_value |
      | startDate-day         | 08          | Tuesday 8                    |
      | startDate-month       | 9           | September                    |
      | startDate-year        | 2020        | 2020                         |

    And I click 'Return to overview'
   Then 'Description of work' should be completed

  Given 'Shortlist and evaluation process' should not be completed
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 5     |
      | priceWeighting     | 85    |
   When I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be completed

  Given 'Describe question and answer session' should not be completed
   When I click 'Describe question and answer session'
   And I answer all summary questions
   And I click 'Return to overview'
   Then 'Describe question and answer session' should be completed

   When I click 'Preview your requirements'
   Then I am on the 'Preview your requirements' page
    And I see the 'Return to overview' link
    And I see 'Incomplete applications' text in the desktop preview panel
    And I see 'Tuesday 8 September 2020' text in the desktop preview panel
    And I see 'Technical competence 10%' text in the desktop preview panel
    And I click 'Confirm your requirements and publish'
   Then I am on the 'Publish your requirements and evaluation criteria' page
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Specialist role' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Set how long your requirements will be open for' link
   And I don't see the 'Describe question and answer session' link
   And I don't see the 'Publish your requirements' link


Scenario: Create team to provide an outcome
  Given I am logged in as a buyer user
    And I have created a team to provide an outcome requirement
   Then I complete the following tasks:
      | task_name |
      | Location |

  Given 'Description of work' should not be completed
   When I click 'Description of work'
    And I answer all summary questions with:
      | field                 | value       | expected_summary_table_value |
      | startDate-day         | 9           | Wednesday 9                    |
      | startDate-month       | 9           | September                    |
      | startDate-year        | 2020        | 2020                         |
    And I click 'Return to overview'
   Then 'Description of work' should be completed

  Given 'Shortlist and evaluation process' should not be completed
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 5     |
      | priceWeighting     | 85    |
    And I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be completed

  Given 'Describe question and answer session' should not be completed
   When I click 'Describe question and answer session'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Describe question and answer session' should be completed

   When I click 'Preview your requirements'
   Then I am on the 'Preview your requirements' page
    And I see the 'Return to overview' link
    And I see '0 SME, 0 large' text in the desktop preview panel
    And I see 'Wednesday 9 September 2020' text in the desktop preview panel
    And I see 'Cultural fit 5%' text in the desktop preview panel
    And I click 'Confirm your requirements and publish'
   Then I am on the 'Publish your requirements and evaluation criteria' page
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Publish your requirements' link


Scenario: Create user research participants
  Given I am logged in as a buyer user
    And I have created user research participants requirement
   Then I complete the following tasks:
      | task_name |
      | Location |

  Given 'Description of work' should not be completed
   When I click 'Description of work'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Description of work' should be completed

  Given 'Shortlist and evaluation process' should not be completed
   When I click 'Shortlist and evaluation process'
    And I answer all summary questions with:
      | field              | value |
      | numberOfSuppliers  | 5     |
      | technicalWeighting | 10    |
      | culturalWeighting  | 10    |
      | priceWeighting     | 80    |
    And I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be completed

  Given 'Describe question and answer session' should not be completed
   When I click 'Describe question and answer session'
    And I answer all summary questions
    And I click 'Return to overview'
   Then 'Describe question and answer session' should be completed

   When I click 'Preview your requirements'
   Then I am on the 'Preview your requirements' page
    And I see the 'Return to overview' link
    And I see 'Deadline for asking questions' text in the desktop preview panel
    And I see 'View question and answer session details' text in the desktop preview panel
    And I see 'Price 80%' text in the desktop preview panel
    And I click 'Confirm your requirements and publish'
   Then I am on the 'Publish your requirements and evaluation criteria' page
    And I click 'Publish requirements'

  Then I don't see the 'Title' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Publish your requirements' link


@copy-requirements
Scenario Outline: Copy requirements
  Given I have the latest live digital-outcomes-and-specialists framework
  And I have a buyer user
  And that buyer is logged in
  And I have a <status> digital-specialists brief
  And I click the 'View your account' link
  And I click the 'View your requirements' link
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
  Given I have the latest live digital-outcomes-and-specialists framework
  And I have a buyer user
  And that buyer is logged in
  And I have a <status> digital-specialists brief
  When I click 'View your account'
  And I click 'View your requirements'
  And I see 'Tea drinker' in the '<table heading>' summary table

  Examples:
    | status    | table heading            |
    | live      | Published requirements   |
    | withdrawn | Closed requirements      |
    | draft     | Unpublished requirements |


Scenario: Delete a draft requirement
  Given I am logged in as the buyer of a draft brief
  And I go to that brief overview page
  
  Then I see the 'Delete draft requirements' link
  And I click 'Delete draft requirements'
  Then I am on the 'Are you sure you want to delete these requirements?' page
  Then I see the 'Yes, delete' button
  And I click 'Yes, delete'
  Then I am on the 'Your requirements' page
  And I see a success flash message containing 'were deleted'


Scenario: Cancel a delete draft requirement request
  Given I am logged in as the buyer of a draft brief
  And I go to that brief overview page
  
  Then I see the 'Delete draft requirements' link
  And I click 'Delete draft requirements'
  Then I am on the 'Are you sure you want to delete these requirements?' page
  Then I see the 'Cancel' link
  And I click 'Cancel'
  Then I am on that brief overview page


Scenario: Withdraw live requirements
  Given I am logged in as the buyer of a live brief

  When I click the 'View your account' link
  And I click the 'View your requirements' link
  Then I see that the 'Published requirements' summary table has 1 or more entries

  When I go to that brief overview page
  Then I see the 'Withdraw requirements' link
  And I click 'Withdraw requirements'
  Then I am on the 'Are you sure you want to withdraw these requirements?' page
  Then I see the 'Withdraw requirements' button
  And I click 'Withdraw requirements'
  Then I am on the 'Your requirements' page
  Then I see a success flash message containing 'withdrawn your requirements'


Scenario: Cancel a withdraw draft requirement request
  Given I am logged in as the buyer of a live brief
  And I go to that brief overview page
  
  Then I see the 'Withdraw requirements' link
  And I click 'Withdraw requirements'
  Then I am on the 'Are you sure you want to withdraw these requirements?' page
  Then I see the 'Cancel' link
  And I click 'Cancel'
  Then I am on that brief overview page


Scenario: Edit a draft requirement
  Given I am logged in as a buyer user
  And I have created an individual specialist requirement
  When I click 'Title'
  Then I am on the 'What you want to call your requirements' page
  When I enter 'Green Tea Drinker' in the 'input-title' field and click its associated 'Save and continue' button
  Then I am on the 'Green Tea Drinker' page


Scenario: There is no 'Publish requirements' link for an incomplete requirement draft
  Given I am logged in as a buyer user
  And I have created an individual specialist requirement
  Then I don't see the 'Publish requirements' link

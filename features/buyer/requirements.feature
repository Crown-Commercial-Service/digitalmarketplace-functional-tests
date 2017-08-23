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


Scenario: Ensure we can log in as a buyer with a closed brief
  Given I am logged in as the buyer of a closed brief with responses
  When I click the 'View your account' link
  Then I see that the 'Closed requirements' summary table has 1 or more entries


Scenario: Award a requirement to a winning supplier
  Given I am logged in as the buyer of a closed brief with responses
  When I click the 'View your account' link
  Then I see the 'Tell us who won this contract' link
  When I click a link with class name 'award-contract-link'
  Then I am on the 'Who won' page
  When I choose a random 'brief_response' radio button
  When I click the 'Save and continue' button
  Then I am on the 'Tell us about your contract' page
  When I enter '1' in the 'input-awardedContractStartDate-day' field
  When I enter '1' in the 'input-awardedContractStartDate-month' field
  When I enter '2020' in the 'input-awardedContractStartDate-year' field
  When I enter '20000.00' in the 'input-awardedContractValue' field
  When I click the 'Submit' button
  And I see a success banner message containing 'updated'

  When I go to that brief overview page
  Then I see the 'View and shortlist suppliers' link

  When I go to that brief page
  Then I see a temporary-message banner message containing 'Awarded to'
  And I see a temporary-message banner message containing 'Start date: Wednesday 1 January 2020'
  And I see a temporary-message banner message containing 'Value: £20,000'
  And I see a temporary-message banner message containing 'Company size'

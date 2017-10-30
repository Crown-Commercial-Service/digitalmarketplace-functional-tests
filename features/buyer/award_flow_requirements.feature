@awardflow
Feature: Award Flow
  Award a brief to a supplier using the award flow accessible from the buyer dash


Background:
  Given I am logged in as the buyer of a closed brief with responses

  When I click the 'View your account' link
  And I click the 'View your requirements' link
  Then I see that the 'Closed requirements' summary table has 1 or more entries

  When I click the 'Let suppliers know the outcome' link for that brief
  Then I am on the 'Have you awarded a contract for %s?' page with brief 'title'


Scenario: Award flow - Award a requirement to a winning supplier

  Given I choose 'Yes' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Who won' page

  When I choose a random 'brief_response' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Tell us about your contract' page

  When I enter '1' in the 'input-awardedContractStartDate-day' field
  And I enter '1' in the 'input-awardedContractStartDate-month' field
  And I enter '2020' in the 'input-awardedContractStartDate-year' field
  And I enter '20000.00' in the 'input-awardedContractValue' field
  And I click the 'Submit' button
  Then I see a success banner message containing 'updated'

  When I go to that brief overview page
  Then I see the 'View suppliers who applied' link

  When I go to that brief page
  Then I see a temporary-message banner message containing 'Awarded to'
  And I see a temporary-message banner message containing 'Start date: Wednesday 1 January 2020'
  And I see a temporary-message banner message containing 'Value: £20,000'
  And I see a temporary-message banner message containing 'Company size'


@skip-local @skip-preview
Scenario: Award Flow - Cancel a requirement

  Given I choose 'No' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Why didn't you award a contract for %s?' page with brief 'title'

  When I choose 'The requirement has been cancelled' radio button
  And I click the 'Update requirement' button
  Then I am on the '%s' page with brief 'title'
  And I see a success banner message containing 'updated'

  When I go to that brief page
  Then I see a temporary-message banner message containing 'This opportunity was cancelled'
  And I see a temporary-message banner message containing 'The buyer cancelled this opportunity, for example because they no longer '
  And I see a temporary-message banner message containing 'have the budget. They may publish an updated version later.'


@skip-staging
Scenario: Award Flow - Cancel requirements

  Given I choose 'No' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Why didn't you award a contract for %s?' page with brief 'title'

  When I choose 'Your requirements have been cancelled' radio button
  And I click the 'Update requirements' button
  Then I am on the '%s' page with brief 'title'
  And I see a success banner message containing 'updated'

  When I go to that brief page
  Then I see a temporary-message banner message containing 'This opportunity was cancelled'
  And I see a temporary-message banner message containing 'The buyer cancelled this opportunity, for example because they no longer '
  And I see a temporary-message banner message containing 'have the budget. They may publish an updated version later.'


@skip-local @skip-preview
Scenario: Award flow - Mark a requirement unsuccessful

  Given I choose 'No' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Why didn't you award a contract for %s?' page with brief 'title'

  When I choose 'There were no suitable suppliers' radio button
  And I click the 'Update requirement' button
  Then I am on the '%s' page with brief 'title'
  And I see a success banner message containing 'updated'

  When I go to that brief page
  Then I see a temporary-message banner message containing 'No suitable suppliers applied'
  And I see a temporary-message banner message containing 'The buyer didn't award this contract because no suppliers met their '
  And I see a temporary-message banner message containing 'requirements. They may publish an updated version later.'


@skip-staging
Scenario: Award flow - Mark requirements as unsuccessful

  Given I choose 'No' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Why didn't you award a contract for %s?' page with brief 'title'

  When I choose 'There were no suitable suppliers' radio button
  And I click the 'Update requirements' button
  Then I am on the '%s' page with brief 'title'
  And I see a success banner message containing 'updated'

  When I go to that brief page
  Then I see a temporary-message banner message containing 'No suitable suppliers applied'
  And I see a temporary-message banner message containing 'The buyer didn't award this contract because no suppliers met their '
  And I see a temporary-message banner message containing 'requirements. They may publish an updated version later.'


Scenario: Award flow - Abort flow as still evaluating

  Given I choose 'We are still evaluating suppliers' radio button
  And I click the 'Save and continue' button
  Then I am on the 'Your requirements' page
  And I see a success banner message containing 'updated'

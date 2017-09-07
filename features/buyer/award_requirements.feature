@award
Feature: Award a requirement
  In order to ensure the procurement process is fair and transparent
  As a buyer within government
  I want to be able to publish the result of my procurement process

@skip-local @skip-preview
Scenario: Award a requirement to a winning supplier
  Given I am logged in as the buyer of a closed brief with responses

  When I click the 'View your account' link
  Then I see that the 'Closed requirements' summary table has 1 or more entries

  When I click the 'Tell us who won this contract' link for that brief
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
  Then I see the 'View and shortlist suppliers' link

  When I go to that brief page
  Then I see a temporary-message banner message containing 'Awarded to'
  And I see a temporary-message banner message containing 'Start date: Wednesday 1 January 2020'
  And I see a temporary-message banner message containing 'Value: £20,000'
  And I see a temporary-message banner message containing 'Company size'

@skip-staging @skip-production
Scenario: Award a requirement to a winning supplier
  Given I am logged in as the buyer of a closed brief with responses

  When I click the 'View your account' link
  And I click the 'View your requirements' link
  Then I see that the 'Closed requirements' summary table has 1 or more entries

  When I click the 'Tell us who won this contract' link for that brief
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

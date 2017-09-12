@cancel
Feature: Cancel a requirement
  In order to ensure the procurement process is fair and transparent
  As a buyer within government
  I want to be able to publish the result of my procurement process


@skip-staging
Scenario: Cancel a requirement
  Given I am logged in as the buyer of a closed brief

  When I click the 'View your account' link
  And I click the 'View your requirements' link
  Then I see that the 'Closed requirements' summary table has 1 or more entries

  When I go to that brief overview page
  Then I see the 'Cancel requirement' link

  When I click the 'Cancel requirement' link
  Then I am on the 'Why do you need to cancel' page

  When I choose the 'The requirement has been cancelled' radio button
  And I click the 'Update requirement' button
  Then I see 'The contract was not awarded' text on the page
  Then I see 'the requirement was cancelled.' text on the page
  And I see a success banner message containing 'updated'
  And I see the 'View suppliers who applied' link

  When I go to that brief page
  Then I see a temporary-message banner message containing 'This opportunity was cancelled'
  And I see a temporary-message banner message containing 'The buyer cancelled this opportunity,'
  And I see a temporary-message banner message containing 'for example because they no longer have the budget.'
  And I see a temporary-message banner message containing 'They may publish an updated version later.'

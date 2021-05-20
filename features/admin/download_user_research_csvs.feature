@admin @download-user-research-participants
Feature: Download user research participants

@file-download @skip-local
Scenario Outline: Correct users can access the page to download supplier user research participants
  Given I am logged in as the existing <role> user
  And I click the 'Download potential user research participants (suppliers)' link
  Then I am on the 'Download lists of potential user research participants' page
  When I click a link with text containing 'User research participants on'
  Then I should get a download file with filename ending '.csv' and content-type 'text/csv'

  Examples:
    | role                    |
    | admin-framework-manager |

@direct-award
Feature: Direct Award flows
  
Scenario: Unauthenticated user can save a search after logging in
  Given I have a production buyer user
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  Then I am on the 'Choose where to save your search' page
  And I choose the 'Create a new saved search' radio button
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User can save a search
  Given I am logged in as a buyer user
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User with saved searches completes new saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I choose the 'Create a new saved search' radio button
  And I enter 'my cloud project2' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project2' page

Scenario: User updates existing saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project - exiting'
  And I am on the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I choose the 'my cloud project - exiting' radio button
  And I click 'Save and continue'
  Then I am on the 'my cloud project - exiting' page

Scenario: User edits existing search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I am on the /buyers page
  Then I click the 'View your saved searches' link
  Then I click the 'my cloud project' link
  Then I am on the 'my cloud project' page
  And I click the 'Edit search' link
  Then I am on the 'Search results' page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I choose the 'my cloud project' radio button
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User ends search and downloads results
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I am on the /buyers page
  Then I click the 'View your saved searches' link
  Then I click the 'my cloud project' link
  Then I am on the 'my cloud project' page
  And I click the 'End search' link
  Then I am on the 'End your search' page
  And I click the 'End search and continue' button
  Then I am on the 'my cloud project' page
  And I click the 'Download search results' link
  And I am on the 'Download your search results' page
  And I click the 'Download search results as a spreadsheet' link
  And I should get a download file of type 'ods'
  And I click the 'Return to overview' link
  Then I am on the 'my cloud project' page
  And I click the 'Download your results again.' link
  And I am on the 'Download your search results' page
  And I click the 'Download search results as comma-separated values' link
  And I should get a download file of type 'csv'
 

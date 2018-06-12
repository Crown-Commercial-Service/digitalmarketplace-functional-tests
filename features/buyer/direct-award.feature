@direct-award
Feature: Direct Award flows

Scenario: Unauthenticated user can save a search after logging in
  Given I have a production buyer user
  And I visit the /g-cloud/search page
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
  And I visit the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User with saved searches completes new saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I visit the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I choose the 'Create a new saved search' radio button
  And I enter 'my cloud project2' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project2' page

Scenario: User updates existing saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project - exiting'
  And I visit the /g-cloud/search page
  And I click 'Save search'
  Then I am on the 'Choose where to save your search' page
  And I choose the 'my cloud project - exiting' radio button
  And I click 'Save and continue'
  Then I am on the 'my cloud project - exiting' page

Scenario: User edits existing search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I visit the /buyers page
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
  And I visit the /buyers page
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


Scenario: User awards contract
  Given I am logged in as a buyer user
  When I have created and ended a search called 'my cloud project'
  And I click on the 'Tell us your outcome' link
  And I award the contract to 'Supplier X'
  And I am on the 'my cloud project' page
  Then I see "You've updated 'my cloud project'"
  And I see 'Contract awarded to Supplier X: Service Y'

Scenario: User does not award contract as work is cancelled
  Given I am logged in as a buyer user
  When I have created and ended a search called 'my cloud project'
  And I click on the 'Tell us your outcome' link
  And I do not award the contract because the work is cancelled
  And I am on the 'my cloud project' page
  Then I see "You've updated 'my cloud project'"
  And I see 'The work has been cancelled'

Scenario: User does not award contract as there are no suitable services
  Given I am logged in as a buyer user
  When I have created and ended a search called 'my cloud project'
  And I click on the 'Tell us your outcome' link
  And I do not award the contract because there are no suitable services
  And I am on the 'my cloud project' page
  Then I see "You've updated 'my cloud project'"
  And I see 'No suitable services found'

Scenario: User is still assessing services
  Given I am logged in as a buyer user
  When I have created and ended a search called 'my cloud project'
  And I click on the 'Tell us your outcome' link
  And I choose the 'Still assessing' radio button
  And I click "Save and Continue"
  And I am on the 'my cloud project' page
  Then I see "You've updated 'my cloud project'"
  And I see 'No suitable services found'

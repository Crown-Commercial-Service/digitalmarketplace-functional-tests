@buyer @direct-award
Feature: Direct Award flows

Scenario: Unauthenticated user can save a search after logging in
  Given I have an existing buyer user
  And I visit the /g-cloud/search page
  And I click 'Save your search'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  Then I am on the 'Save your search' page
  And I choose the 'Save a new search' radio button
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User can save a search
  Given I am logged in as a buyer user
  And I visit the /g-cloud/search page
  And I click 'Save your search'
  Then I am on the 'Save your search' page
  And I enter 'my cloud project' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User with saved searches completes new saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I visit the /g-cloud/search page
  And I click 'Save your search'
  Then I am on the 'Save your search' page
  And I choose the 'Save a new search' radio button
  And I enter 'my cloud project2' in the 'Name your search' field
  And I click 'Save and continue'
  Then I am on the 'my cloud project2' page

Scenario: User updates existing saved search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project - existing'
  And I visit the /g-cloud/search page
  And I click 'Save your search'
  Then I am on the 'Save your search' page
  And I choose the 'my cloud project - existing' radio button
  And I click 'Save and continue'
  Then I am on the 'my cloud project - existing' page

Scenario: User edits existing search
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I visit the /buyers page
  Then I click the 'View your saved searches' link
  Then I click the 'my cloud project' link
  Then I am on the 'my cloud project' page
  And I click the 'Edit your search and view results' link
  Then I am on the 'Search results' page
  And I click 'Save your search'
  Then I am on the 'Save your search' page
  And I choose the 'my cloud project' radio button
  And I click 'Save and continue'
  Then I am on the 'my cloud project' page

Scenario: User exports results
  Given I am logged in as a buyer user
  And I have created and saved a search called 'export limit test project'
  And I visit the /buyers page
  When I click the 'View your saved searches' link
  And I click the 'export limit test project' link
  Then I am on the 'export limit test project' page
  And I see the 'Export your results' instruction list item has a warning message of 'You have too many services to assess. Refine your search until you have no more than 30 results.'
  And I see the 'Export your results' instruction list item status showing as 'Can’t start yet'
  When I visit the /g-cloud/search?q=cloud+software+nhs&lot=cloud-hosting page
  And I click 'Save your search'
  Then I am on the 'Save your search' page
  And I choose the 'export limit test project' radio button
  And I click 'Save and continue'
  And I see the 'Save a search' instruction list item status showing as 'Completed'
  When I click the 'Export your results' link
  Then I am on the 'Before you export your results' page
  When I check 'I understand that I cannot edit my search after I export my results' checkbox
  And I click the 'Export results and continue' button
  Then I am on the 'Download your results' page
  And I see a success flash message containing 'Results exported. Your files are ready to download.'
  When I click the 'Return to your task list' link
  Then I see the 'Export your results' instruction list item status showing as 'Completed'

@file-download
Scenario: User download results
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I have exported my results for the 'my cloud project' saved search
  Then I am on the 'Download your results' page
  When I click the 'Download search results as a spreadsheet' link
  Then I should get a download file with filename ending '.ods' and content type 'application/vnd.oasis.opendocument.spreadsheet'
  When I click the 'Return to your task list' link
  Then I am on the 'my cloud project' page
  When I click the 'Download your results' link
  Then I am on the 'Download your results' page
  When I click the 'Download search results as comma-separated values' link
  Then I should get a download file with filename ending '.csv' and content type 'text/csv; header=present; charset=utf-8'

@file-download
Scenario: User downloads results - via the saved searches dashboard
  Given I am logged in as a buyer user
  And I am ready to tell the outcome for the 'my cloud project' saved search
  When I visit the /buyers/direct-award/g-cloud page
  And I click the 'Download results' link
  Then I am on the 'Download your results' page
  When I click the 'Download search results as a spreadsheet' link
  Then I should get a download file with filename ending '.ods' and content type 'application/vnd.oasis.opendocument.spreadsheet'

Scenario: User confirms understanding how to assess services
  Given I am logged in as a buyer user
  And I have created and saved a search called 'my cloud project'
  And I have exported my results for the 'my cloud project' saved search
  And I click the 'Return to your task list' link
  Then I see the 'Export your results' instruction list item status showing as 'Completed'
  And I see the 'Award a contract' instruction list item status showing as 'Can’t start yet'
  When I click the 'Confirm you have read and understood how to assess services' button
  Then I am on the 'my cloud project' page
  And I see a success flash message containing 'You’ve confirmed that you have read and understood how to assess services.'
  And I see the 'Start assessing services' instruction list item status showing as 'Completed'

Scenario: User awards contract
  Given I am logged in as a buyer user
  And I am ready to tell the outcome for the 'my cloud project' saved search
  When I click the 'Tell us the outcome' link
  And I award the contract for the 'my cloud project' search
  And I am on the 'my cloud project' page
  Then I see a success flash message containing 'You’ve updated ‘my cloud project’'
  And I see the 'Award a contract' instruction list item status showing as 'Contract awarded'

Scenario: User does not award contract as work is cancelled
  Given I am logged in as a buyer user
  And I am ready to tell the outcome for the 'my cloud project' saved search
  When I click the 'Tell us the outcome' link
  And I do not award the contract because 'The work has been cancelled'
  And I am on the 'my cloud project' page
  Then I see a success flash message containing 'You’ve updated ‘my cloud project’'
  And I see the 'Award a contract' instruction list item status showing as 'The work has been cancelled'

Scenario: User does not award contract as there are no suitable services
  Given I am logged in as a buyer user
  And I am ready to tell the outcome for the 'my cloud project' saved search
  When I click the 'Tell us the outcome' link
  And I do not award the contract because 'There were no suitable services'
  And I am on the 'my cloud project' page
  Then I see a success flash message containing 'You’ve updated ‘my cloud project’'
  And I see the 'Award a contract' instruction list item status showing as 'No suitable services found'

@file-download
Scenario: User is still assessing services - via the saved searches dashboard
  Given I am logged in as a buyer user
  And I am ready to tell the outcome for the 'my cloud project' saved search
  And I have downloaded the search results as a file of type 'csv'
  When I visit the /buyers/direct-award/g-cloud page
  When I click the 'Tell us the outcome' link
  And I choose the 'We are still assessing services' radio button
  And I click 'Save and continue'
  And I am on the 'my cloud project' page
  Then I see the 'Tell us the outcome' link

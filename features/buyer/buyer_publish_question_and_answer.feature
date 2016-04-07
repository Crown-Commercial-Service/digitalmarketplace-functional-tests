@not-production @functional-test
Feature: Buyer publishes question and answer

Background: Create buyer user account and login to DM
  Given I have a buyer user account

Scenario: Test setup
  Given I have deleted all draft buyer requirements
  And I have test suppliers
  And The test suppliers have users
  And Test supplier users are active

Scenario: Buyer answers a couple of clarification questions and publishes each one in turn
  Given I have logged in to Digital Marketplace as a 'Buyer' user
  And A published 'Find an individual specialist' buyer requirements with the name 'Individual Specialist-Buyer Requirements' exists and I am on the "Overview of work" page
  When I click the 'Answer a clarification question' link
  Then I am taken to the 'Answer a clarification question' page

  When I enter 'This is the first clarification question. What else can I put in here?' in the 'question' field
  Then I enter 'You can put any queries about this opportunity here and we will answer it the best we can.' in the 'answer' field
  And I click the 'Publish clarification question' button
  Then I am taken back to the "Overview of work" page with the first question and answer listed under "Clarification questions"

  When I click the 'Answer a clarification question' link
  Then I am taken to the 'Answer a clarification question' page

  When I enter 'This is the second clarification question. What is the cost?' in the 'question' field
  Then I enter 'The price is as stated in the brief, which is £123/hr' in the 'answer' field
  And I click the 'Publish clarification question' button
  Then I am taken back to the "Overview of work" page with the second question and answer listed under "Clarification questions"

Scenario: Supplier/Public can view questions and answers to an opportunity
  Given I have logged in to Digital Marketplace as a 'Supplier' user
  And I am on the 'Digital Marketplace' landing page
  And I click the 'View supplier opportunities' link
  Then I am taken to the list of "Supplier opportunities" page

  When I click on the link to the opportunity I have posted a question for
  Then I am on the details page for the selected opportunity
  And I can see all questions and answers related to the opportunity

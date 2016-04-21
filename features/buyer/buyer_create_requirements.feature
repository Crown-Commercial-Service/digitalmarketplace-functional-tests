@not-production @functional-test @write-brief
Feature: Buyer create buyer requirements

Background: Login to Digital Marketplace as the newly created buyer
  Given I have a buyer user account
  And I have logged in to Digital Marketplace as a 'Buyer' user

Scenario: Test setup
  Given I have deleted all draft buyer requirements

Scenario: Start creating buyer requirements for an individual specialist
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find an individual specialist' link
  Then I am taken to the buyers 'Find an individual specialist' page

  When I click the 'Create requirement' button
  Then I am taken to the 'What you want to call your requirements' page

  When I enter 'Find an individual specialist' in the 'title' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'location' link
  Then I am taken to the 'Where you want the specialist to work' page

  When I choose 'North East England' for 'location'
  And I click 'Save and continue'
  Then I am taken to the 'Find an individual specialist' requirements overview page

Scenario: Newly created buyer requirements should be listed on the buyer's dashboard
  Given I navigate directly to the page '/buyers'
  Then The buyer requirements for 'Find an individual specialist' 'is' listed on the buyer's dashboard

Scenario: Verify form values for information that has been provided so far
  Given I am on the 'Find an individual specialist' requirements overview page

  When I click the 'location' link
  Then I am taken to the 'Where you want the specialist to work' page
  And Form field 'location' should contain 'North East England'

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'title' link
  Then I am taken to the 'What you want to call your requirements' page
  And Form field 'title' should contain 'Find an individual specialist'

Scenario: Fill out requirement section question
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'description of work' link
  Then I am taken to the 'Description of work' page
  When I click the 'Add organisation' link

  When I enter 'GDS' in the 'organisation' field
  And I click 'Save and continue'
  Then I am taken to the 'Description of work' page
  Then Summary row 'Organisation the work is for' should contain 'GDS'

Scenario: "Ready to publish" button should not exist yet
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'Review and publish your requirements' link
  Then I am taken to the 'Publish your requirements and evaluation criteria' page
  And The 'Publish Requirements' button is 'not' available

Scenario: Complete all mandatory buyer requirements questions
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'specialist role' link
  Then I am taken to the 'Type of specialist you need' page

  When I choose 'Quality assurance analyst' for 'specialistRole'
  And I click 'Save and continue'
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'description of work' link
  Then I am taken to the 'Description of work' page

  When I click the 'Add responsibilities' link
  Then I am taken to the 'What the specialist will work on' page
  When I enter 'Specialist will work on the Digital Marketplace' in the 'specialistWork' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Describe existing team' link
  Then I am taken to the 'Who the specialist will work with' page
  When I enter 'Specialist will work with the Digital Marketplace team' in the 'existingTeam' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Describe where the supplier will work' link
  Then I am taken to the 'Address where the work will take place' page
  When I enter 'Aviation House' in the 'workplaceAddress' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Describe working arrangements' link
  Then I am taken to the 'Working arrangements' page
  When I enter 'Work from home' in the 'workingArrangements' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Set expected start date' link
  Then I am taken to the 'Expected start date' page
  When I enter '25/04/2016' in the 'startDate' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Provide a summary of the work' link
  Then I am taken to the 'Summary' page
  When I enter 'Make this work' in the 'summary' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'shortlist criteria' link
  Then I am taken to the 'Shortlist criteria' page

  When I click the 'Add essential skills or experience' link
  Then I am taken to the 'Essential skills and experience' page
  When I enter 'Write functional tests' in the 'input-essentialRequirements-1' field
  Then I enter 'Work with ruby' in the 'input-essentialRequirements-2' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Shortlist criteria' page

  When I click the 'Set number of suppliers to evaluate' link
  Then I am taken to the 'How many specialists will be evaluated' page
  When I enter '5' in the 'numberOfSuppliers' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Shortlist criteria' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'evaluation criteria' link
  Then I am taken to the 'Evaluation criteria' page

  When I click the 'Set weighting' link
  Then I am taken to the 'Weighting' page
  When I enter '75' in the 'technicalWeighting' field
  When I enter '5' in the 'culturalWeighting' field
  When I enter '20' in the 'priceWeighting' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Evaluation criteria' page

  When I click the 'Choose cultural fit criteria' link
  Then I am taken to the 'Cultural fit evaluation criteria' page
  When I enter 'Main cultural fit criteria' in the 'input-culturalFitCriteria-1' field
  When I enter 'Additional cultural fit criteria' in the 'input-culturalFitCriteria-2' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Evaluation criteria' page

  When I click the 'Choose assessment method' link
  Then I am taken to the 'How you’ll assess the specialists' page
  When I choose 'Interview' for 'evaluationType'
  And I click the 'Save and continue' button
  Then I am taken to the 'Evaluation criteria' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

Scenario: Verify sections on the overview page are ticked
  Given I am on the 'Find an individual specialist' requirements overview page
  Then 'title' section is marked as complete
  Then 'specialist role' section is marked as complete
  Then 'location' section is marked as complete

  When I click the 'description of work' link
  Then I am taken to the 'Description of work' page
  And Summary row 'Organisation the work is for' should contain 'GDS'
  And Summary row 'What the specialist will work on' should contain 'Specialist will work on the Digital Marketplace'
  And Summary row 'Who the specialist will work with' should contain 'Specialist will work with the Digital Marketplace team'
  And Summary row 'Address where the work will take place' should contain 'Aviation House'
  And Summary row 'Working arrangement' should contain 'Work from home'
  And Summary row 'Expected start date' should contain '25/04/2016'
  And Summary row 'Summary' should contain 'Make this work'

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page
  And 'description of work' section is marked as complete

  When I click the 'shortlist criteria' link
  Then I am taken to the 'Shortlist criteria' page
  And Summary row 'Essential skills and experience' should contain 'Write functional tests'
  And Summary row 'Essential skills and experience' should contain 'Work with ruby'
  And Summary row 'How many specialists will be evaluated' should contain '5'

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page
  Then 'shortlist criteria' section is marked as complete

  When I click the 'evaluation criteria' link
  Then I am taken to the 'Evaluation criteria' page
  And Summary row 'Weighting' should contain 'Technical competence 75% Cultural fit 5% Price 20%'
  And Summary row 'Cultural fit criteria' should contain 'Main cultural fit criteria'
  And Summary row 'Cultural fit criteria' should contain 'Additional cultural fit criteria'
  And Summary row 'Assessment methods' should contain 'Interview'

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page
  Then 'evaluation criteria' section is marked as complete

Scenario: Complete all optional requirements questions
  Given I am on the 'Find an individual specialist' requirements overview page

  When I click the 'description of work' link
  Then I am taken to the 'Description of work' page

  When I click the 'Add security clearance' link
  Then I am taken to the 'Security clearance' page
  When I enter 'SC' in the 'securityClearance' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Set expected contract length' link
  Then I am taken to the 'Expected contract length' page
  When I enter '1 year' in the 'contractLength' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Add terms and conditions' link
  Then I am taken to the 'Additional terms and conditions' page
  When I enter 'Some terms and conditions' in the 'additionalTerms' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Add maximum day rate' link
  Then I am taken to the 'Maximum day rate' page
  When I enter '10000' in the 'budgetRange' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Description of work' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'shortlist criteria' link
  Then I am taken to the 'Shortlist criteria' page

  When I click the 'Add nice-to-have skills and experience' link
  Then I am taken to the 'Nice-to-have skills and experience' page
  When I enter 'Nice-to-have requirement' in the 'input-niceToHaveRequirements-1' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Shortlist criteria' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

  When I click the 'Describe question and answer session' link
  Then I am taken to the 'Describe question and answer session' page

  When I click the 'Add details' link
  Then I am taken to the 'Question and answer session details' page
  When I enter 'Something about a webinar' in the 'questionAndAnswerSessionDetails' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Describe question and answer session' page

  When I click the 'Return to overview' link
  Then I am taken to the 'Find an individual specialist' requirements overview page

Scenario: Check the requirement is listed on the buyer dashboard
  Given I navigate directly to the page '/buyers'
  Then The buyer requirements for 'Find an individual specialist' 'is' listed on the buyer's dashboard

Scenario: Edit Requirements title and verify the change made, on the summary page (Mandatory requirement)
  Given I am on the 'Find an individual specialist' requirements overview page

  When I click the 'title' link
  Then I am taken to the 'What you want to call your requirements' page
  When I change 'title' to 'Find an individual specialist-edited'
  And I click 'Save and continue'
  Then I am taken to the 'Find an individual specialist-edited' requirements overview page

Scenario: Publish requirements button is visible
  Given I am on the 'Find an individual specialist' requirements overview page
  When I click the 'Review and publish your requirements' link

  Then I am taken to the 'Publish your requirements and evaluation criteria' page
  And The 'Publish Requirements' button is 'made' available

Scenario: Created buyer requirements can be deleted
  Given A draft 'Find an individual specialist' buyer requirements with the name 'Buyer Requirements to be deleted' exists and I am on the "Overview of work" page
  When I click 'Delete'
  Then I am presented with the message 'Are you sure you want to delete these requirements?'

  When I click 'Yes, delete'
  Then I am presented with the 'DM Functional Test Buyer User 1' 'Buyer' dashboard page
  And I am presented with the message 'Your requirements ‘Buyer Requirements to be deleted’ were deleted'
  And The buyer requirements for 'Buyer Requirements to be deleted' 'is not' listed on the buyer's dashboard

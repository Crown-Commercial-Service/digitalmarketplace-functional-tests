@not-production @functional-test
Feature: Buyer create briefs

Background: Login to Digital Marketplace as the newly created buyer
  Given I have a buyer user account
  When I have logged in to Digital Marketplace as a 'Buyer' user

Scenario: Start brief creation for an individual specialist
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find an individual specialist' link
  Then I am taken to the buyers 'Find an individual specialist' page

  When I click the 'Choose specialist role' button
  Then I am taken to the 'Requirements title' page

  When I enter 'Find an individual specialist brief' in the 'title' field
  And I click the 'Save and continue' button
  Then I am taken to the 'Location' page

  When I choose 'North East England' for 'location'
  And I click 'Save and continue'
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

@wip
Scenario: Newly created brief should be listed on the buyer's dashboard and the count of unanswered questions is correct
  Given I am logged in as 'DM Functional Test Buyer User 1' 'Buyer' user and am on the dashboard page
  Then The buyer brief 'Find an individual specialist brief' 'is' listed on the buyer's dashboard

Scenario: Verify text on summary page for information that has been provided so far. "Ready to publish" button should not exist
  Given I am on the "Overview of work" page for the buyer brief
  Then Summary row 'Requirements title' should contain 'Find an individual specialist brief'
  And Summary row 'Location' should contain 'North East England'
  And The 'Ready to publish' button is 'not' available

Scenario: Complete all mandatory requirements questions. "Ready to publish" is only available on completing all mandatory requirement questions
  Given I am on the "Overview of work" page for the buyer brief
  When I click the 'Choose specialist role' link for 'Specialist role'
  Then I am taken to the 'Specialist role' page

  When I choose 'Quality assurance analyst' for 'specialistRole'
  And I click 'Save and continue'
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'
  And The 'Ready to publish' button is 'not' available

  When I click the 'Add organisation' link for 'Your organisation'
  Then I am taken to the 'Your organisation' page

  When I enter 'Organisation-Digital Marketplace Team' in the 'organisation' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add description' link for 'Background information'
  Then I am taken to the 'Background information' page

  When I fill in 'backgroundInformation' with:
    """
    Background
    information
    for
    Digital Marketplace Team
    """
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Set date' link for 'Start date'
  Then I am taken to the 'Start date' page

  When I enter '01/01/2020' in the 'startDate' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Set contract length' link for 'Contract length'
  Then I am taken to the 'Contract length' page

  When I enter '24 months' in the 'contractLength' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add description' link for 'Important dates'
  Then I am taken to the 'mportant dates' page

  When I enter '21/05/2021' in the 'importantDates' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add essential requirements' link for 'Essential requirements'
  Then I am taken to the 'Your requirements' page

  When I enter 'First in list' in the 'input-essentialRequirements-1' field
  Then I add 'Second essential requirement for Digital Marketplace Team' as a 'essentialRequirements'
  And I add 'A third row for essential requirements' as a 'essentialRequirements'

  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'
  And The 'Ready to publish' button is 'not' available

  When I click the 'Choose evaluation types' link for 'Evaluating suppliers'
  Then I am taken to the 'Evaluating suppliers' page

  When I check 'pitch' for 'evaluationType'
  And I check 'provide a written proposal' for 'evaluationType'
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'
  And The 'Ready to publish' button is 'made' available

Scenario: Verify all text on summary page after adding mandatory information
  Given I am on the "Overview of work" page for the buyer brief
  Then Summary row 'Specialist role' should contain 'Quality assurance analyst'
  And Summary row 'Your organisation' should contain 'Organisation-Digital Marketplace Team'
  And Summary row 'Background information' should contain 'Background information for Digital Marketplace Team'
  And Summary row 'Start date' should contain '01/01/2020'
  And Summary row 'Contract length' should contain '24 months'
  And Summary row 'Important dates' should contain '21/05/2021'
  And Summary row 'Essential requirements' should contain 'First in list'
  And Summary row 'Essential requirements' should contain 'Second essential requirement for Digital Marketplace Team'
  And Summary row 'Essential requirements' should contain 'A third row for essential requirements'
  And Summary row 'Evaluating suppliers' should contain 'pitch'
  And Summary row 'Evaluating suppliers' should contain 'provide a written proposal'

@wip
Scenario: Count of unanswered questions should be updated accordingly
  Given I am logged in as 'DM Functional Test Buyer User 1' 'Buyer' user and am on the dashboard page
  Then The buyer brief 'Find an individual specialist brief' 'is' listed on the buyer's dashboard

Scenario: Complete all optional requirements questions
  Given I am on the "Overview of work" page for the buyer brief
  When I click the 'Add description' link for 'Current technologies'
  Then I am taken to the 'Current technologies' page

  When I fill in 'currentTechnologies' with:
    """
    Current technologies for Digital Marketplace Team:
    Java
    SQL
    .net
    """
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add description' link for 'Working arrangements'
  Then I am taken to the 'Working arrangements' page

  When I enter 'Working arrangements for Digital Marketplace Team' in the 'workingArrangements' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add description' link for 'Additional terms and conditions'
  Then I am taken to the 'Working arrangements' page

  When I enter 'Addition terms and conditions for Digital Marketplace Team' in the 'additionalTerms' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

  When I click the 'Add nice-to-have requirements' link for 'Nice-to-have requirements'
  Then I am taken to the 'Your requirements' page

  When I enter 'First nice-to-have requirement for Digital Marketplace Team' in the 'input-niceToHaveRequirements-1' field
  When I enter 'Second nice-to-have requirement for Digital Marketplace Team' in the 'input-niceToHaveRequirements-2' field
  And I click the 'Save and continue' button
  Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief'

Scenario: Verify all text on summary page after adding optional information
  Given I am on the "Overview of work" page for the buyer brief
  Then Summary row 'Current technologies' should contain 'Current technologies for Digital Marketplace Team: Java SQL .net'
  And Summary row 'Working arrangements' should contain 'Working arrangements for Digital Marketplace Team'
  And Summary row 'Additional terms and conditions' should contain 'Addition terms and conditions for Digital Marketplace Team'
  And Summary row 'Nice-to-have requirements' should contain 'First nice-to-have requirement for Digital Marketplace Team'
  And Summary row 'Nice-to-have requirements' should contain 'Second nice-to-have requirement for Digital Marketplace Team'

@wip
Scenario: Edit contents of brief and verify all text on summary page
  Given I am on the "Overview of work" page for the buyer brief
  And There is an Edit link for each of the company information do
  And All the information that was submitted is presented correctly on the page do

Scenario: Created brief can be deleted
  Given A 'Find an individual specialist' brief with the name 'Individual Specialist-Brief deletion test' exists and I am on the "Overview of work" page for that brief
  When I click 'Delete'
  Then I am presented with the message 'Are you sure you want to delete these requirements?'

  When I click 'Yes, delete'
  Then I am presented with the 'DM Functional Test Buyer User 1' 'Buyer' dashboard page
  And I am presented with the message 'Your requirements ‘Individual Specialist-Brief deletion test’ were deleted'
  And The buyer brief 'Individual Specialist brief-Deletion test' 'is not' listed on the buyer's dashboard

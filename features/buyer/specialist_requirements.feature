@requirements
Feature: Create and publish a requirement
  In order to find individuals and teams that can provide the needed services
  As a buyer within government
  I want to be able to create and publish a requirement

Scenario: Create individual specialist requirement
  Given I am logged in as a buyer user
    And I have created an individual specialist requirement
   Then I answer the following questions:
      | question                                        |
      | Specialist role                                 |
      | Location                                        |
      | Set how long your requirements will be open for |
   Then 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer the following summary questions:
      | title                                  | question                              |
      | Organisation the work is for           | Add organisation                      |
      | What the specialist will work on       | Add responsibilities                  |
      | Early market engagement                | Describe early market engagement      |
      | Who the specialist will work with      | Describe existing team                |
      | Address where the work will take place | Describe where the supplier will work |
      | Working arrangements                   | Describe working arrangements         |
      | Security clearance                     | Add security clearance                |
      | Latest start date                      | Set latest start date                 |
      | Expected contract length               | Set expected contract length          |
      | Additional terms and conditions        | Add terms and conditions              |
      | Maximum day rate                       | Add maximum day rate                  |
      | Summary of the work                    | Provide a summary of the work         |
    And I click 'Return to overview'
   Then 'Description of work' should be ticked
   
   Then 'Shortlist and evaluation process' should not be ticked
   When I click 'Shortlist and evaluation process'

    # due to stricter validation this section cant be handled by high level steps...

    When I click 'Edit'
     And I check all 'evaluationType' checkboxes
     And I click 'Save and continue'
    Then I should see 'Work history' in the 'Assessment methods' summary item
     And I should see 'Reference' in the 'Assessment methods' summary item
     And I should see 'Interview' in the 'Assessment methods' summary item
     And I should see 'Scenario or test' in the 'Assessment methods' summary item
     And I should see 'Presentation' in the 'Assessment methods' summary item

    When I click 'Set maximum number of specialists you’ll evaluate'
     And I enter '5' in the 'numberOfSuppliers' field
     And I click 'Save and continue'
    Then I should see '5' in the 'Maximum number of specialists that will be evaluated' summary item

    When I click 'Set evaluation weighting'
     And I enter '10' in the 'technicalWeighting' field
     And I enter '5' in the 'culturalWeighting' field
     And I enter '85' in the 'priceWeighting' field
     And I click 'Save and continue'
    Then I should see '10%' in the 'Evaluation weighting' summary item
     And I should see '5%' in the 'Evaluation weighting' summary item
     And I should see '85%' in the 'Evaluation weighting' summary item

    When I click 'Set technical competence criteria'
     And I enter a random value in the 'input-essentialRequirements-1' field
     And I enter a random value in the 'input-niceToHaveRequirements-1' field
     And I click 'Save and continue'
    Then I should see that fields.input-essentialRequirements-1 in the 'Technical competence criteria' summary item
     And I should see that fields.input-niceToHaveRequirements-1 in the 'Technical competence criteria' summary item

    When I click 'Choose cultural fit criteria'
     And I enter a random value in the 'input-culturalFitCriteria-1' field
     And I click 'Save and continue'
    Then I should see that fields.input-culturalFitCriteria-1 in the 'Cultural fit criteria' summary item

   When I click 'Return to overview'
   Then 'Shortlist and evaluation process' should be ticked

   Then 'Describe question and answer session' should not be ticked
   When I click 'Describe question and answer session'
   And I answer the following summary questions:
     | title                               | question    |
     | Question and answer session details | Add details |
   And I click 'Return to overview'
   Then 'Describe question and answer session' should be ticked

   When I click 'Review and publish your requirements'
    And I click 'Publish requirements'
   
  Then I don't see the 'Title' link
   And I don't see the 'Specialist role' link
   And I don't see the 'Location' link
   And I don't see the 'Description of work' link
   And I don't see the 'Shortlist and evaluation process' link
   And I don't see the 'Set how long your requirements will be open for' link
   And I don't see the 'Describe question and answer session' link
   And I don't see the 'Review and publish your requirements' link

Scenario: Create team to provide an outcome
  Given I am logged in as a buyer user
    And I have created a team to provide an outcome requirement
   Then I answer the following questions:
      | question                                        |
      | Location                                        |
   Then 'Description of work' should not be ticked
   When I click 'Description of work'
    And I answer the following summary questions:
      | title                                      | question                              |
      | Organisation the work is for               | Add organisation                      |
      | Why the work is being done                 | Describe why the work is being done   |
      | Problem to be solved                       | Describe problem                      |
      | Who the users are and what they need to do | Describe the users and their needs    |
      | Current phase                              | Choose phase                          |
      | Existing team                              | Describe existing team                |
      | Address where the work will take place     | Describe where the supplier will work |
      | Working arrangements                       | Describe working arrangements         |
      | Latest start date                          | Set latest start date                 |
      | Summary of the work                        | Provide a summary of the work         |
    And I click 'Return to overview'
   Then 'Description of work' should be ticked




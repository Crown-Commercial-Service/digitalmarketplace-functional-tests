@brief-response
Feature: Supplier applys for a brief

Background:
  Given I have a live brief
  And Do the setup

Scenario: Supplier applys for a brief
  Given I go to that brief page
  And I click 'Apply'
  Then I am on 'Apply for ‘Tea drinker’' page

  Given I am on 'Apply for ‘Tea drinker’' page
  When I click 'Start application'
  Then I am on 'When is the earliest the specialist can start work?' page

  Given I am on 'When is the earliest the specialist can start work?' page
  When I enter '27/12/17' in the 'availability' field
  And I click 'Continue'
  Then I am on the 'What’s the specialist’s day rate?' page

  Given I am on 'What’s the specialist’s day rate?' page
  When I enter '200' in the 'dayRate' field
  And I click 'Continue'
  Then I am on the 'Do you have all the essential skills and experience?' page

  Given I am on 'Do you have all the essential skills and experience?' page
  When I choose 'Yes' radio button
  And I click 'Continue'
  Then I am on the 'Give evidence of the essential skills and experience' page

  Given I am on 'Give evidence of the essential skills and experience' page
  When I enter '200' in the 'evidence-0' field
  And I enter '203' in the 'evidence-1' field
  And I enter '204' in the 'evidence-2' field
  And I enter '205' in the 'evidence-3' field
  And I click 'Continue'
  Then I am on the 'Do you have any of the nice-to-have skills or experience?' page

  Given I am on 'Do you have any of the nice-to-have skills or experience?' page
  And I fill in the nice to have evidence
  And I click 'Continue'
  Then I am on the 'Email address the buyer should use to contact you' page

  Given I am on 'Email address the buyer should use to contact you' page
  And I enter 'example-email@gov.uk' in the 'respondToEmailAddress' field
  Then I am on the 'Your response to ‘Tea drinker’ has been sent' page

  Given I am on the 'Your response to ‘Tea drinker’ has been sent' page
  Then I see the 'Your details' summary table filled with:
    | field                              | value                |
    | Day rate                           | £200                 |
    | Date the specialist can start work | 27/12/17             |
    | Email address                      | example-email@gov.uk |


# Background: (option 1) Set up supplier eligible for brief 
#   Given I have a supplier
#   And that supplier is on all frameworks?
#   And that supplier has services on all lots... (not sure about this one)
#   And I have a supplier user for that supplier

# Background: (option 2) Set up supplier eligible for brief 
#   Given I have a supplier on all frameworks and all lots
#   And I have a supplier user for that supplier

# Background: (option 3) Set up supplier eligible for brief (option 3)
#   Given I have a supplier user on all frameworks and all lots

# Background: (option 4) Set up supplier eligible for brief
#   Given I have a supplier
#   And that supplier is on the 'digital-outcomes-and-specialists' framework
#   And that supplier is ... has lots of services
#   And I have a supplier user for that supplier

# Background: (option 5) Set up supplier eligible for brief
#   Given I have a supplier user who can apply for digital outcomes and specialist briefs

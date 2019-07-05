@supplier @supplier-framework-question
Feature: Supplier asks a framework question

@notify
Scenario: Supplier asks a clarification question
  Given there is a framework that is open for applications with clarification questions open
  And I have a supplier user
  And that supplier has applied to be on that framework
  And that supplier has confirmed their company details for that application
  And that supplier is logged in
  When I visit the /suppliers page
  And I click the 'Continue your application' link
  Then I see 'Apply to' in the page's h1
  And I see the page's h1 ends in that framework.name
  When I click 'View communications and ask clarification questions'
  Then I see that framework.name in the page's h1
  And I see the page's h1 ends in 'updates'
  And I see 'You can ask clarification questions until' text on the page
  And I see 'Answers are published to this page around twice a week' text on the page
  When I enter a random value in the 'clarification_question' field
  And I click the 'Ask question' button
  Then I receive a clarification question email regarding that question for 'clarification-questions@example.gov.uk'
  And I receive a clarification question confirmation email regarding that question for that supplier_user.emailAddress
  And I don't receive a follow-up question email regarding that question for 'follow-up@example.gov.uk'
  And I see a success banner message containing 'Your clarification question has been sent.'

Scenario: Supplier cannot ask a question after the clarification deadline
  Given there is a framework that is open for applications with clarification questions closed
  And I have a supplier user
  And that supplier has applied to be on that framework
  And that supplier has confirmed their company details for that application
  And that supplier is logged in
  When I visit the /suppliers page
  And I click the 'Continue your application' link
  Then I see 'Apply to' in the page's h1
  And I see the page's h1 ends in that framework.name
  When I click 'View communications and clarification questions'
  Then I see that framework.name in the page's h1
  And I see the page's h1 ends in 'updates'
  And I see 'The deadline for asking clarification questions has now passed' text on the page
  And I see 'Contact the support team' text on the page

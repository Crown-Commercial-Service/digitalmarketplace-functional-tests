@withdraw
Feature: Withdraw opportunity supplier journey

Scenario: See detail page for a withdrawn brief
  Given I have a live digital outcomes and specialists framework
  And I have a buyer
  And I have a withdrawn digital-specialists brief
  When I go to that brief page
  Then I am on that brief.title page
  And I see a temporary-message banner message containing 'This opportunity was withdrawn'
  And I don't see the 'Apply' link
  And I don't see the 'Log in to ask a question' link
  And I don't see the 'Log in to view question and answer session details' link

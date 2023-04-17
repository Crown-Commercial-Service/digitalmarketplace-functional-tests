# As DOS5 is closed, buyers will be unable to create new requirements so we need to remove these tests
# @buyer @buyer-clarification
# Feature: Buyer publishes question and answer

# Scenario: Buyer publishes answers to clarification questions on a brief which the public can see
#   Given I am logged in as the buyer of a live brief
#   And I go to that brief overview page

#   When I click the 'Publish questions and answers' link
#   Then I am on the 'Supplier questions' page

#   When I click the 'Answer a supplier question' link
#   Then I am on the 'Publish questions and answers' page

#   When I publish an answer to a question
#   Then I am on the 'Supplier questions' page

#   When I click the 'Log out'
#   And I go to that brief page
#   Then I see the published question and answer

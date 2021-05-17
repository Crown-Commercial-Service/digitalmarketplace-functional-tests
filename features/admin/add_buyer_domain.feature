@admin @add-buyer-domain
Feature: Admin buyer domains

Scenario Outline: Admin user can attempt to add domain and sees duplicate domain error message when domain exists
  Given I am logged in as the existing admin user
  And I click the 'Add a buyer email domain' link
  When I enter 'gov.uk' in the 'new_buyer_domain' field
  And I click the 'Add' button
  Then I see a destructive banner message containing 'You cannot add this domain because it already exists.'


Scenario Outline: Admin user can see invalid format message for invalid domain string
  Given I am logged in as the existing admin user
  And I click the 'Add a buyer email domain' link
  When I enter 'test' in the 'new_buyer_domain' field
  And I click the 'Add' button
  Then I see a destructive banner message containing '‘test’ is not a valid format'

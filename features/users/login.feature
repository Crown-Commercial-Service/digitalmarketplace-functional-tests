@smoke-tests
Feature: Different types of user can log in

@with-production-supplier-user
Scenario: Supplier user can log in
  Given I am on the homepage
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that production_supplier_user.emailAddress in the 'Email address' field
  And I enter that production_supplier_user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see that production_supplier_user.emailAddress as the page header context
  And I see the 'Log out' link

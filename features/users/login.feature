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
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that production_supplier_user.emailAddress as the page header context

@with-production-buyer-user
Scenario: Buyer user can log in
  Given I am on the homepage
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that production_buyer_user.emailAddress in the 'Email address' field
  And I enter that production_buyer_user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that production_buyer_user.emailAddress as the page header context

@with-production-admin-user
Scenario: Admin user can log in
  Given I am on the /admin page
  Then I am on the 'Administrator login' page
  When I enter that production_admin_user.emailAddress in the 'Email address' field
  And I enter that production_admin_user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  # nope - admin page has four h1s.
  #And I am on the 'Admin' page

@with-production-admin-ccs-category-user
Scenario: Admin CCS Category user can log in
  Given I am on the /admin page
  Then I am on the 'Administrator login' page
  When I enter that production_admin_ccs_category_user.emailAddress in the 'Email address' field
  And I enter that production_admin_ccs_category_user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  # nope - admin page has four h1s.
  #And I am on the 'Admin' page

@with-production-admin-ccs-sourcing-user
Scenario: Admin CCS Sourcing user can log in
  Given I am on the /admin page
  Then I am on the 'Administrator login' page
  When I enter that production_admin_ccs_sourcing_user.emailAddress in the 'Email address' field
  And I enter that production_admin_ccs_sourcing_user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  # nope - admin page has four h1s.
  #And I am on the 'Admin' page

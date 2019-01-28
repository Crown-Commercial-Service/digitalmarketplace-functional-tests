@smoke-tests
Feature: Different types of user can log in

@with-supplier-user
Scenario: Supplier user can log in
  Given I visit the homepage
  And I have an existing supplier user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-buyer-user
Scenario: Buyer user can log in
  Given I visit the homepage
  And I have an existing buyer user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-admin-user
Scenario: Admin user can log in
  Given I visit the homepage
  And I have an existing admin user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-admin-ccs-category-user
Scenario: Admin CCS Category user can log in
  Given I visit the homepage
  And I have an existing admin-ccs-category user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-admin-ccs-sourcing-user
Scenario: Admin CCS Sourcing user can log in
  Given I visit the homepage
  And I have an existing admin-ccs-sourcing user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-admin-framework-manager-user
Scenario: Admin Framework Manager user can log in
  Given I visit the homepage
  And I have an existing admin-framework-manager user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-admin-manager-user
Scenario: Admin Manager user can log in
  Given I visit the homepage
  And I have an existing admin-manager user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-production-admin-ccs-data-controller-user
Scenario: Admin Manager user can log in
  Given I visit the homepage
  And I have a production admin-ccs-data-controller user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

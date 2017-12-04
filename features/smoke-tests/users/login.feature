@smoke-tests
Feature: Different types of user can log in

@with-production-supplier-user
Scenario: Supplier user can log in
  Given I am on the homepage
  And I have a production supplier user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-production-buyer-user
Scenario: Buyer user can log in
  Given I am on the homepage
  And I have a production buyer user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-production-admin-user
Scenario: Admin user can log in
  Given I am on the homepage
  And I have a production admin user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-production-admin-ccs-category-user
Scenario: Admin CCS Category user can log in
  Given I am on the homepage
  And I have a production admin-ccs-category user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-production-admin-ccs-sourcing-user
Scenario: Admin CCS Sourcing user can log in
  Given I am on the homepage
  And I have a production admin-ccs-sourcing user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-production-admin-framework-manager-user
Scenario: Admin Framework Manager user can log in
  Given I am on the homepage
  And I have a production admin-framework-manager user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

@with-production-admin-manager-user
Scenario: Admin Manager user can log in
  Given I am on the homepage
  And I have a production admin-manager user
  When I click 'Log in'
  Then I am on the 'Log in to the Digital Marketplace' page
  When I enter that user.emailAddress in the 'Email address' field
  And I enter that user.password in the 'Password' field
  And I click the 'Log in' button
  Then I see the 'Log out' link

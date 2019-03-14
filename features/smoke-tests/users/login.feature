@smoke-tests
Feature: Different types of user can log in

@with-supplier-user
Scenario: Supplier user can log in
  Given I have an existing supplier user
  Then I can log in as that user
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-buyer-user
Scenario: Buyer user can log in
  Given I have an existing buyer user
  Then I can log in as that user
  When I click the 'View your account' link
  Then I see that user.emailAddress as the page header context

@with-admin-user
Scenario: Admin user can log in
  Given I have an existing admin user
  Then I can log in as that user

@with-admin-ccs-category-user
Scenario: Admin CCS Category user can log in
  Given I have an existing admin-ccs-category user
  Then I can log in as that user

@with-admin-ccs-sourcing-user
Scenario: Admin CCS Sourcing user can log in
  Given I have an existing admin-ccs-sourcing user
  Then I can log in as that user

@with-admin-framework-manager-user
Scenario: Admin Framework Manager user can log in
  Given I have an existing admin-framework-manager user
  Then I can log in as that user

@with-admin-manager-user
Scenario: Admin Manager user can log in
  Given I have an existing admin-manager user
  Then I can log in as that user

@with-admin-ccs-data-controller-user
Scenario: Admin Manager user can log in
  Given I have an existing admin-ccs-data-controller user
  Then I can log in as that user

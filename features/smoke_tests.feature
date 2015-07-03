@smoke-test
Feature: Smoke tests
@smoke-test-not-production
Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page

  When I click 'View'
  Then I am presented with the 'DM Functional Test Supplier' supplier service listings page

  When I click 'Logout'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

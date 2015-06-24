@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have a test supplier
  And The test supplier has a user
  And The test supplier has multiple services
@wip
Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page
  When I click 'Logout'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: As a logged in supplier user, my supplier detail are available on the dashboard
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  Then I can see my supplier details on the dashboard
@wip
Scenario: As a logged in supplier user, I can navigate to the service listings page from my dashboard and can see all my listings
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
  When I click 'View'
  Then I am presented with the 'DM Functional Test Supplier' supplier service listings page
  And I can see all my listings ordered by lot name followed by listing name
@wip
Scenario: As a logged in supplier user, I can select a listing and be presented with the listings page
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page
  When I select the second listing on the page
  Then I am presented with the listing page for that specific listing

@not-production @functional-test
Feature: Supplier user journey through Digital Marketplace

Scenario: Setup for tests
  Given I have a test supplier
  And The test supplier has a user
  And The test supplier has multiple services

Scenario: As supplier user I wish be able to log in and to log out of Digital Marketplace
  Given I am on the 'Supplier' login page
  When I login as a 'Supplier' user
  Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page
  When I click 'Logout'
  Then I am logged out of Digital Marketplace as a 'Supplier' user

Scenario: As a supplier user who has logged in to Digital Marketplace, I can see all my listings
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dash board page
  Then I can see all my listings ordered by lot name followed by listing name

Scenario: As a logged in supplier user, I can select a listing and be presented with the listings page
  Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dash board page
  When I select the second listing from the dashboard
  Then I am presented with the listing page for that specific listing

@smoke-tests
Feature: Admin users can search for objects

@with-production-admin-user
Scenario: Admin can find supplier by prefix
  Given I am logged in as that production_admin_user user
  And I am on the /admin page
  And I have a random supplier from the API
  When I enter that supplier.name in the 'Find suppliers by name prefix' field and click its associated 'Search' button
  Then I am on the 'Suppliers' page
  And I see that supplier in the list of suppliers

@smoke-tests
Feature: Admin users can search for objects

@with-admin-user
Scenario: Admin can find a supplier by name
  Given I am logged in as the existing admin user
  And I visit the /admin/search page
  And I have a random supplier from the API
  When I enter that supplier.name in the 'Find a supplier by name' field and click its associated 'Search' button
  Then I am on the 'Suppliers' page
  And I see that supplier in the list of suppliers

@with-admin-user
Scenario: Admin can find a supplier by DUNS number
  Given I am logged in as the existing admin user
  And I visit the /admin/search page
  And I have a random supplier from the API
  And I click the 'DUNS Number' link
  When I enter that supplier.dunsNumber in the 'Find a supplier by DUNS number' field and click its associated 'Search' button
  Then I am on the 'Suppliers' page
  And I see the number of suppliers listed is 1
  And I see that supplier in the list of suppliers

@with-admin-user
Scenario: Admin can find a buyer by opportunity id
  Given I am logged in as the existing admin user
  And I visit the /admin/buyers page
  And I have a random dos brief from the API
  When I enter that brief.id in the 'Find a buyer by opportunity ID' field and click its associated 'Search' button
  And I see that brief.title in the page's h2

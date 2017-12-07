@smoke-tests
Feature: Admin users can search for objects

@with-production-admin-user
Scenario: Admin can find supplier by prefix
  Given I am logged in as the production admin user
  And I am on the /admin page
  And I have a random supplier from the API
  When I enter that supplier.name in the 'Find suppliers by name prefix' field and click its associated 'Search' button
  Then I am on the 'Suppliers' page
  And I see that supplier in the list of suppliers

@with-production-admin-user
Scenario: Admin can find supplier by DUNS number
  Given I am logged in as the production admin user
  And I am on the /admin page
  And I have a random supplier from the API
  When I enter that supplier.dunsNumber in the 'Find suppliers by DUNS number' field and click its associated 'Search' button
  Then I am on the 'Suppliers' page
  And I see the number of suppliers listed is 1
  And I see that supplier in the list of suppliers

@with-production-admin-user @skip-staging
Scenario: Admin can find buyer by opportunity id
  Given I am logged in as the production admin user
  And I am on the /admin/buyers page
  And I have a random dos brief from the API
  When I enter that brief.id in the 'Find a buyer by opportunity ID' field and click its associated 'Search' button
  And I see that brief.title in the page's h2

@with-production-admin-user @skip-preview
Scenario: Admin can find buyer by opportunity id
  Given I am logged in as the production admin user
  And I am on the /admin page
  And I have a random dos brief from the API
  When I enter that brief.id in the 'Find buyer by opportunity ID' field and click its associated 'Search' button
  Then I see that brief.id in the page's h1
  And I see that brief.title in the page's h1

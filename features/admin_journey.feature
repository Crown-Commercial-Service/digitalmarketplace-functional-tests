Feature: Admin user journey through marketplace

Scenario: Admin user is able to perform specific tasks in Digital Marketplace
  Given I am on the marketplace '' page
  And I am logged in as a 'administrator'
  Then I am on the 'Dashboard' page
  And I see a link to 'Home'
  And I see a link to 'Dashboard'
  And I see a link to 'Admin console'
  And I see a link to 'Log out'

Scenario: Admin user can navigate to marketplace home page
  Given I am on the marketplace '' page
  When I click 'Home' link
  Then I should be at the 'Digital Marketplace' page
  And I remain logged in

Scenario: Admin user can navigate to marketplace dashboard page
  Given I am on the marketplace '' page
  When I click 'Dashboard' link
  Then I am on the 'Dashboard' page

Scenario: Admin user can navigate to marketplace admin console page
  Given I am on the marketplace '' page
  When I click 'Admin console' link
  Then I am on the 'Admin console' page

Scenario: Admin user can search for suppliers and show their available services
  Given I am on the marketplace '/admin' page
  When I click the Suppliers button
  Then I am on the 'Find supplier' page

  When I fill in 'supplierName' with 'Accenture (UK) Limited'
  And I click 'Next'
  Then I should be presented with the available servies for the supplier 'Accenture (UK) Limited'
@staging_only
Scenario: Admin user see option to 'Deactivate' services for a specific supplier
  Given I am on the marketplace '/admin/suppliers/accenture-uk-limited' page
  When I see the service 'Accenture Application Development (including Open Source) Cloud Services'
  Then I see an option to 'Deactivate' the service
  And There is a link to the service 'Accenture Application Development (including Open Source) Cloud Services'

  When I click 'Deactivate' link for the specific service
  Then The service is 'Deactivated'
  And I should see the following confirmation message 'Accenture Application Development (including Open Source) Cloud Services was deactivated.'
@staging_only
Scenario: Deactivated service not returned in search results
  Given I am on the marketplace '' page
  When I search for the 'Deactivated' service by service id
  Then The service 'is not' returned in the search results
  And The following message is presented to the user 'There are no services matching the searched terms'
@staging_only
Scenario: Direct link to a deactivated service page will return a 410 page
  Given The service is 'Deactivated'
  When I navigate directly to the service listing page
  Then I should see an error page with the message 'This page cannot be found'
@staging_only
Scenario: Admin user see option to 'Activate' services for a specific supplier
  Given I am on the marketplace '/admin/suppliers/accenture-uk-limited' page
  When I see the service 'Accenture Application Development (including Open Source) Cloud Services'
  Then I see an option to 'Activate' the service

  When I click 'Activate' link
  Then I should see the following confirmation message 'Accenture Application Development (including Open Source) Cloud Services was activated.'
@staging_only
Scenario: Direct link to a activated service page will return the service listing page
  Given The service is 'Activated'
  When I navigate directly to the service listing page
  Then The service listing page for the specific service is presented
@staging_only
Scenario: Re-activated service is returned in search results
  Given I am on the marketplace '' page
  When I search for the 'Activated' service by service id
  Then The service 'is' returned in the search results

@not-production @functional-test
Feature: Buyer user journey through Digital Marketplace

Scenario: User is able to navigate from the digital marketplace landing page to the g-cloud landing page
  Given I am on the 'Digital Marketplace' landing page
  When I click the 'Find cloud technology and support' link
  Then I am taken to the 'Cloud technology and support' landing page

Scenario: User selects SaaS lot from the g-cloud page is presented with search results page for SaaS lot with SaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Software as a Service' link
  Then I am taken to the search results page with results for 'Software as a Service' lot displayed
  And All filters for 'Software as a Service' are available

Scenario: User selects PaaS lot from the g-cloud page is presented with search results page for PaaS lot with PaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Platform as a Service' link
  Then I am taken to the search results page with results for 'Platform as a Service' lot displayed
  And All filters for 'Platform as a Service' are available

Scenario: User selects IaaS lot from the g-cloud page is presented with search results page for IaaS lot with IaaS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Infrastructure as a Service' link
  Then I am taken to the search results page with results for 'Infrastructure as a Service' lot displayed
  And All filters for 'Infrastructure as a Service' are available

Scenario: User selects SCS lot from the g-cloud page is presented with search results page for SCS lot with SCS specific filters presented
  Given I am on the 'Cloud technology and support' landing page
  When I click the 'Specialist Cloud Services' link
  Then I am taken to the search results page with results for 'Specialist Cloud Services' lot displayed
  And All filters for 'Specialist Cloud Services' are available

Scenario: There is pagination on the results page if there are more than 100 results
  Given I am on the search results page with results for 'Infrastructure as a Service' lot displayed
  When There is 'more' than 100 results returned
  Then Pagination is 'available'

  When I click the 'Next page' link
  Then I am taken to page '2' of results

  When I click the 'Previous page' link
  Then I am taken to page '1' of results

Scenario: There is no pagination on the results page if there is less than or equal to 100 results
  Given I am on the search results page with results for 'Infrastructure as a Service tested'
  When There is 'less' than 100 results returned
  Then Pagination is 'not available'

Scenario: User able to search by service ID and have result returned
  Given I am on the 'Cloud technology and support' landing page
  When I enter '1123456789012346' in the 'q' field
  And I click 'Show services'
  Then I am taken to the search results page with a result for the service '1123456789012346'

Scenario: User is able to search by service name and have result returned.
  Given I am on the 'Cloud technology and support' landing page
  When I enter '1123456789012346 DM Functional Test N3 Secure Remote Access' in the 'q' field
  And I click 'Show services'
  Then I am taken to the search results page with a result for the service '1123456789012346 DM Functional Test N3 Secure Remote Access'

Scenario: Words in service description matching the search criteria are highlighted
  Given I am on the search results page for the searched value of '1123456789012346 DM Functional Test N3 Secure Remote Access'
  Then Words in the search result excerpt that match the search criteria are highlighted

Scenario: User able to search by keywords field on the search results page to narrow down the results returned
  Given I am on the search results page with results for 'Infrastructure as a Service' lot displayed
  When I enter '1123456789012346' in the 'q' field
  And I click 'Filter'
  Then The search results is filtered returning just one result for the service '1123456789012346'

Scenario: User is able to use filter to narrow down results set
  Given I am on the search results page with results for 'Specialist Cloud Services' lot displayed
  When I select 'Training' as the filter value under the 'Categories' filter
  And I click 'Filter'
  Then The search results is narrowed down by the selected filter

  When When I select 'Testing' as the filter value under the 'Categories' filter
  And I click 'Filter'
  Then The search results is narrowed down by the selected filter

  When When I select 'Year' as the filter value under the 'Minimum contract period' filter
  And I click 'Filter'
  Then The search results is narrowed down by the selected filter

  When When I select 'Support accessible to any third-party suppliers' as the filter value under the 'Service management' filter
  And I click 'Filter'
  Then The search results is narrowed down by the selected filter

Scenario: User is able to navigate to service listing page via selecting the service from the search results
  Given I am on the search results page with results for 'Platform as a Service' lot displayed
  When I click the first record in the list of results returned
  Then I am taken to the service listing page of that specific record selected

Feature: Apps /_status is ok

  @status @api
  Scenario: Check the data API /_status
    Given I have a URL for "dm_api"
    When I send a GET request to the status page
    Then the response JSON field "status" should be "ok"

  @status @search-api
  Scenario: Check the search API /_status
    Given I have a URL for "dm_search_api"
    When I send a GET request to the status page
    Then the response JSON field "status" should be "ok"

  @status @buyer-frontend
  Scenario: Check the buyer frontend /_status
    Given I have a URL for "dm_buyer_frontend"
    When I send a GET request to the status page
    Then the response JSON field "status" should be "ok"

  @status @supplier-frontend
  Scenario: Check the supplier frontend /_status
    Given I have a URL for "dm_supplier_frontend"
    When I send a GET request to the status page
    Then the response JSON field "status" should be "ok"

  @status @admin-frontend
  Scenario: Check the admin frontend /_status
    Given I have a URL for "dm_admin_frontend"
    When I send a GET request to the status page
    Then the response JSON field "status" should be "ok"

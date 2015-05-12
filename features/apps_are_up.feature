Feature: Apps are up

  @api
  Scenario: Check the data API is up
    Given I have a URL for "dm_api"
      And I have an auth token for "dm_api"
    When I send a GET request with authorization to "/services"
    Then the response code should be "200"
    And the response should contain a JSON list of "services"

  @search-api
  Scenario: Check the search API is up
    Given I have a URL for "dm_search_api"
      And I have an auth token for "dm_search_api"
    When I send a GET request with authorization to "/"
    Then the response code should be "200"
    And the response should contain a JSON object "links"

  @buyer-frontend
  Scenario: Check the buyer frontend is up
    Given I have a URL for "dm_frontend"
    When I send a GET request to the home page
    Then the response code should be "200"

  @supplier-frontend
  Scenario: Check the supplier frontend is up
    Given I have a URL for "dm_frontend"
    When I send a GET request to "/suppliers/login"
    Then the response code should be "200"

  @admin-frontend
  Scenario: Check the admin frontend is up
    Given I have a URL for "dm_frontend"
    When I send a GET request to "/admin/login"
    Then the response code should be "200"

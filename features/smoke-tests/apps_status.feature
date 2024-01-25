@smoke-tests
Feature: Apps /_status is ok

  @status @api
  Scenario: Check the data API /_status
    Given I visit the api /_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @search-api
  Scenario: Check the search API /_status
    Given I visit the search-api /_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @antivirus-api @skip-local
  Scenario: Check the antivirus API /_status
    Given I visit the antivirus-api /_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @user-frontend
  Scenario: Check the user frontend /_status
    Given I visit the frontend /user/_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @buyer-frontend
  Scenario: Check the buyers frontend /_status
    Given I visit the frontend /_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @briefs-frontend
  Scenario: Check the briefs frontend /_status
    Given I visit the frontend /buyers/_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @brief-responses-frontend
  Scenario: Check the brief responses frontend /_status
    Given I visit the frontend /suppliers/opportunities/_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @supplier-frontend
  Scenario: Check the suppliers frontend /_status
    Given I visit the frontend /suppliers/_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

  @status @admin-frontend
  Scenario: Check the admin frontend /_status
    Given I visit the admin-frontend /admin/_status page
    Then I see 'ok' as the value of the 'status' JSON field
    And Display the value of the 'version' JSON field as 'Release version'

Feature: Open and update json file

Scenario: Open, update and save the change made to a json file.
  Given I have opened a json file
  When I update the service name of the stored json file
  Then The new json file has a new service name

@api
Scenario: retreive all domains as JSON
    Given I am a valid API user
    And I send and accept JSON
    When I send a GET request for "/fixtures"
    When I send a PUT request to "/fixtures" with the following:
    Then the response should be "200"
    And the JSON response should be an array with 1 "domain" elements

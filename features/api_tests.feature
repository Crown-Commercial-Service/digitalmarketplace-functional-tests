Feature: Data API

  @api
  Scenario: Open, update and save the change made to a json file.
    Given I have opened a json file
    When I update the service name of the stored json file
    Then The new json file has a new service name

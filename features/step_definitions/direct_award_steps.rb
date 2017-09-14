When(/^I have a created and saved a search$/) do
  steps %Q{
    Given I am on the /g-cloud/search page
    And I click 'Save search'
    Then I am on the 'Save your search' page
    And I enter 'my cloud project' in the 'Name your search' field
    And I click 'Save and continue'
  }
end

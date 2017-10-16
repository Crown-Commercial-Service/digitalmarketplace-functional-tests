When(/^I have created and saved a search$/) do
  steps %Q{
    Given I am on the /g-cloud/search page
    And I click 'Save search'
    Then I am on the 'Choose where to save your search' page
    And I enter 'my cloud project' in the 'Name your search' field
    And I click 'Save and continue'
  }
end

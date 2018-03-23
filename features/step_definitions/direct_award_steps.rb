When(/^I have created and saved a search called '(.*)'$/) do |search_name|
  steps %{
    Given I am on the /g-cloud/search?q=email+analysis+provider page
    And I click 'Save search'
    Then I am on the 'Choose where to save your search' page
    And I enter '#{search_name}' in the 'Name your search' field
    And I click 'Save and continue'
  }
end

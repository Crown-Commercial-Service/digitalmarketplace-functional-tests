When(/^I have created and saved a search called '(.*)'$/) do |search_name|
  steps %{
    Given I visit the /g-cloud/search?q=email+analysis+provider page
    And I click 'Save search'
    Then I am on the 'Choose where to save your search' page
    And I enter '#{search_name}' in the 'Name your search' field
    And I click 'Save and continue'
  }
end

When(/^I award the contract to '(.*)'$/) do |supplier_name|
  steps %{
    Given I am on the 'Did you award contract?' page
    And I choose the 'Yes' radio button
    And I click 'Save and continue'
    The I am on the 'Which service did you award?' page
    And I choose the 'Service X' radio button
    And I click 'Save and continue'
    Then I am on the 'Tell us about your contract' page
    And I fill in start date as '20-12-2018'
    And I fill in end date as '20-12-2020'
    And I fill in the value as '100000'
    And I fill in the organisation buying the service as 'Government Digital Service'
    And I click 'Submit'
  }
end

When(/^I do not award the contract because the work is cancelled$/) do
  steps %{
    Given I am on the 'Did you award contract?' page
    And I choose the 'No' radio button
    And I click 'Save and continue'
    Then I am on the "Why didn't you award contract?" page
    And I choose the 'Work cancelled' radio button
    And I click 'Submit'
  }
end

When(/^I do not award the contract because there are no suitable services$/) do
  steps %{
    Given I am on the 'Did you award contract?' page
    And I choose the 'No' radio button
    And I click 'Save and continue'
    Then I am on the "Why didn't you award contract?" page
    And I choose the 'No suitable services' radio button
    And I click 'Submit'
  }
end
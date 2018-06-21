When (/^I have created and saved a search called '(.*)'$/) do |search_name|
  steps %{
    Given I visit the /g-cloud/search?q=email+analysis+provider page
    And I click 'Save search'
    Then I am on the 'Choose where to save your search' page
    And I enter '#{search_name}' in the 'Name your search' field
    And I click 'Save and continue'
  }
end

When (/^I have created and ended a search called '(.*)'$/) do |search_name|
  steps %{
    And I have created and saved a search called '#{search_name}'
    And I visit the /buyers page
    Then I click the 'View your saved searches' link
    Then I click the '#{search_name}' link
    Then I am on the '#{search_name}' page
    And I click the 'End search' link
    Then I am on the 'End your search' page
    And I click the 'End search and continue' button
    Then I am on the '#{search_name}' page
  }
end

When (/^I have downloaded the search results as a file of type '(.*)'$/) do |file_type|
  steps %{
    And I click the 'Download search results' link
    And I am on the 'Download your search results' page
  }
  if file_type == 'ods'
    steps "And I click the 'Download search results as a spreadsheet' link"
  elsif file_type == 'csv'
    steps "And I click the 'Download search results as comma-separated values' link"
  else
    puts "The file type '#{file_type}' is not recognised"
  end
  steps "And I should get a download file of type '#{file_type}'"
end

When (/^I award the contract to '(.*)' for the '(.*)' search$/) do |supplier_name, search_name|
  steps %{
    Given I am on the 'Did you award a contract for ‘#{search_name}’?' page
    And I choose the 'Yes' radio button
    And I click 'Save and continue'
    Then I am on the 'Which service won the contract?' page
    And I choose the '#{supplier_name}' radio button
    And I click 'Save and continue'
    Then I am on the 'Tell us about your contract' page
    And I enter '20' in the 'input-start_date-day' field
    And I enter '12' in the 'input-start_date-month' field
    And I enter '2018' in the 'input-start_date-year' field
    And I enter '20' in the 'input-end_date-day' field
    And I enter '12' in the 'input-end_date-month' field
    And I enter '2020' in the 'input-end_date-year' field
    And I enter '100000' in the 'input-value_in_pounds' field
    And I enter 'Government Digital Service' in the 'input-buying_organisation' field
    And I click 'Submit'
  }
end

When (/^I do not award the contract because '(.*)'$/) do |reason|
  steps %{
    Given I am on the 'Did you award a contract for ‘my cloud project’' page
    And I choose the 'No' radio button
    And I click 'Save and continue'
    Then I am on the 'Why didn’t you award a contract?' page
  }
  case reason
    when 'The work has been cancelled'
      steps "And I choose the 'The work has been cancelled' radio button"
    when 'There were no suitable services'
      steps "And I choose the 'There were no suitable services' radio button"
    else
      puts 'The reason for not awarding the contract is not recognised'
  end
  steps "And I click 'Save and continue'"
end

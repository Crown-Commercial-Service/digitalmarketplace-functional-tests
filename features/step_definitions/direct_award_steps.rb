When (/^I have created and saved a search called '(.*)'$/) do |search_name|
  @project = get_direct_award_project(@user, search_name)
  if not @project
    case search_name
      when 'my cloud project', 'my cloud project - existing'
        search_query = "q=email+analysis+provider+system"
      when 'export limit test project'
        search_query = "q=cloud+software+nhs"
    end
    @project = create_direct_award_project(@user, search_name, search_query)
  end
  puts "#{@framework['name']} project: #{@project['id']}"
  steps "Given I visit the /buyers/direct-award/g-cloud/projects/#{@project['id']} page"
end

When (/^I am ready to tell the outcome for the '(.*)' saved search$/) do |search_name|
  steps %{
    Given I have created and saved a search called '#{search_name}'
    And I am on the '#{search_name}' page
    And I have exported my results for the '#{search_name}' saved search
    And I click the 'Return to your task list' link
    And I click the 'Confirm you have read and understood how to assess services' button
  }
end

When (/^I have exported my results for the '(.*)' saved search$/) do |search_name|
  steps %{
    Given I visit the /buyers/direct-award/g-cloud page
    And I click the '#{search_name}' link
    And I click the 'Export your results' link
    And I check 'I understand that I cannot edit my search after I export my results' checkbox
    And I click the 'Export results and continue' button
    Then I see a success flash message containing 'Results exported. Your files are ready to download.'
  }
end

When (/^I award the contract for the '(.*)' search$/) do |search_name|
  steps %{
    Given I am on the 'Did you award a contract for ‘#{search_name}’?' page
    And I choose the 'Yes' radio button
    And I click 'Save and continue'
    Then I am on the 'Which service won the contract?' page
    And I choose a random 'which_service_won_the_contract' radio button
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
      step "And I choose the 'The work has been cancelled' radio button"
    when 'There were no suitable services'
      step "And I choose the 'There were no suitable services' radio button"
    else
      puts 'The reason for not awarding the contract is not recognised'
  end
  steps "And I click 'Save and continue'"
end

When (/^I have downloaded the search results as a file of type '(.*)'$/) do |file_type|
  step "And I click the 'Download your results' link"
  if file_type == 'ods'
    steps "And I click the 'Download search results as a spreadsheet' link"
  elsif file_type == 'csv'
    steps "And I click the 'Download search results as comma-separated values' link"
  else
    puts "The file type '#{file_type}' is not recognised"
  end
  steps "And I should get a download file with filename ending '.#{file_type}'"
end

And (/^I see the '(.*)' instruction list item status showing as '(.*)'$/) do |list_item, status|
  list_item = page.find(".dm-task-list li, .instruction-list .instruction-list-item", text: list_item)
  expect(list_item).to have_selector(".app-tag--box, .instruction-list-item-box", text: status)
end

And (/^I see the '(.*)' instruction list item has a warning message of '(.*)'$/) do |list_item, message|
  list_item = page.find(".dm-task-list li, .instruction-list .instruction-list-item", text: list_item)
  expect(list_item).to have_selector(".govuk-error-message, strong", text: message)
end

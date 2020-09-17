When(/^I click a random result in the list of opportunity results returned$/) do
  search_results = all(:xpath, "//*[@class='app-search-result' or @class='search-result']")
  selected_result = search_results[rand(search_results.length)]

  @result ||= Hash.new

  a_elem = selected_result.first(:css, "h2.govuk-heading-s a, .search-result-title a")
  @result['title'] = a_elem.text
  puts "Result name: #{@result['title']}"

  a_elem.click
end

When(/^I note the result_count$/) do
  @result_count = page.first(:css, ".search-summary-count").text.to_i
  puts "Noted result_count: #{@result_count}"
end

Then (/^I see an opportunity in the search results$/) do
  expect(page).to have_selector(:css, ".app-search-result, .search-result")
end

Then (/^I see that the stated number of results (does not exceed|equals|is no fewer than) that (\w+)$/) do |comparison_string, variable_name|
  var_val = instance_variable_get("@#{variable_name}")
  @new_result_count = page.first(:css, ".search-summary-count").text.to_i
  puts "Number of results: #{@new_result_count}"
  if comparison_string == "does not exceed"
    expect(@new_result_count).to be <= var_val
  elsif comparison_string == "equals"
    expect(@new_result_count).to eq(var_val)
  elsif comparison_string == "is no fewer than"
    expect(@new_result_count).to be >= var_val
  end
end

Then (/^I see all the opportunities on the page are on the '(.*)' lot$/) do |lot|
  search_result_metadata_items(:lot).each { |x| expect(x.text).to eq(lot) }
end

Then (/^I see all the opportunities on the page are in the '(.*)' location/) do |location|
  search_result_metadata_items(:location).each { |x| expect(x.text).to eq(location) }
end

Then (/^I see all the opportunities on the page are for the '(.*)' role/) do |role|
  search_result_metadata_items(:role).each { |x| expect(x.text).to eq(role) }
end

Then (/^I see all the opportunities on the page are of the '(.*)' status$/) do |status|
  search_result_metadata_items(:status).each do |x|
    if closed_outcome?(status)
      expect(x.text).to satisfy { |text| closed_outcome_status?(text) }
    else
      expect(x.text).to include("Published")
    end
  end
end

Then (/^I see no results$/) do
  expect(page.first(:css, ".search-summary-count").text.to_i).to eq(0)
  expect(page).to have_selector(:css, '.search-result', count: 0)
end

Then /^I see the details of the brief match what was published$/ do
  steps %{
    Given I see the 'Overview' summary list filled with:
      | field                        | value                         |
      | Specialist role              | Developer                     |
      | Summary of the work          | #{@brief['summary']}          |
      | Latest start date            | #{DateTime.strptime(@brief['startDate'], '%Y-%m-%d').strftime('%A %-d %B %Y')} |
      | Expected contract length     |                               |
      | Location                     | #{@brief['workplaceAddress']} |
      | Organisation the work is for | #{@brief['organisation']}     |
      | Maximum day rate             |                               |
    Given I see the 'About the work' summary list filled with:
      | field                             | value                         |
      | Early market engagement           |                               |
      | Who the specialist will work with | #{@brief['existingTeam']}     |
      | What the specialist will work on  | #{@brief['specialistWork']}   |
    Given I see the 'Work setup' summary list filled with:
      | field                                  | value                            |
      | Address where the work will take place | #{@brief['workplaceAddress']}    |
      | Working arrangements                   | #{@brief['workingArrangements']} |
      | Security clearance                     |                                  |
    Given I see the 'Additional information' summary list filled with:
      | field                                  | value                            |
      | Additional terms and conditions        |                                  |
    Given I see the 'Skills and experience' summary list filled with:
      | field                                  | value                                         |
      | Essential skills and experience        | #{@brief['essentialRequirements'].join(' ')}  |
      | Nice-to-have skills and experience     | #{@brief['niceToHaveRequirements'].join(' ')} |
    Given I see the 'How suppliers will be evaluated' summary list filled with:
      | field                                  | value                                                                                                                                 |
      | How many specialists to evaluate       | #{@brief['numberOfSuppliers']}                                                                                                        |
      | Cultural fit criteria                  | #{@brief['culturalFitCriteria'].join(' ')}                                                                                            |
#      | Assessment methods                     | Work history                                                                                                                          |
#      | Evaluation weighting                   | Technical competence #{@brief['technicalWeighting']}% Cultural fit #{@brief['culturalWeighting']}% Price #{@brief['priceWeighting']}% |
  }
end

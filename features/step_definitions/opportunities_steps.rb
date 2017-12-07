When(/^I click a random result in the list of opportunity results returned$/) do
  search_results = all(:xpath, "//*[@class='search-result']")
  selected_result = search_results[rand(search_results.length)]

  @result = @result || Hash.new

  a_elem = selected_result.first(:xpath, ".//h2[@class='search-result-title']/a")
  @result['title'] = a_elem.text
  puts "Result name: #{@result['title']}"

  a_elem.click
end

When(/^I note the result_count$/) do
  @result_count = page.first(:css, ".search-summary-count").text.to_i
  puts "Noted result_count: #{@result_count}"
end

Then (/^I see an opportunity in the search results$/) do
  page.should have_selector(:css, ".search-result")
end

Then (/^I see that the stated number of results does not exceed that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  @new_result_count = page.first(:css, ".search-summary-count").text.to_i
  puts "Number of results: #{@new_result_count}"
  @new_result_count.should <= var
end

Then (/^I see that the stated number of results equals that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  var.should == page.first(:css, ".search-summary-count").text.to_i
end

Then (/^I see all the opportunities on the page are on the '(.*)' lot$/) do |lot|
  lots_found = all(
    :xpath,
    '//*[@class="search-result"]//*[@class="search-result-metadata"][1]//*[@class="search-result-metadata-item"][1]'
  )
  lots_found.each { |x| x.text.should == lot }
end

Then (/^I see all the opportunities on the page are of the '(.*)' status$/) do |status|
  published_or_closed = all(
    :xpath,
    '//*[@class="search-result"]//*[@class="search-result-metadata"][2]//*[@class="search-result-metadata-item"][1]'
  )
  published_or_closed.each do |x|
    if ['Closed', 'Unsuccessful', 'Cancelled'].include? status
      x.text.should == status
    else
      x.text.include?("Published").should be true
    end
  end
end

Then /^I see the details of the brief match what was published$/ do
  steps %Q{
    Given I see the 'Overview' summary table filled with:
      | field                        | value                         |
      | Specialist role              | Developer                     |
      | Summary of the work          | #{@brief['summary']}          |
      | Latest start date            | #{DateTime.strptime(@brief['startDate'], '%Y-%m-%d').strftime('%A %-d %B %Y')} |
      | Expected contract length     |                               |
      | Location                     | #{@brief['workplaceAddress']} |
      | Organisation the work is for | #{@brief['organisation']}     |
      | Maximum day rate             |                               |
    Given I see the 'About the work' summary table filled with:
      | field                             | value                         |
      | Early market engagement           |                               |
      | Who the specialist will work with | #{@brief['existingTeam']}     |
      | What the specialist will work on  | #{@brief['specialistWork']}   |
    Given I see the 'Work setup' summary table filled with:
      | field                                  | value                            |
      | Address where the work will take place | #{@brief['workplaceAddress']}    |
      | Working arrangements                   | #{@brief['workingArrangements']} |
      | Security clearance                     |                                  |
    Given I see the 'Additional information' summary table filled with:
      | field                                  | value                            |
      | Additional terms and conditions        |                                  |
    Given I see the 'Skills and experience' summary table filled with:
      | field                                  | value                                         |
      | Essential skills and experience        | #{@brief['essentialRequirements'].join(' ')}  |
      | Nice-to-have skills and experience     | #{@brief['niceToHaveRequirements'].join(' ')} |
    Given I see the 'How suppliers will be evaluated' summary table filled with:
      | field                                  | value                                                                                                                                 |
      | How many specialists to evaluate       | #{@brief['numberOfSuppliers']}                                                                                                        |
      | Cultural fit criteria                  | #{@brief['culturalFitCriteria'].join(' ')}                                                                                            |
      | Assessment methods                     | Work history                                                                                                                          |
      | Evaluation weighting                   | Technical competence #{@brief['technicalWeighting']}% Cultural fit #{@brief['culturalWeighting']}% Price #{@brief['priceWeighting']}% |
  }
end

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
end

When "I go to $brief URL address" do |brief|
  puts brief
  page.visit("#{dm_frontend_domain}/digital-outcomes-and-specialists/opportunities/#{brief["id"]}")
  page.should have_content(brief["title"])
end

Then (/^I see an opportunity in the search results$/) do
  page.should have_selector(:css, ".search-result")
end

Then (/^I see that the stated number of results does not exceed that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  page.first(:css, ".search-summary-count").text.to_i.should <= var
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
    if status == 'Closed'
      x.text.should == 'Closed'
    else
      x.text.include?("Published").should be true
    end
  end
end

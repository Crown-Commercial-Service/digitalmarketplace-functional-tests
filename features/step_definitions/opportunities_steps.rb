Then (/^I see an opportunity in the search results$/) do
  page.should have_selector(:css, ".search-result")
end

Then (/^I see that brief in one of the pages that follow from clicking '(.*)'$/) do |next_link_label|
  until search_result = page.first(:xpath, "//*[@class='search-result'][.//h2//a[contains(@href, #{@brief['id']})]]")
    page.click_link(next_link_label)
    # if there wasn't another matching "next" link we should have errored out above
  end

  search_result.first(:xpath,
    ".//h2[@class='search-result-title']/a"
  ).text.should == normalize_whitespace(@brief['title'])
  search_result.all(:xpath,
    ".//*[@class='search-result-metadata-item']"
  ).find {|r| r.text == normalize_whitespace(@brief['organisation'])}
  search_result.all(:xpath,
    ".//*[@class='search-result-metadata-item']"
  ).find {|r| r.text == normalize_whitespace(@brief['lotName'])}
end

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

Then (/^I see that the stated number of results does not exceed that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  var.should >= page.first(:css, ".search-summary-count").text.to_i
end

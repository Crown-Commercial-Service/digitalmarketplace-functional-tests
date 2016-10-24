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

Then (/^I see an opportunity in the search results$/) do
  page.should have_selector(:css, ".search-result")
end

Then (/^I see that brief in one of the pages that follow from clicking '(.*)'$/) do |next_link_label|
  until page.all(:xpath, "//*[@class='search-result'][.//h2//a[contains(@href, '#{@brief['id']}')]]").any? { |sr_element|
    # now refine with a much more precise test
    sr_element.all(:css, "h2.search-result-title > a").any? { |a_element|
      a_element.text == normalize_whitespace(@brief['title'])
    } and sr_element.all(:css, ".search-result-metadata-item").any? { |mi_element|
      mi_element.text == normalize_whitespace(@brief['organisation'])
    } and sr_element.all(:css, ".search-result-metadata-item").any? { |mi_element|
      mi_element.text == normalize_whitespace(@brief['lotName'])
    }
  }
    page.click_link(next_link_label)
    # if there wasn't another matching "next" link we should have errored out above
  end
end

Then (/^I see that the stated number of results does not exceed that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  page.first(:css, ".search-summary-count").text.to_i.should <= var
end

Then (/^I see that the stated number of results equals that (\w+)$/) do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  var.should == page.first(:css, ".search-summary-count").text.to_i
end

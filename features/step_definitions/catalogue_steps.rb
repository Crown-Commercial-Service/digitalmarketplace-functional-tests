require 'securerandom'

Then (/^I see a service in the search results$/) do
  page.should have_selector(:css, "div.search-result")
end

Then (/^I see that service in the search results$/) do
  search_results = all(:xpath, ".//div[@class='search-result']")
  service_result = search_results.find { |r| r.first(:xpath, './h2/a')[:href].include? @service['id']}

  service_result.first(
    :xpath, "./h2[@class='search-result-title']/a"
  ).text.should == normalize_whitespace(@service['serviceName'])
  service_result.first(
    :xpath, "./p[@class='search-result-supplier']"
  ).text.should == normalize_whitespace(@service['supplierName'])
  service_result.first(
    :xpath, ".//li[@class='search-result-metadata-item'][1]"
  ).text.should == @service['lotName']
  service_result.first(
    :xpath, ".//li[@class='search-result-metadata-item'][2]"
  ).text.should == @service['frameworkName']
end

When(/^I click a random result in the list of results returned$/) do
  search_results = all(:xpath, "//*[@class='search-result']")
  selected_result = search_results[SecureRandom.random_number(search_results.length)]

  @result = @result || Hash.new

  a_elem = selected_result.first(:xpath, ".//h2[@class='search-result-title']/a")
  @result['title'] = a_elem.text
  puts "Result name: #{@result['title']}"

  @result['supplier_name'] = selected_result.first(:xpath, ".//*[@class='search-result-supplier']").text
  puts "Result supplier_name: #{@result['supplier_name']}"

  a_elem.click
end

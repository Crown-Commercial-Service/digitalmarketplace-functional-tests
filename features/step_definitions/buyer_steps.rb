require 'securerandom'

Given (/^I have a buyer user$/) do
  randomString = SecureRandom.hex
  password = SecureRandom.hex
  user_data = {
    emailAddress: randomString + '@example.gov.uk',
    name: 'Buyer Name ' + randomString,
    password: password,
    role: 'buyer',
    phoneNumber: (SecureRandom.random_number(10000000) + 10000000000).to_s,
  }

  response = call_api(:post, "/users", payload: {users: user_data, updated_by: 'functional_tests'})
  response.code.should be(201), response.body
  @user = JSON.parse(response.body)["users"]
  @user['password'] = password
  puts "Email address: #{@user['emailAddress']}"
end

Then (/^I see a service in the search results$/) do
  page.should have_selector(:css, "div.search-result")
end

Then (/^I see that service\.(.*) as the value of the '(.*)' field$/) do |attr_name, field|
  step "I see '#{@service.fetch(attr_name)}' as the value of the '#{field}' field"
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

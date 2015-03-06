require "ostruct"
require "rest_client"
require "json"
require "test/unit"

include Test::Unit::Assertions
include Rack::Test::Methods

store = OpenStruct.new



Given /^I have opened a json file$/ do
  file = File.read('./fixtures/g6-test-iaas-service-upload.json')
  json = JSON.parse(file)
  store.json = json
end

When /^I update the service name of the stored json file$/ do
  store.json['services']['serviceName'] = 'NEW NAME '+Time.now.strftime('%Y%m%d%H%M%S')
end

Then /^The new json file has a new service name$/ do
    assert_equal store.json['services']['serviceName'].start_with?("NEW NAME "),true
end



Given /^I send and accept JSON$/ do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
end

When /^I send a GET request for "([^\"]*)"$/ do |path|
  get path
end

When /^I send a PUT request to "([^\"]*)" with the following:$/ do |path, body|
  put path, body
end

Then /^the response should be "([^\"]*)"$/ do |status|
  last_response.status.should == status.to_i
end

Then /^the JSON response should be an array with (\d+) "([^\"]*)" elements$/ do |number_of_children, name|
  page = JSON.parse(last_response.body)
  page.map { |d| d[name] }.length.should == number_of_children.to_i
end

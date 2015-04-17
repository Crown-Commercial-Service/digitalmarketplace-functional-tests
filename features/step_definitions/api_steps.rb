require "ostruct"
require "rest_client"
require "json"
require "test/unit"

include Test::Unit::Assertions

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


Given /^I have a URL for "([^\"]*)"$/ do |app|
    app_domain= eval "#{app}_domain"
    assert_not_nil("#{app_domain}", "No URL supplied for #{app}")
    puts("DOMAIN  : #{app_domain}")
    store.last_domain = app_domain
end


Given /^I have an auth token for "([^\"]*)"$/ do |app|
    app_token= eval "#{app}_access_token"
    assert_not_nil("#{app_token}", "No access token supplied for #{app}")
    puts("ACCESS TOKEN: #{app_token}")
    store.last_token = app_token
end


When /^I send a GET request with authorization to "([^\"]*)"$/ do |path|
    @response = RestClient.get("#{store.last_domain}#{path}",
      authorization: "Bearer #{store.last_token}"){|response, request, result| response }  # Don't raise exceptions but return the response
    store.last_response = @response
end


When(/^I send a GET request to the home page$/) do
  @response = RestClient.get("#{store.last_domain}"){|response, request, result| response }  # Don't raise exceptions but return the response
      store.last_response = @response
end


When(/^I send a GET request to "([^\"]*)"$/) do |path|
  @response = RestClient.get("#{store.last_domain}#{path}"){|response, request, result| response }  # Don't raise exceptions but return the response
      store.last_response = @response
end


Then /^the response code should be "([^\"]*)"$/ do |status|
  store.last_response.code.should == status.to_i
end


Then /^the response should contain a JSON list of "([^\"]*)"$/ do |list_name|
  json = JSON.parse(store.last_response.body)
  top_level_list = json["#{list_name}"]
  assert_not_nil (top_level_list)
  top_level_list.class.should == Array
end

Then /^the response should contain a JSON object "([^\"]*)"$/ do |object_key|
  json = JSON.parse(store.last_response.body)
  assert_not_nil (json["#{object_key}"])
end

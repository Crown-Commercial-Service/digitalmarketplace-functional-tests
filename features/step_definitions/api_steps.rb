# encoding: utf-8
require "ostruct"
require "rest_client"
require "json"
require "test/unit"

include Test::Unit::Assertions


Given /^I have opened a json file$/ do
  file = File.read('./fixtures/11111-g6-iaas-test-service.json')
  json = JSON.parse(file)
  @json = json
end


When /^I update the service name of the stored json file$/ do
  @json['services']['serviceName'] = 'NEW NAME '+Time.now.strftime('%Y%m%d%H%M%S')
end


Then /^The new json file has a new service name$/ do
  assert_equal @json['services']['serviceName'].start_with?("NEW NAME "),true
end

Given /^I have a random service from the API$/ do
  response = RestClient.get(
    "#{dm_api_domain}/services",
    params: {page: 1 + rand(dm_pagination_limit()), status: "published"},
    authorization: "Bearer #{dm_api_access_token}"
  )
  @service = JSON.parse(response)['services'][rand(dm_pagination_limit())]
  puts "Service ID: #{@service['id']}"
  puts "Service name: #{@service['serviceName']}"
end


Given /^I have a URL for "([^\"]*)"$/ do |app|
  app_domain = domain_for_app(app)
  assert_not_nil("#{app_domain}", "No URL supplied for #{app}")
  puts("DOMAIN  : #{app_domain}")
  @last_domain = app_domain
end


Given /^I have an auth token for "([^\"]*)"$/ do |app|
  app_token = access_token_for_app(app)
  assert_not_nil("#{app_token}", "No access token supplied for #{app}")
  puts("ACCESS TOKEN: #{app_token[0..2]}***#{app_token[-3..-1]}")
  @last_token = app_token
end


When /^I send a GET request with authorization to "([^\"]*)"$/ do |path|
  response = RestClient.get("#{@last_domain}#{path}",
    authorization: "Bearer #{@last_token}"){|response, request, result| response }  # Don't raise exceptions but return the response
  @last_response = response
end


When(/^I send a GET request to the home page$/) do
  response = RestClient.get("#{@last_domain}"){|response, request, result| response }  # Don't raise exceptions but return the response
  @last_response = response
end

# There is no version locally :/
When(/^I send a GET request to the "([^\"]*)" status page$/) do |path|
  response = RestClient.get("#{@last_domain}#{path}_status") { |response| response }
  puts "Release version: " + JSON.parse(response).fetch("version")
  @last_response = response
end


When(/^I send a GET request to "([^\"]*)"$/) do |path|
  response = RestClient.get("#{@last_domain}#{path}"){|response, request, result| response }  # Don't raise exceptions but return the response
  @last_response = response
end


Then /^the response code should be "([^\"]*)"$/ do |status|
  @last_response.code.should == status.to_i
end

Then /^the response should contain a JSON list of "([^\"]*)"$/ do |list_name|
  json = JSON.parse(@last_response.body)
  top_level_list = json["#{list_name}"]
  assert_not_nil (top_level_list)
  top_level_list.class.should == Array
end

Then /^the response JSON field "([^\"]*)" should be "([^\"]*)"$/ do |field, value|
  json = JSON.parse(@last_response.body)
  assert_equal json[field], value
end

Then /^the response should contain a JSON object "([^\"]*)"$/ do |object_key|
  json = JSON.parse(@last_response.body)
  assert_not_nil (json["#{object_key}"])
end

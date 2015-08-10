# encoding: utf-8
require "ostruct"
require "rest_client"

store = OpenStruct.new

UPDATER_JSON = '
{
    "update_details":
      {
          "updated_by": "Functional tests"
      }
}
'

Given /^I am at '(.*)'$/ do |path|
  visit "#{dm_frontend_domain}/#{path}"
end

Given /^I am at the g7 supplier dashboard page$/ do
  visit "#{dm_frontend_domain}/suppliers/frameworks/g-cloud-7"
end

Given /^I am at the g7 services page$/ do
  visit "#{dm_frontend_domain}/suppliers/frameworks/g-cloud-7/services"
end

Given /^I am on the summary page$/ do
  visit("#{dm_frontend_domain}/suppliers/submission/services/#{store.current_listing}")
end

Given /^I am on ssp page '(.+)'$/ do |page_name|
  visit("#{dm_frontend_domain}/suppliers/submission/services/#{store.current_listing}/edit/#{page_name}/")
end

Given /^The service is deleted$/ do
  delete_url = dm_api_domain + "/draft-services/#{store.current_listing}"
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}

  response = RestClient::Request.execute(method: :delete, url: delete_url,
                              payload: UPDATER_JSON, headers: headers)

  # response = RestClient.delete(url, UPDATER_JSON, headers){|response, request, result| response }  # Don't raise exceptions but return the response
  response.code.should == 200
end

When /^I click my service$/ do
  # Find link with the current listing in the href
  find(:xpath, "//a[contains(@href, '/#{store.current_listing}')]").click
end

When /^I choose '(.*)'$/ do |label|
  choose label
end

When /^I check '(.*)'$/ do |label|
  check label
end

When /^I fill in '(.*)' with '(.*)'$/ do |label, value|
  fill_in(label, :with => value)
end

When /^I fill in '(.*)' with:$/ do |label, value|
  fill_in(label, :with => value)
end

When /^I select '(.*)' from '(.*)'$/ do |option, selector|
  select(option, from: selector)
end

When /^I choose file '(.*)' for '(.*)'$/ do |file, label|
  attach_file(label, File.join(Dir.pwd, 'fixtures', file))
end

Then /^I should be on the supplier home page$/ do
  URI.parse(current_url).path.should == "/suppliers"
end

Then /^I should be on the g7 supplier dashboard page$/ do
  URI.parse(current_url).path.should == "/suppliers/frameworks/g-cloud-7"
end

Then /^I should be on the g7 services page$/ do
  URI.parse(current_url).path.should == "/suppliers/frameworks/g-cloud-7/services"
end

Then /^I should be on the '(.*)' page$/ do |title|
  find('h1').should have_content(/#{title}/i)
  parts = URI.parse(current_url).path.split('/')
  while not /^\d+$/.match(parts.last)
    parts.pop
  end
  store.current_listing = parts.pop
end

Then /^My service should be in the list$/ do
  page.should have_selector(:xpath, "//a[@href='/suppliers/submission/services/#{store.current_listing}']")
end

Then /^My service should not be in the list$/ do
  page.should have_no_selector(:xpath, "//a[@href='/suppliers/submission/services/#{store.current_listing}']")
end

Then /^The string '(.*)' should not be on the page$/ do |string|
  page.should have_no_content(string)
end

Then /^The string '(.*)' should be on the page$/ do |string|
  page.should have_content(string)
end

Then /^Summary row '(.*)' should contain '(.*)'$/ do |question, text|
  find(
    :xpath,
    "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
  ).should have_content(text)
end

Then /^Summary row '(.*)' should not contain '(.*)'$/ do |question, text|
  find(
    :xpath,
    "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
  ).should have_no_content(text)
end

Then /^Summary row '(.*)' should not be empty$/ do |question|
  find(
    :xpath,
    "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
  ).text.should_not == ''
end

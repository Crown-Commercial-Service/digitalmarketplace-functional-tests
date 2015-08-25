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

Then /I am on the '(.*)' page$/ do |page_name|
  if page_name == 'Create suppllier account'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/create")
    page.should have_link('www.dnb.co.uk/dandb-duns-number')
    page.should have_link('beta.companieshouse.gov.uk/help/welcome')
    page.should have_button('Start')
  elsif page_name == 'DUNS number'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/duns-number")
    page.should have_link('Find out how to get a DUNS number')
    page.should have_button('Continue')
  elsif page_name == 'Companies House number (optional)'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/companies-house-number")
    page.should have_link('Visit Companies House to get your number')
    page.should have_button('Continue')
  elsif page_name == 'Company contact details'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/company-contact-details")
    page.should have_field('contact_name')
    page.should have_field('email_address')
    page.should have_field('phone_number')
    page.should have_button('Continue')
  end
end

When /I submit a '(.*)' that is '(.*)'$/ do |field_name,value|
  if field_name == 'DUNS number'
    if value == 'not unique'
      step "I enter '123456789' in the 'duns_number' field"
    elsif value == 'unique'
      step "I enter '000000001' in the 'duns_number' field"
    end
  elsif field_name == 'Companies House number'
    if value == 'invalid'
      step "I enter 'a@1234-' in the 'companies_house_number' field"
    elsif value == 'valid'
      step "I enter 'A0000001' in the 'companies_house_number' field"
    end
  elsif field_name == 'Company name'
    if value == 'blank'
      step "I enter '' in the 'company_name' field"
    elsif value == 'valid'
      step "I enter 'This is a test company name' in the 'company_name' field"
    end
  end
  step "I click 'Continue'"
end

Then /I am presented with '(.*)' validation message$/ do |field_name|
  if field_name == 'DUNS number'
    steps %{
      Then I am presented with the message 'A supplier account already exists with that #{field_name}'
      And I am presented with the message 'If you no longer have your account details, or if you think this may be an error, please contact enquiries@digitalmarketplace.service.gov.uk'
    }
    page.should have_link('enquiries@digitalmarketplace.service.gov.uk')
    step "I am presented with the message '#{field_name} already used'"
  elsif field_name == 'Companies House number'
    step "I am presented with the message '#{field_name}s must have 8 characters.'"
  elsif field_name == 'company name'
    step "I am presented with the message 'You must provide a #{field_name}.'"
  elsif field_name == 'Company contact details'
    steps %{
      Then I am presented with the message 'There was a problem with the details you gave for:'
      Then I am presented with the message 'You must provide a contact name.'
      And I am presented with the message 'You must provide a email address.'
      And I am presented with the message 'You must provide a phone number.'
    }
  end
end

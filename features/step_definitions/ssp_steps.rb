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
  elsif page_name == 'Create login'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/create-your-account")
    page.should have_button('Continue')
  elsif page_name == 'Check your information'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/company-summary")
    page.should have_button('Create account')
  end
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
end

And /All company information that were submitted is presented correctly on the page$/ do
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'DUNS number')]/../../*/span[contains(text(), '#{@value_of_interest['duns_number']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Companies House number')]/../../*/span[contains(text(), '#{@value_of_interest['companies_house_number']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Company name')]/../../*/span[contains(text(), '#{@value_of_interest['company_name']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Primary contact name')]/../../*/span[contains(text(), '#{@value_of_interest['contact_name']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Primary contact email')]/../../*/span[contains(text(), '#{@value_of_interest['email_address']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Primary contact phone number')]/../../*/span[contains(text(), '#{@value_of_interest['phone_number']}')]")
  page.should have_selector(:xpath, "//tr/*/span[contains(text(), 'Email address')]/../../*/span[contains(text(), '#{@value_of_interest['email_address']}')]")
end

And /There is an Edit link for each of the company information$/ do
  page.find(:xpath, "//tr/*/span[contains(text(), 'DUNS number')]/../..//a[@href='/suppliers/duns-number'][text()]").text().should have_content('Edit')
  page.find(:xpath, "//tr/*/span[contains(text(), 'Companies House number')]/../..//a[@href='/suppliers/companies-house-number']").text().should have_content('Edit')
  page.find(:xpath, "//tr/*/span[contains(text(), 'Company name')]/../..//a[@href='/suppliers/company-name']").text().should have_content('Edit')
  page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact name')]/../..//a[@href='/suppliers/company-contact-details']").text().should have_content('Edit')
  page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact email')]/../..//a[@href='/suppliers/company-contact-details']").text().should have_content('Edit')
  page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact phone number')]/../..//a[@href='/suppliers/company-contact-details']").text().should have_content('Edit')
end

When /I change the '(.*)' to '(.*)'$/ do |field_name,new_value|
  if field_name == 'duns_number'
    page.find(:xpath, "//tr/*/span[contains(text(), 'DUNS number')]/../..//a[@href='/suppliers/#{field_name.gsub('_','-').downcase}'][text()='Edit']").click
  elsif field_name == 'companies_house_number'
    page.find(:xpath, "//tr/*/span[contains(text(), 'Companies House number')]/../..//a[@href='/suppliers/#{field_name.gsub('_','-').downcase}'][text()='Edit']").click
  elsif field_name == 'contact_name'
    page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact name')]/../..//a[@href='/suppliers/company-contact-details'][text()='Edit']").click
  elsif field_name == 'contact_email_address'
    page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact email')]/../..//a[@href='/suppliers/company-contact-details'][text()='Edit']").click
    field_name = 'email_address'
  elsif field_name == 'phone_number'
    page.find(:xpath, "//tr/*/span[contains(text(), 'Primary contact phone number')]/../..//a[@href='/suppliers/company-contact-details'][text()='Edit']").click
  elsif field_name == 'your_email_address'
    page.find(:xpath, "//tr/*/span[contains(text(), 'Email address')]/../..//a[@href='/suppliers/create-your-account'][text()='Edit']").click
    field_name = 'email_address'
  else
    page.find(:xpath, "//tr/*/span[contains(text(), '#{field_name.gsub('_',' ').downcase}')]/../..//a[@href='/suppliers/#{field_name.gsub('_','-').downcase}'][text()='Edit']").click
  end
  steps %{
    When I enter '#{new_value}' in the '#{field_name}' field
    And I click 'Continue'
  }
  page.visit("#{dm_frontend_domain}/suppliers/company-summary")
end

Then /The change made is reflected on the '(.*)' page$/ do |value|
  step "And All company information that were submitted is presented correctly on the page"
end

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
  visit URI.join("#{dm_frontend_domain}", "#{path}")
end

Given /^I am at the '(.*)' page$/ do |page_name|
  if page_name == 'Your Digital Outcomes and Specialists services' or page_name == 'Your G-Cloud 7 services'
    set_service_type = ''
  else
    set_service_type = store.service_type
  end
  visit "#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{set_service_type}"
  page.should have_content(page_name)
end

Given /^I am on the summary page$/ do
  visit "#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.current_listing}"
end

Given /^I am on the service name page for '(.*)'$/ do |lot_name|
  visit("#{dm_frontend_domain}/suppliers/frameworks/g-cloud-7/submissions/#{lot_name}/create")
end

Given /^I am on the ssp page for the '(.+)' service$/ do |page_name|
  visit("#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{page_name}/#{store.current_listing}")
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

And /^There '(.*)' draft '(.*)' service\(s\)$/ do |availability,service|
  service_type = URI.parse(current_url).path.split('submissions/').last.split('/').first
  if service_type == ''
    if "#{availability.downcase}" == 'is no' or "#{availability.downcase}" == 'are no'
      page.should have_no_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),' draft service')]")
      page.should have_no_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'Started but not complete')]")
    else
      if store.framework_name == 'digital-outcomes-and-specialists' and store.service_type == 'user-research-studios'
        page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'#{store.draft_count} draft lab')]")
      elsif store.framework_name == 'g-cloud-7'
        page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'#{store.draft_count} draft service')]")
      end
      page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'Started but not complete')]")
    end
  else
    store.draft_count = page.all(:xpath, "//caption[contains(text(),'Draft services')]//following-sibling::*/tr[@class='summary-item-row']").count
    if "#{availability.downcase}" == 'is no'
      page.should have_no_selector(:xpath, ".//span/a[contains(@href,'#{store.current_listing}') and contains(text(),'#{service}')]")
    elsif "#{availability.downcase}" == 'is a'
      if service.include?('COPY OF DRAFT-')
        page.should have_selector(:xpath, ".//table/caption[contains(text(),'Draft services')]/..//span/a[contains(@href,'#{store.copy_of_draft_listing}') and contains(text(),'#{service}')]")
      elsif service.include?('COPY OF COMPLETED-')
        page.should have_selector(:xpath, ".//table/caption[contains(text(),'Draft services')]/..//span/a[contains(@href,'#{store.copy_of_completed_listing}') and contains(text(),'#{service}')]")
      else
        page.should have_selector(:xpath, ".//table/caption[contains(text(),'Draft services')]/..//span/a[contains(@href,'#{store.current_listing}') and contains(text(),'#{service}')]")
      end
    end
  end
end

When /^I click the link for '(.*)'$/ do |target_service|
  case target_service
  when 'my service'
    service_listing = store.current_listing
  when 'my completed service'
    service_listing = store.completed_listing
  when 'my copy of draft service'
    service_listing = store.copy_of_draft_listing
  when 'my copy of completed service'
    service_listing = store.copy_of_completed_listing
  end
  # Find link with the current listing in the href
  find(:xpath, "//a[contains(@href, '/#{service_listing}')]").click
end


When /^I click my service$/ do
  # Find link with the current listing in the href
  find(:xpath, "//a[contains(@href, '/#{store.current_listing}')]").click
end

# When /^I click my completed service$/ do
#   # Find link with the completed listing in the href
#   find(:xpath, "//a[contains(@href, '#{store.completed_listing}')]").click
# end

And /^I check '(.*)' for '(.*)'$/ do |label,field_name|
  within "##{field_name}" do
    check label
  end
end

And /^I uncheck '(.*)' for '(.*)'$/ do |label,field_name|
  within "##{field_name}" do
    uncheck label
  end
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

Then /^I am returned to the '(.*)' page$/ do |service_type_services|
  URI.parse(current_url).path.should == "/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}"
end

Then /^I am taken to the '(.*)' page$/ do |page_name|
  find('h1').should have_content(/#{page_name}/i)
end

Then /^I should be on the '(.*)' page$/ do |title|
  find('h1').should have_content(/#{title}/i)
  parts = URI.parse(current_url).path.split('/')
  store.current_listing = (parts.select {|v| v =~ /^\d+$/}).last
  store.framework_name = URI.parse(current_url).path.split('frameworks/').last.split('/').first
  store.service_type = URI.parse(current_url).path.split('submissions/').last.split('/').first
end

Then /^My service should be in the list$/ do
  page.should have_selector(:xpath, "//a[@href='/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.current_listing}']")
end

Then /^My service should not be in the list$/ do
  page.should have_no_selector(:xpath, "//a[@href='/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.current_listing}']")
end

Then /^The string '(.*)' should not be on the page$/ do |string|
  page.should have_no_content(string)
end

Then /^The '(.*)' button should be on the page$/ do |string|
  page.should have_selector(:xpath, "//input[@class='button-save'][@value='#{string}']")
end

Then /^The '(.*)' button should not be on the page$/ do |string|
  page.should have_no_selector(:xpath, "//input[@class='button-save'][@value='#{string}']")
end

Then /^The string '(.*)' should be on the page$/ do |string|
  page.should have_content(string)
end

Then /^Summary row '(.*)' under '(.*)' should contain '(.*)'$/ do |question,table_name, text|
  if ['Individual specialist roles','Team capabilities'].include? table_name
    page.find(
      :xpath,
      "//*/table/caption[contains(text(),'#{table_name}')]/../..//span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span/*"
    ).should have_content("#{text}")
  else
    page.find(
      :xpath,
      "//*/table/caption[contains(text(),'#{table_name}')]/../..//span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
    ).should have_content("#{text}")
  end
end

Then /^Multi summary row '(.*)' under '(.*)' should contain '(.*)'$/ do |question,table_name, text|
    find(
      :xpath,
      "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
    ).should have_content("#{text}")
end

Then /^Multi summary row '(.*)' under '(.*)' should not contain '(.*)'$/ do |question,table_name, text|
    find(
      :xpath,
      "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
    ).should have_no_content("#{text}")
end

Then /^Summary row '(.*)' under '(.*)' should not contain '(.*)'$/ do |question,table_name,text|
  find(
    :xpath,
    "//*/span[contains(text(),'#{question}')]/../../td[@class='summary-item-field']/span"
  ).should have_no_content(text)
end

Then /^Summary row '(.*)' under '(.*)' should not be empty$/ do |question,table_name|
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

And /All the information that was submitted is presented correctly on the page$/ do
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
  step "And All the information that was submitted is presented correctly on the page"
end

And /^There '(.*)' completed '(.*)' service\(s\)$/ do |availability,service|
  service_type = URI.parse(current_url).path.split('submissions/').last.split('/').first

  if service_type == ''
    if "#{availability.downcase}" == 'is no' or "#{availability.downcase}" == 'are no'
      page.should have_no_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),' lab marked as complete')]")
      page.should have_no_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'Marked as complete')]")
      page.should have_no_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'You can edit it until the deadline')]")
    else
      if store.framework_name == 'digital-outcomes-and-specialists' and store.service_type == 'user-research-studios'
        page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'#{store.completed_count} lab will be submitted')]")
      elsif store.framework_name == 'g-cloud-7'
        page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'Marked as complete')]")
      end
      page.should have_selector(:xpath, ".//li//span[contains(text(),'#{service}')]/../../*/p[contains(text(),'You can edit it until the deadline')]")
    end
  else
    store.completed_count = page.all(:xpath, "//caption[contains(text(),'Complete services')]//following-sibling::*/tr[@class='summary-item-row']").count
    if "#{availability.downcase}" == 'is no'
      page.should have_no_selector(:xpath, ".//table/caption[contains(text(),'Complete services')]/..//span/a[contains(@href,'#{store.completed_listing}') and contains(text(),'#{service}')]")
      page.should have_no_selector(:xpath, ".//table/caption[contains(text(),'Complete services')]/..//span/a[contains(@href,'#{store.current_listing}') and contains(text(),'#{service}')]")
    elsif "#{availability.downcase}" == 'is a'
      if store.completed_listing != ''
        page.should have_selector(:xpath, ".//table/caption[contains(text(),'Complete services')]/..//span/a[contains(@href,'#{store.completed_listing}') and contains(text(),'#{service}')]")
      else
        page.should have_selector(:xpath, ".//table/caption[contains(text(),'Complete services')]/..//span/a[contains(@href,'#{store.current_listing}') and contains(text(),'#{service}')]")
      end
    end
  end
end

When /^I click the '(.*)' button at the '(.*)' of the page$/ do |button,location|
  store.completed_listing = store.current_listing
  case location
    when 'top'
      page.first(:xpath, "//input[contains(@class,'button-save') and contains(@value,'#{button}')]").click
    else 'bottom'
      page.find(:xpath, "//div[3]//input[contains(@class,'button-save') and contains(@value,'#{button}')]").click
    end
end

When /^I click the '(.*)' button for the '(.*)' service '(.*)'$/ do |button,service_state,service_name|
  page.find(:xpath, "//a[contains(text(),'#{service_name}')]/../../..//button[contains(text(),'#{button}')]").click
  parts = URI.parse(current_url).path.split('/')
  copied_listing = (parts.select {|v| v =~ /^\d+$/}).last
  if service_state == 'draft'
    store.copy_of_draft_listing = copied_listing
  elsif service_state == 'completed'
    store.copy_of_completed_listing = copied_listing
  end
end

Given /^I am on the summary page for the copy of the '(.*)' service$/ do |service_state|
  if service_state == 'draft'
    visit "#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.copy_of_draft_listing}"
  elsif service_state == 'completed'
    visit "#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.copy_of_completed_listing}"
  end
end

Given /^I am on the summary page of the completed service$/ do
  visit "#{dm_frontend_domain}/suppliers/frameworks/#{store.framework_name}/submissions/#{store.service_type}/#{store.completed_listing}"
end

When /^I delete the '(.*)' service$/ do |service_name|
  steps %Q{
    Given I click '#{service_name}'
    Then I click 'Delete'
    And I click 'Yes, delete'
  }
end

# encoding: utf-8
require "ostruct"
require "rest_client"

Before('@logoutfirst') do
  if page.has_content?('Log out') or page.has_content?('Logout')
    find(
      :xpath,
      "//a[contains(@href, '/logout')]"# and contains (text(), 'Log out')]"
    ).click
  end
end

After('@logoutafter') do
  page.click_link_or_button('Log out')
end

Given /I am on the '(.*)' login page$/ do |user_type|
  if user_type == 'Administrator'
    visit("#{dm_frontend_domain}/admin/login")
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Username')
    page.should have_content('Password')
    page.has_button?('Log in')
  else user_type == 'Supplier'
    visit("#{dm_frontend_domain}/#{user_type.downcase}s/login")
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Email address')
    page.should have_content('Password')
    page.has_button?('Log in')
  end
end

When /I login as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    fill_in('username', :with => (eval "dm_admin_uname"))
    fill_in('password', :with => (eval "dm_admin_pass"))
    click_link_or_button('Log in')
  else user_type == 'Supplier'
    fill_in('email_address', :with => (eval "dm_supplier_uname"))
    fill_in('password', :with => (eval "dm_supplier_pass"))
    click_link_or_button('Log in')
  end
end

Then /I am presented with the '(.*)' page$/ do |page_name|
  page.should have_content(page_name)
  page.should have_content('Log out')
  page.should have_content('Service ID')
end

When /I enter '(.*)' in the '(.*)' field$/ do |value,field_name|
  fill_in(field_name, with: value)
  @serviceID = value
end

And /I click the '(.*)' button$/ do |button_name|
  click_link_or_button(button_name)
end

Then /I am presented with the summary page for that service$/ do
  @existing_values = @existing_values || Hash.new
  @existing_values['summarypageurl'] = current_url

  current_url.should have_content(@serviceID)
  page.should have_content('Service attributes')
  page.should have_content('Description')
  page.should have_content('Features and benefits')
  page.should have_content('Pricing')
  page.should have_content('Documents')

  servicename = find(
    :xpath,
    "//*[contains(text(), 'Service name')]/following-sibling::*[1]"
  ).text()
  @existing_values['servicename'] = servicename

  servicesummary = find(
    :xpath,
    "//*[contains(text(), 'Service summary')]/following-sibling::*[1]"
  ).text()
  @existing_values['servicesummary'] = servicesummary

  if @serviceID.include?('-G')
    @existing_values['servicefeature3'] = ''
    @existing_values['servicebenefits2'] = ''
  else
    servicefeature3 = find(
      :xpath,
      "//*[contains(text(), 'Service features')]/following-sibling::*[1]/ul/li[3]"
    ).text()
    @existing_values['servicefeature3'] = servicefeature3

    servicebenefits2 = find(
      :xpath,
      "//*[contains(text(), 'Service benefits')]/following-sibling::*[1]/ul/li[2]"
    ).text()
    @existing_values['servicebenefits2'] = servicebenefits2
  end

  serviceprice = find(
    :xpath,
    "//*[contains(text(), 'Service price')]/following-sibling::*[1]"
  ).text()
  @existing_values['serviceprice'] = serviceprice

  vatincluded = find(
    :xpath,
    "//*[contains(text(), 'VAT included')]/following-sibling::*[1]"
  ).text()
  @existing_values['vatincluded'] = vatincluded

  educationpricing = find(
    :xpath,
    "//*[contains(text(), 'Education pricing')]/following-sibling::*[1]"
  ).text()
  @existing_values['educationpricing'] = educationpricing

  terminationcost = find(
    :xpath,
    "//*[contains(text(), 'Termination cost')]/following-sibling::*[1]"
  ).text()
  @existing_values['terminationcost'] = terminationcost

  trialoption = find(
    :xpath,
    "//*[contains(text(), 'Trial option')]/following-sibling::*[1]"
  ).text()
  @existing_values['trialoption'] = trialoption

  freeoption = find(
    :xpath,
    "//*[contains(text(), 'Free option')]/following-sibling::*[1]"
  ).text()
  @existing_values['freeoption'] = freeoption

  minimumcontractperiod = find(
    :xpath,
    "//*[contains(text(), 'Minimum contract period')]/following-sibling::*[1]"
  ).text()
  @existing_values['minimumcontractperiod'] = minimumcontractperiod

  pricingdocument = find(
    :xpath,
    "//*[contains(text(), 'Pricing document')]/following-sibling::*[1]"
  ).text()
  @existing_values['pricingdocument'] = pricingdocument
end

Given /I have logged in to Digital Marketplace as a '(.*)' user$/ do |user_type|
  steps %Q{
    Given I am on the '#{user_type}' login page
    When I login as a '#{user_type}' user
  }
end

Given /I am logged in as an '(.*)' and am on the '(.*)' service summary page$/ do |user_type,value|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    When I enter '#{value}' in the 'Service ID' field
    When I click 'Find service'
    Then I am presented with the summary page for that service
  }
end

Then /I am logged out of Digital Marketplace as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    page.should have_content('You have been logged out')
    page.should have_content('Username')
  else user_type == 'Supplier'
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Email address')
  end
  page.should have_content("#{user_type}" ' login')
  page.should have_content('Password')
  page.has_button?('Log in')
end

Given /I click the '(.*)' link for '(.*)' on the service summary page$/ do |action,service_aspect|
  find(
    :xpath,
    "//a[@href = '/admin/services/#{@serviceID.downcase}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}']"
  ).click
end

Then /I am presented with the '(.*)' '(.*)' page for that service$/ do |action,service_aspect|
  current_url.should end_with("#{@existing_values['summarypageurl']}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}")

  if service_aspect == 'Description'
    page.should have_content(service_aspect)
    page.should have_content('Service name')
    page.should have_content('Service summary')
  elsif service_aspect == 'Features and benefits'
    page.should have_content(service_aspect)
    page.should have_content('Service features')
    page.should have_content('Service benefits')
  elsif service_aspect == 'Pricing'
    page.should have_content(service_aspect)
    page.should have_content('Service price')
    page.should have_content('VAT included')
    page.should have_content('Education pricing')
    page.should have_content('Termination cost')
    page.should have_content('Trial option')
    page.should have_content('Free option')
    page.should have_content('Minimum contract period')
  else service_aspect == 'Documents'
    page.should have_content(service_aspect)
    page.should have_content('Service definition document')
    page.should have_content('Please upload your terms and conditions document')
    page.should have_content('Skills Framework for the Information Age (SFIA) rate card')
    page.should have_content('Pricing document')
  end
end

When /I change '(.*)' to '(.*)'$/ do |field_to_change,new_value|
  if page.has_content?('Features and benefits')
    page.find(
      :xpath,
      "//*[contains(@id, '#{field_to_change.split('-').last}') and contains(@name, '#{field_to_change.split('-').first}')]"
    ).set(new_value)
  else
    page.find(
      :xpath,
      "//*[contains(@id, '#{field_to_change}')]"
    ).set(new_value)
  end
  @changed_fields = @changed_fields || Hash.new
  @changed_fields[field_to_change] = new_value
end

And /I set '(.*)' as '(.*)'$/ do |field_to_change,new_value|
  within "##{field_to_change}" do
    page.find("option[value=#{new_value}]").select_option
  end
  @changed_fields[field_to_change] = new_value.downcase
end

And /I choose '(.*)' for '(.*)'$/ do |new_value,field_to_change|
  if field_to_change == 'minimumContractPeriod'
    find(
      :xpath,
      "//*[contains(@name, '#{field_to_change}') and contains(@value, '#{new_value}')]"
    ).click
  else
    choose("#{field_to_change}-#{new_value.downcase}")
  end
  @changed_fields[field_to_change] = new_value
end

And /I remove service benefit number 2$/ do
  @changed_fields['serviceBenefits-2'] = find(
    :xpath,
    "//*[contains(@id, 'serviceBenefits-2')]"
  ).value()
  click_link_or_button('service benefit number 2', visible: false)
end

And /I add '(.*)' as a '(.*)'$/ do |value,item_to_add|
  record_number_to_add = (10 - ((find(
    :xpath,
    "//button[contains(text(), 'Add another service feature')]"
  ).text()).split('Add another service feature (').last.split(' remaining').first).to_i)

  find(
    :xpath,
    "//button[contains(text(), 'Add another service feature')]"
  ).click

  find(
    :xpath,
    "//*[contains(@id, '#{record_number_to_add}') and contains(@name, '#{item_to_add}')]"
  ).set(value)

  @changed_fields[item_to_add] = value
end

Then /I am presented with the summary page with the changes that were made to the '(.*)'$/ do |service_aspect|
  current_url.should end_with(@existing_values['summarypageurl'])
  if service_aspect == 'Description'
    page.should have_content(@changed_fields['serviceName-text-box'])
    page.should have_content(@changed_fields['serviceSummary-text-box'])
  elsif service_aspect == 'Features and benefits'
    page.should have_content(@changed_fields['serviceFeatures-3'])
    page.should have_no_content(@changed_fields['serviceBenefits-2'])
    page.should have_content(@changed_fields['serviceFeatures'])
  elsif service_aspect == 'Pricing'
    find(
      :xpath,
      "//*[contains(text(), 'Service price')]/following-sibling::*[1]"
    ).text().should have_content("£#{@changed_fields['priceMin']} to £#{@changed_fields['priceMax']} per #{@changed_fields['priceUnit']} per #{@changed_fields['priceInterval']}")
    find(
      :xpath,
      "//*[contains(text(), 'VAT included')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['vatIncluded'])
    find(
      :xpath,
      "//*[contains(text(), 'Education pricing')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['educationPricing'])
    find(
      :xpath,
      "//*[contains(text(), 'Termination cost')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['terminationCost'])
    find(
      :xpath,
      "//*[contains(text(), 'Trial option')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['trialOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Free option')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['freeOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Minimum contract period')]/following-sibling::*[1]"
    ).text().should have_content(@changed_fields['minimumContractPeriod'])

  elsif service_aspect == 'Documents'
    page.should have_no_content(@existing_values['pricingdocument'])
    @newpricingdocument = find(
      :xpath,
      "//*[contains(text(), 'Pricing document')]/following-sibling::*[1]"
    ).text()

    if @newpricingdocument == @existing_values['pricingdocument']
      raise "The pricing document has not been changed as expected"
    end
  end
end

When /I change '(.*)' file to '(.*)'$/ do |document_to_change,new_document|
  find(
    :xpath,
    "//*[contains(@name, '#{document_to_change}')]"
  ).click
  attach_file(document_to_change, File.join(Dir.pwd, 'fixtures', new_document))
end

When /I click '(.*)'$/ do |button_link_name|
  page.click_link_or_button(button_link_name)
end

When /I navigate to the '(.*)' '(.*)' page$/ do |action,service_aspect|
  step "I click the '#{action}' link for '#{service_aspect}' on the service summary page"
  if service_aspect == 'Description'
    page.should have_content(service_aspect)
    page.should have_content('Service name')
    page.should have_content('Service summary')
  elsif service_aspect == 'Features and benefits'
    page.should have_content(service_aspect)
    page.should have_content('Service features')
    page.should have_content('Service benefits')
  elsif service_aspect == 'Pricing'
    page.should have_content(service_aspect)
    page.should have_content('Service price')
    page.should have_content('VAT included')
    page.should have_content('Education pricing')
    page.should have_content('Trial option')
    page.should have_content('Free option')
    page.should have_content('Minimum contract period')
  else service_aspect == 'Documents'
    page.should have_content(service_aspect)
    page.should have_content('Service definition document')
    page.should have_content('Please upload your terms and conditions document')
    page.should have_content('Skills Framework for the Information Age (SFIA) rate card')
    page.should have_content('Pricing document')
  end
end

Then /I am presented with the summary page with no changes made to the '(.*)'$/ do |service_aspect|
  current_url.should end_with(@existing_values['summarypageurl'])
  page.should have_content(@existing_values['servicename'])
  page.should have_content(@existing_values['servicesummary'])
  page.should have_content(@existing_values['servicefeature3'])
  page.should have_content(@existing_values['servicebenefits2'])
  page.should have_content(@existing_values['serviceprice'])
  page.should have_content(@existing_values['vatincluded'])
  page.should have_content(@existing_values['educationpricing'])
  page.should have_content(@existing_values['terminationcost'])
  page.should have_content(@existing_values['trialoption'])
  page.should have_content(@existing_values['freeoption'])
  page.should have_content(@existing_values['minimumcontractperiod'])
  page.should have_content(@existing_values['pricingdocument'])
end

#Visit service link currently not set to go to correct place.
Then /I am presented with the service details page for that service$/ do
  visit("#{dm_frontend_domain}/g-cloud/services/#{@serviceID}")
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/services/#{@serviceID}")
  page.should have_content(@existing_values['servicename'])
  page.should have_content(@existing_values['servicesummary'])
  page.should have_content(@existing_values['servicefeature3'])
  page.should have_no_content('2nd service benefit')
  page.should have_content(@existing_values['serviceprice'])
end

Then /I am presented with the '(.*)' supplier dashboard page$/ do |supplier_name|
  page.should have_content(supplier_name)
  page.should have_content('Logout')
  page.should have_content(eval "dm_supplier_uname")
end

Given /I am logged in as a '(.*)' '(.*)' user and am on the dash board page$/ do |supplier_name,user_type|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    Then I am presented with the '#{supplier_name}' supplier dashboard page
  }
end

Then /I can see all my listings ordered by lot name followed by listing name$/ do
  service_listed_and_in_correct_order("1123456789012346","1")
  service_listed_and_in_correct_order("1123456789012350","2")
  service_listed_and_in_correct_order("1123456789012347","3")
  service_listed_and_in_correct_order("1123456789012351","4")
  service_listed_and_in_correct_order("1123456789012348","5")
  service_listed_and_in_correct_order("1123456789012352","6")
  service_listed_and_in_correct_order("1123456789012349","7")
  service_listed_and_in_correct_order("1123456789012353","8")
end

def service_listed_and_in_correct_order (service_id,order_number)
  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  service_url = "#{url}/services/#{service_id}"
  response = RestClient.get(service_url, headers){|response, request, result| response }
  json = JSON.parse(response)
  service_name = json["services"]["serviceName"]
  service_lot = json["services"]["lot"]
  xpath_to_check = find(:xpath, "//*[@id='content']/table/tbody/tr[#{order_number}][td/text()]").text()

  if response.code == 404
    puts "Service #{service_id} does not exist"
  else
    xpath_to_check.should have_content("#{service_name}")
    xpath_to_check.should have_content("#{service_lot}")
  end
end

When /I select the second listing from the dashboard$/ do
  @data_store = @data_store || Hash.new

  servicename = find(
    :xpath,
    "//*[@id='content']/table/tbody/tr[2]/td[1]/a"
  ).text()
  @data_store['servicename'] = servicename

  page.click_link_or_button(@data_store['servicename'])
  serviceid = URI.parse(current_url).to_s.split('service/').last
  @data_store['serviceid'] = serviceid
end

Then /I am presented with the listing page for that specific listing$/ do
  visit("#{dm_frontend_domain}/g-cloud/services/#{@data_store['serviceid']}")
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/services/#{@data_store['serviceid']}")
  page.should have_content(@data_store['servicename'])
end

When /I select '(.*)' as the service status$/ do |service_status|
  find(
    :xpath,
    "//*[contains(@name, 'service_status') and contains(@value, '#{service_status.downcase}')]"
  ).click
end

Then /The service status is set as '(.*)'$/ do |service_status|
  find(
    :xpath,
    "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
  ).text().should have_content(service_status)
end

And /I am presented with the message '(.*)'$/ do |message_text|
  page.should have_content(message_text)
end

Then /The status of the service is presented as '(.*)' on the supplier users dashboard$/ do |service_status|
  step "I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dash board page"
  service_exist_on_dashboard = find(:xpath,
    "//*[@id='content']/table/tbody/tr[1][td/text()]"
  ).text().should have_content('1123456789012346')

  if service_exist_on_dashboard == true
    find(:xpath,
      "//*[@id='content']/table/tbody/tr[1][td/text()]"
    ).text().should have_content("#{service_status}")
  end
end

And /The service '(.*)' be searched$/ do |ability|
  visit("#{dm_frontend_domain}/g-cloud/search?q=1123456789012346")
  if "#{ability.downcase}" == 'can'
    @existing_values = @existing_values || Hash.new
    page.should has_link(:xpath, "//a[contains(@href, '/services/1123456789012346')]")
    service_name = page.find(:xpath, "//a[contains(@href, '/services/1123456789012346')]/text()")
    @existing_values['service_name'] = service_name
  elsif "#{ability.downcase}" == 'can not'
    page.should has_no_link(:xpath, "//a[contains(@href, '/services/1123456789012346')]")
  end
end

And /The service details page '(.*)' be viewed$/ do |ability|
  visit("#{dm_frontend_domain}/g-cloud/services/1123456789012346")
  if "#{ability.downcase}" == 'can'
    page.should have_content(@existing_values['service_name'])
  elsif "#{ability.downcase}" == 'can not'
    page.should have_content(@existing_values['service_name'])
    page.should have_content('Page could not be found')
  end
end

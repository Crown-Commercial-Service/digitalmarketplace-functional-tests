# encoding: utf-8
require "ostruct"
require "rest_client"

After('@logout') do
  page.click_link_or_button('Log out')
end

Given /I am on the '(.*)' login page$/ do |user_type|
  if user_type == 'Administrator'
    visit("#{dm_frontend_domain}/admin/login")
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Username')
    page.should have_content('Password')
  else user_type == 'Suppliers'
    visit("#{dm_frontend_domain}/#{user_type.downcase}/login")
    page.should have_content('Email address')
    page.should have_content('Passphrase')
    page.should have_content('Login')
  end
end

When /I login as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    fill_in('username', :with => ENV['DM_ADMINISTRATORNAME'])
    fill_in('password', :with => ENV['DM_ADMINISTRATORPASSWORD'])
    click_link_or_button('Log in')
    page.should have_content('Log out')
    page.should have_content('Find a service')
    page.should have_content('Service ID')
  else user_type == 'Supplier'
    fill_in('email-address', :with => ENV['DM_SUPPLIEREMAIL'])
    fill_in('passphrase', :with => ENV['DM_SUPPLIERPASSPHRASE'])
    click_link_or_button('Login')
    page.should have_content('Dashboard')
  end
end

Then /I am presented with the '(.*)' page$/ do |page_name|
  page.should have_content(page_name)
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
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Username')
    page.should have_content('Password')
  else user_type == 'Suppliers'
    page.should have_content('Email address')
    page.should have_content('Passphrase')
    page.should have_content('Login')
  end
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
  #visit("#{store.existing_values['summarypageurl']}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}")
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
  visit("#{dm_frontend_domain}/services/#{@serviceID}")
  current_url.should end_with("#{dm_frontend_domain}/services/#{@serviceID}")
  page.should have_content(@existing_values['servicename'])
  page.should have_content(@existing_values['servicesummary'])
  page.should have_content(@existing_values['servicefeature3'])
  page.should have_no_content('2nd service benefit')
  page.should have_content(@existing_values['serviceprice'])
  #page.should have_content("£#{@existing_values['priceMin']} to £#{@existing_values['priceMax']} per #{@existing_values['priceUnit']} per #{@existing_values['priceInterval']}")
end

# encoding: utf-8
require "ostruct"
require "rest_client"

store = OpenStruct.new
store.changed_fields = store.changed_fields || Hash.new

Given /I am on the '(.*)' login page$/ do |user_type|
  if user_type == 'Administrator'
    visit("#{dm_admin_frontend_domain}/admin/login")
    page.should have_content("#{user_type}" ' login')
    page.should have_content('Username')
    page.should have_content('Password')
  else user_type == 'Suppliers'
    visit("#{dm_supplier_frontend_domain}/#{user_type.downcase}/login")
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
  store.serviceID = value
end

And /I click the '(.*)' button$/ do |button_name|
  click_link_or_button(button_name)
end

Then /I am presented with the summary page for that service$/ do
  store.existing_values = store.existing_values || Hash.new
  store.existing_values['summarypageurl'] = current_url

  current_url.should have_content(store.serviceID)
  page.should have_content('Service attributes')
  page.should have_content('Description')
  page.should have_content('Features and benefits')
  page.should have_content('Pricing')
  page.should have_content('Documents')

  servicename = find(
    :xpath,
    "//table[2]/tbody/tr[1]/td[2]"
  ).text()
  store.existing_values['servicename'] = servicename

  servicesummary = find(
    :xpath,
    "//table[2]/tbody/tr[2]/td[2]"
  ).text()
  store.existing_values['servicesummary'] = servicesummary

  if store.serviceID.include?('-G')
    store.existing_values['servicefeature2'] = ''
    store.existing_values['servicebenefits1'] = ''
  else
    servicefeature2 = find(
      :xpath,
      "//table[3]/tbody/tr[1]/td[2]/ul/li[1]"
    ).text()
    store.existing_values['servicefeature2'] = servicefeature2

    servicebenefits1 = find(
      :xpath,
      "//table[3]/tbody/tr[2]/td[2]/ul/li[1]"
    ).text()
    store.existing_values['servicebenefits1'] = servicebenefits1
  end

  serviceprice = find(
    :xpath,
    "//table[4]/tbody/tr[1]/td[2]"
  ).text()
  store.existing_values['serviceprice'] = serviceprice

  vatincluded = find(
    :xpath,
    "//table[4]/tbody/tr[2]/td[2]"
  ).text()
  store.existing_values['vatincluded'] = vatincluded

  educationpricing = find(
    :xpath,
    "//table[4]/tbody/tr[3]/td[2]"
  ).text()
  store.existing_values['educationpricing'] = educationpricing

  trialoption = find(
    :xpath,
    "//table[4]/tbody/tr[4]/td[2]"
  ).text()
  store.existing_values['trialoption'] = trialoption

  freeoption = find(
    :xpath,
    "//table[4]/tbody/tr[5]/td[2]"
  ).text()
  store.existing_values['freeoption'] = freeoption

  minimumcontractperiod = find(
    :xpath,
    "//table[4]/tbody/tr[6]/td[2]"
  ).text()
  store.existing_values['minimumcontractperiod'] = minimumcontractperiod

  pricingdocument = find(
    :xpath,
    "//table[5]/tbody/tr[4]/td[2]/a[@href]"
  ).text()
  store.existing_values['pricingdocument'] = pricingdocument
end

Given /I click the '(.*)' link for '(.*)'$/ do |action,service_aspect|
  find(
    :xpath,
    "//a[@href = '/admin/service/#{store.serviceID.downcase}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}']"
  ).click
end

Then /I am presented with the '(.*)' '(.*)' page for that service$/ do |action,service_aspect|
  current_url.should end_with("#{store.existing_values['summarypageurl']}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}")

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

When /I change '(.*)' to '(.*)'$/ do |field_to_change,new_value|
  if page.has_content?('Features and benefits')
    find(
      :xpath,
      "//*[contains(@id, '#{field_to_change.split('-').last}') and contains(@name, '#{field_to_change.split('-').first}')]"
    ).set(new_value)
  else
    find(
      :xpath,
      "//*[contains(@id, '#{field_to_change}')]"
    ).set(new_value)
  end

  store.changed_fields[field_to_change] = new_value
end

And /I set '(.*)' as '(.*)'$/ do |field_to_change,new_value|
  within "##{field_to_change}" do
    page.find("option[value=#{new_value}]").select_option
  end
  store.changed_fields[field_to_change] = new_value.downcase
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
  store.changed_fields[field_to_change] = new_value
end

And /I remove service benefit number 3$/ do
  store.changed_fields['serviceBenefits-3'] = find(
    :xpath,
    "//*[contains(@id, 'serviceBenefits-3')]"
  ).value()
  click_link_or_button('service benefit number 3', visible: false)
end

And /I add '(.*)' as a '(.*)'$/ do |value,item_to_add|
  record_number_to_add = (10 - ((find(
    :xpath,
    "//button[contains(text(), 'Add another service benefit')]"
  ).text()).split('Add another service benefit (').last.split(' remaining').first).to_i)

  find(
    :xpath,
    "//button[contains(text(), 'Add another service benefit')]"
  ).click

  find(
    :xpath,
    "//*[contains(@id, '#{record_number_to_add}') and contains(@name, '#{item_to_add}')]"
  ).set(value)

  store.changed_fields[item_to_add] = value
end

Then /I am presented with the summary page with the changes that were made to the '(.*)'$/ do |service_aspect|
  current_url.should end_with(store.existing_values['summarypageurl'])
  if service_aspect == 'Description'
    page.should have_content(store.changed_fields['serviceName-text-box'])
    page.should have_content(store.changed_fields['serviceSummary-text-box'])
  elsif service_aspect == 'Features and benefits'
    page.should have_content(store.changed_fields['serviceFeatures-1'])
    page.should have_no_content(store.changed_fields['serviceBenefits-3'])
    page.should have_content(store.changed_fields['serviceBenefits'])
  elsif service_aspect == 'Pricing'
    find(
      :xpath,
      "//*[contains(text(), 'Service price')]/following-sibling::*[1]"
    ).text().should have_content("£#{store.changed_fields['priceMin']} to £#{store.changed_fields['priceMax']} per #{store.changed_fields['priceUnit']} per #{store.changed_fields['priceInterval']}")
    find(
      :xpath,
      "//*[contains(text(), 'VAT included')]/following-sibling::*[1]"
    ).text().should have_content(store.changed_fields['vatIncluded'])
    find(
      :xpath,
      "//*[contains(text(), 'Education pricing')]/following-sibling::*[1]"
    ).text().should have_content(store.changed_fields['educationPricing'])
    find(
      :xpath,
      "//*[contains(text(), 'Trial option')]/following-sibling::*[1]"
    ).text().should have_content(store.changed_fields['trialOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Free option')]/following-sibling::*[1]"
    ).text().should have_content(store.changed_fields['freeOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Minimum contract period')]/following-sibling::*[1]"
    ).text().should have_content(store.changed_fields['minimumContractPeriod'])
  elsif service_aspect == 'Documents'
    page.should have_no_content(store.existing_values['pricingdocument'])
    store.newpricingdocument = find(
      :xpath,
      "//table[5]/tbody/tr[4]/td[2]/a[@href]"
    ).text()

    if store.newpricingdocument == store.existing_values['pricingdocument']
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

Given /I am on the '(.*)' '(.*)' page$/ do |action,service_aspect|
  visit("#{store.existing_values['summarypageurl']}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}")

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
  current_url.should end_with(store.existing_values['summarypageurl'])
  page.should have_content(store.existing_values['servicename'])
  page.should have_content(store.existing_values['servicesummary'])
  page.should have_content(store.existing_values['servicefeature2'])
  page.should have_content(store.existing_values['servicebenefits1'])
  page.should have_content(store.existing_values['serviceprice'])
  page.should have_content(store.existing_values['vatincluded'])
  page.should have_content(store.existing_values['educationpricing'])
  page.should have_content(store.existing_values['trialoption'])
  page.should have_content(store.existing_values['freeoption'])
  page.should have_content(store.existing_values['minimumcontractperiod'])
  page.should have_content(store.existing_values['pricingdocument'])
end

#Visit service link currently not set to go to correct place.
Then /I am presented with the service details page for that service$/ do
  visit("#{dm_admin_frontend_domain}/service/#{store.serviceID}")
  current_url.should end_with("#{dm_admin_frontend_domain}/service/#{store.serviceID}")
  page.should have_content(store.changed_fields['serviceName-text-box'])
  page.should have_content(store.changed_fields['serviceSummary-text-box'])
  page.should have_content(store.changed_fields['serviceFeatures-1'])
  page.should have_no_content(store.changed_fields['serviceBenefits-3'])
  page.should have_content("£#{store.changed_fields['priceMin']} to £#{store.changed_fields['priceMax']} per #{store.changed_fields['priceUnit']} per #{store.changed_fields['priceInterval']}")
end

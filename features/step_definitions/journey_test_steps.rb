# encoding: utf-8
require "ostruct"
require "rest_client"

Given /I am on the '(.*)' login page$/ do |user_type|
  if user_type == 'Administrator'
    visit("#{dm_frontend_domain}/admin/login")
    page.should have_content("#{user_type} login")
  elsif user_type == 'Supplier'
    visit("#{dm_frontend_domain}/#{user_type.downcase}s/login")
    page.should have_content('Log in to the Digital Marketplace')
  end
  page.should have_content('Email address')
  page.should have_content('Password')
  page.has_button?('Log in')
end

When /I login as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    page.fill_in('email_address', :with => (eval "dm_admin_uname"))
    page.fill_in('password', :with => (eval "dm_admin_pass"))
    click_link_or_button('Log in')
  elsif user_type == 'Supplier'
    page.fill_in('email_address', :with => (eval "dm_supplier_uname"))
    page.fill_in('password', :with => (eval "dm_supplier_pass"))
    click_link_or_button('Log in')
  end
end

And /The supplier user '(.*)' '(.*)' login to Digital Marketplace$/ do |user_name,ability|
  visit("#{dm_frontend_domain}/suppliers/login")
  if user_name == 'DM Functional Test Supplier User 2'
    page.fill_in('email_address', :with => (eval "dm_supplier2_uname"))
  elsif user_name == 'DM Functional Test Supplier User 3'
    page.fill_in('email_address', :with => (eval "dm_supplier3_uname"))
  end

  page.fill_in('password', :with => (eval "dm_supplier_pass"))
  click_link_or_button('Log in')

  if ability == 'can not'
    page.should have_content('Sorry, we couldn\'t log you in with that username and password.
      Accounts are locked after five failed attempts. If you think your account has been locked,
      please contact enquiries@digitalmarketplace.service.gov.uk.'
    )
  elsif ability == 'can'
    step "Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page"
  end
end

Then /I am presented with the admin '(.*)' page$/ do |page_name|
  page.should have_content(page_name)
  page.should have_content('Log out')
  page.should have_content('Find a service by service ID')
  page.should have_content('Find services by supplier ID')
  page.should have_content('Find users by supplier ID')
end

When /I enter that service\.(.*) in the '(.*)' field$/ do |attr_name, field_name|
  step "I enter '\"#{@service[attr_name]}\"' in the '#{field_name}' field"
end

When /I enter '(.*)' in the '(.*)' field$/ do |value,field_name|
  @value_of_interest = @value_of_interest || Hash.new
  @value_of_interest[field_name] = value
  page.fill_in(field_name, with: value)
  @servicesupplierID = value
end

And /I click the '(.*)' button$/ do |button_name|
  click_link_or_button(button_name)
end

When /I click the '(.*)' button for the supplier user '(.*)'$/ do |button_name,user_name|
  find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//button[contains(text(),'#{button_name}')]").click
end

When /I click the '(.*)' link for the service '(.*)'$/ do |link_name,value|
  find(:xpath, "//*[@class='summary-item-field-with-action']//a[contains(text(), '#{link_name}') and contains(@href, '#{value}')]").click
  @servicesupplierID = value
end

Then /I am presented with the summary page for that service$/ do
  @existing_values = @existing_values || Hash.new
  @existing_values['summarypageurl'] = current_url
  servicename = find(:xpath, "//h1").text()
  @existing_values['servicename'] = servicename
  serviceid = URI.parse(current_url).to_s.split('services/').last
  @existing_values['serviceid'] = serviceid

  if current_url.include?('suppliers')
    servicestatus = find(
      :xpath,
      "//*[@class='selection-button selection-button-inline selection-button-selected']"
    ).text()
    @existing_values['servicestatus'] = servicestatus

    servicename = find(
      :xpath,
      "//*[contains(text(), 'Service name')]/../../td[2]/span"
    ).text()
    servicesummary = find(
      :xpath,
      "//*[contains(text(), 'Service summary')]/../../td[2]/span"
    ).text()
    servicefeature3 = find(
      :xpath,
      "//*[contains(text(), 'Service features')]/../..//*/li[3]"
    ).text()
    servicebenefits2 = find(
      :xpath,
      "//*[contains(text(), 'Service benefits')]/../..//*/li[2]"
    ).text()

  elsif current_url.include?('admin')
    page.should have_content('Pricing')
    page.should have_content('Documents')

    servicename = find(
      :xpath,
      "//*[contains(text(), 'Service name')]/../../td[2]/span[text()]"
    ).text()
    servicesummary = find(
      :xpath,
      "//*[contains(text(), 'Service summary')]/../../td[2]/span[text()]"
    ).text()
    servicefeature3 = find(
      :xpath,
      "//*[contains(text(), 'Service features')]/../..//*/li[3]"
    ).text()
    servicebenefits2 = find(
      :xpath,
      "//*[contains(text(), 'Service benefits')]/../..//*/li[2]"
    ).text()

    serviceprice = find(
      :xpath,
      "//*[contains(text(), 'Service price')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['serviceprice'] = serviceprice

    vatincluded = find(
      :xpath,
      "//*[contains(text(), 'VAT included')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['vatincluded'] = vatincluded

    educationpricing = find(
      :xpath,
      "//*[contains(text(), 'Education pricing')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['educationpricing'] = educationpricing

    terminationcost = find(
      :xpath,
      "//*[contains(text(), 'Termination cost')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['terminationcost'] = terminationcost

    trialoption = find(
      :xpath,
      "//*[contains(text(), 'Trial option')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['trialoption'] = trialoption

    freeoption = find(
      :xpath,
      "//*[contains(text(), 'Free option')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['freeoption'] = freeoption

    minimumcontractperiod = find(
      :xpath,
      "//*[contains(text(), 'Minimum contract period')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['minimumcontractperiod'] = minimumcontractperiod

    pricingdocument = find(
      :xpath,
      "//*[contains(text(), 'Pricing document')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['pricingdocument'] = pricingdocument

    servicedefinitiondocument = find(
      :xpath,
      "//*[contains(text(), 'Service definition document')]/../../td[2]/span[text()]"
    ).text()
    @existing_values['servicedefinitiondocument'] = servicedefinitiondocument
  end
  @existing_values['servicename'] = servicename
  @existing_values['servicesummary'] = servicesummary
  @existing_values['servicefeature3'] = servicefeature3
  @existing_values['servicebenefits2'] = servicebenefits2

  current_url.should have_content(@existing_values['serviceid'])
  page.should have_content('Service attributes')
  page.should have_content('Description')
  page.should have_content('Features and benefits')
end

Given /I have logged in to Digital Marketplace as a '(.*)' user$/ do |user_type|
  steps %Q{
    Given I am on the '#{user_type}' login page
    When I login as a '#{user_type}' user
  }
end

Given /I am logged in as a '(.*)' and am on the '(.*)' service summary page$/ do |user_type,value|
  @servicesupplierID = value
  if user_type == 'Administrator'
    steps %Q{
      Given I have logged in to Digital Marketplace as a '#{user_type}' user
      When I enter '#{value}' in the 'service_id' field
      When I click the search button for 'service_id'
      Then I am presented with the summary page for that service
    }
  elsif user_type == 'Supplier'
    step "I am logged in as a 'DM Functional Test Supplier' '#{user_type}' user and am on the service listings page"
    find(
      :xpath,
      ".//a[contains(@href, '/suppliers/services/#{value}')]"
    ).click
    step "I am presented with the summary page for that service"
  end
end

Then /I am logged out of Digital Marketplace as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    page.should have_content('You have been logged out')
    page.should have_content('Email address')
  elsif user_type == 'Supplier'
    page.should have_content("#{user_type} login")
    page.should have_content('Email address')
  end
  page.should have_content("#{user_type} login")
  page.should have_content('Password')
  page.has_button?('Log in')
end

Given /I click the '(.*)' link for '(.*)'$/ do |action,service_aspect|
  if service_aspect == 'Supplier information'
    find(
      :xpath,
      "//a[contains(@href , '/suppliers/edit')]"
    ).click
  else
    find(
      :xpath,
      "//a[contains(@href , '/services/#{@existing_values['serviceid'].downcase}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}')]"
    ).click
  end
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
  elsif service_aspect == 'Documents'
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
  elsif page.has_content?('Pricing')
    page.find(
      :xpath,
      "//*[contains(@id, '#{field_to_change}')]"
    ).set(new_value)
  elsif page.has_content?('Edit supplier information') and field_to_change.include?('lients')
    page.find(
      :xpath,
      "//*[contains(@id, '#{field_to_change}')]"
    ).set(new_value)
  else
    page.find(
      :xpath,
      "//*[contains(@name, '#{field_to_change}')]"
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
  find(
    :xpath,
    "//*[contains(@name, '#{field_to_change}') and contains(../text(), '#{new_value}')]"
  ).click
  @changed_fields = @changed_fields || Hash.new
  @changed_fields[field_to_change] = new_value
end

And /I remove service benefit number 2$/ do
  @changed_fields['serviceBenefits-2'] = find(
    :xpath,
    "//*[contains(@id, 'serviceBenefits-2')]"
  ).value()
  find(:xpath, ".//*[@id='serviceBenefits']//*[@class='button-secondary list-entry-remove']//span[contains(text(), 'number 2')]/..").click
end

And /I remove client number 2$/ do
  @changed_fields['clients-2'] = find(
    :xpath,
    "//*[contains(@id, 'clients-2')]"
  ).value()
  find(:xpath, ".//*[@id='list-entry-clients']//*[@class='button-secondary list-entry-remove']//span[contains(text(), 'number 2')]/..").click
end

And /I add '(.*)' as a '(.*)'$/ do |value,item_to_add|
  record_number_to_add = (10 - ((find(
    :xpath,
    ".//*[@id='#{item_to_add}']//button[contains(text(), 'Add another')]"
  ).text()).split(' (').last.split(' remaining').first).to_i)

  find(
    :xpath,
    ".//*[@id='#{item_to_add}']//button[contains(text(), 'Add another')]"
  ).click

  find(
    :xpath,
    "//*[contains(@id, '#{record_number_to_add}') and contains(@name, '#{item_to_add}')]"
  ).set(value)

  @changed_fields[item_to_add] = value
end

Then /I am presented with the dashboard page with the changes that were made to the '(.*)'$/ do |service_aspect|
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Supplier summary')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['description'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Clients')]/../..//li[2]"
  ).text().should have_content(@changed_fields['clients-3'])
  page.should have_no_content(@changed_fields['clients-2'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Clients')]/../..//li[3]"
  ).text().should have_content(@changed_fields['clients'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Contact name')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_contactName'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Website')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_website'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Email address')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_email'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Phone number')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_phoneNumber'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Address')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_address1'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Address')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_city'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Address')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_country'])
  find(
    :xpath,
    "//caption[contains(text(), '#{service_aspect}')]/..//*[contains(text(), 'Address')]/../../td[2]/span"
  ).text().should have_content(@changed_fields['contact_postcode'])
end

Then /I am presented with the summary page with the changes that were made to the '(.*)'$/ do |service_aspect|
  page.should have_selector(:xpath, "//h2[@class='summary-item-heading'][contains(text(), '#{service_aspect}')]")
  if service_aspect == 'Description'
    page.should have_content(@changed_fields['serviceName'])
    page.should have_content(@changed_fields['serviceSummary'])
  elsif service_aspect == 'Features and benefits'
    page.should have_content(@changed_fields['serviceFeatures-3'])
    page.should have_no_content(@changed_fields['serviceBenefits-2'])
    page.should have_content(@changed_fields['serviceFeatures'])
  elsif service_aspect == 'Pricing'
    find(
      :xpath,
      "//*[contains(text(), 'Service price')]/../../td[2]/span[text()]"
    ).text().should have_content("£#{@changed_fields['priceMin']} to £#{@changed_fields['priceMax']} per #{@changed_fields['priceUnit']} per #{@changed_fields['priceInterval']}")
    find(
      :xpath,
      "//*[contains(text(), 'VAT included')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['vatIncluded'])
    find(
      :xpath,
      "//*[contains(text(), 'Education pricing')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['educationPricing'])
    find(
      :xpath,
      "//*[contains(text(), 'Termination cost')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['terminationCost'])
    find(
      :xpath,
      "//*[contains(text(), 'Trial option')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['trialOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Free option')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['freeOption'])
    find(
      :xpath,
      "//*[contains(text(), 'Minimum contract period')]/../../td[2]/span[text()]"
    ).text().should have_content(@changed_fields['minimumContractPeriod'])

  elsif service_aspect == 'Documents'
    page.should have_no_content(@existing_values['originaldoc'])

    if @existing_values['docofinterest'] == 'servicedefinitiondocument'
      @newpdocument = find(
        :xpath,
        "//*[contains(text(), 'Service definition document')]/../../td[2]/span[text()]"
      ).text()
    elsif @existing_values['docofinterest'] == 'pricingdocument'
      @newpdocument = find(
        :xpath,
        "//*[contains(text(), 'Pricing document')]/../../td[2]/span[text()]"
      ).text()
    end

    if @newpdocument == @existing_values['originaldoc']
      raise "The pricing document has not been changed as expected"
    end
  end
  current_url.should end_with(@existing_values['summarypageurl'])
end

When /I change '(.*)' file to '(.*)'$/ do |document_to_change,new_document|
  @existing_values = @existing_values || Hash.new
  @existing_values['originaldoc'] = @existing_values["#{document_to_change.split('URL').first.downcase}"]
  @existing_values['docofinterest'] = "#{document_to_change.split('URL').first.downcase}"
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
  step "I click the '#{action}' link for '#{service_aspect}'"
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
  elsif service_aspect == 'Documents'
    page.should have_content(service_aspect)
    page.should have_content('Service definition document')
    page.should have_content('Please upload your terms and conditions document')
    page.should have_content('Skills Framework for the Information Age (SFIA) rate card')
    page.should have_content('Pricing document')
  elsif service_aspect == 'Supplier information'
    page.should have_content('Edit '"#{service_aspect.downcase}")
    page.should have_content('Supplier summary')
    page.should have_content('Clients')
    page.should have_content('Contact name')
    page.should have_content('Website')
    page.should have_content('Email address')
    page.should have_content('Phone number')
    page.should have_content('Business address')
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

Then /I am presented with the service details page for that service$/ do
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/services/#{@servicesupplierID}")
  page.should have_content(@existing_values['servicename'])
  page.should have_content(@existing_values['servicesummary'])
  page.should have_content(@existing_values['servicefeature3'])
  page.should have_no_content('2nd service benefit')
  page.should have_content(@existing_values['serviceprice'])
end

Then /I am presented with the '(.*)' supplier dashboard page$/ do |supplier_name|
  @existing_values = @existing_values || Hash.new
  @existing_values['summarypageurl'] = current_url
  page.should have_content(supplier_name)
  page.should have_content('Log out')
  page.should have_content(eval "dm_supplier_uname")
  current_url.should end_with("#{dm_frontend_domain}/suppliers")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")

  if supplier_name == 'Digital Marketplace Team'
    page.should have_content('You don\'t have any services on the Digital Marketplace')
  end
end

Given /I am logged in as a '(.*)' '(.*)' user and am on the dashboard page$/ do |supplier_name,user_type|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    Then I am presented with the '#{supplier_name}' supplier dashboard page
  }
end

Given /I am logged in as a '(.*)' and navigated to the '(.*)' page by searching on supplier ID '(.*)'$/ do |user_type,page_name,value|
  if page_name == 'Services'
    steps %Q{
      Given I have logged in to Digital Marketplace as a '#{user_type}' user
      When I enter '#{value}' in the 'supplier_id_for_services' field
      And I click the search button for 'supplier_id_for_services'
      Then I am presented with the '#{page_name}' page for the supplier 'DM Functional Test Supplier'
    }
  elsif page_name == 'Users'
    steps %Q{
      Given I have logged in to Digital Marketplace as a '#{user_type}' user
      When I enter '#{value}' in the 'supplier_id_for_users' field
      And I click the search button for 'supplier_id_for_users'
      Then I am presented with the '#{page_name}' page for the supplier 'DM Functional Test Supplier'
    }
  end
end

Given /I am logged in as a '(.*)' '(.*)' user and am on the service listings page$/ do |supplier_name,user_type|
  steps %Q{
    Given I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
    When I click 'View'
    Then I am presented with the supplier '#{supplier_name}' 'Current services' page
  }
end

Then /I can see my supplier details on the dashboard$/ do
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Current services')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Supplier information')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Account information')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Contributors')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'G-Cloud 6')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '8 services')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Supplier summary')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'This is a test supplier, which will be used solely for the purpose of running functional test.')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Clients')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//li[contains(text(), 'First client')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//li[contains(text(), 'Second client')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//li[contains(text(), '3rd client')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//li[contains(text(), 'Client 4')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Contact name')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'Testing Supplier Name')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Website')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'www.dmfunctionaltestsupplier.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Email address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'Testing.supplier.NaMe@DMtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Phone number')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '+44 (0) 123456789')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'Address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//*/span[@itemprop][text()][contains(text(), '125 Kingsway')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//*/span[@itemprop][text()][contains(text(), 'London')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//*/span[@itemprop][text()][contains(text(), 'United Kingdom')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']//*/span[@itemprop][text()][contains(text(), 'WC2B 6NH')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 1')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username@dmtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username2@dmtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 3')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username3@dmtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-body']/caption[contains(text(), 'Account information')]/following-sibling::*[2]//*[@class='summary-item-field-first']/span[contains(text(), 'Email address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username@dmtestemail.com')]")
end

Then /I am presented with the supplier '(.*)' '(.*)' page$/ do |supplier_name, page_name|
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2]//*[contains(text(), 'Your account')]")
  page.should have_selector(:xpath, "//h1[contains(text(), '#{page_name}')]")

  if page_name == 'Current services'
    current_url.should end_with("#{dm_frontend_domain}/suppliers/services")
  elsif page_name == 'Add or remove contributors'
    current_url.should end_with("#{dm_frontend_domain}/suppliers/users")
  end

end

When /I remove the supplier user '(.*)'$/ do |user_name|
  @data_store = @data_store || Hash.new
  supplier_user_email = page.find(:xpath, "//tr/td/span[contains(text(), 'DM Functional Test Supplier User 2')]/../../td[2][text()]").text()
  @data_store['supplieruseremail'] = supplier_user_email
  page.first(:xpath, ".//td[@class='summary-item-field-first']//*[contains(text(), '#{user_name}')]/../../td[@class='summary-item-field-with-action']//button").click
end

Then /I see a confirmation message after having removed supplier user '(.*)'$/ do |user_name|
  step "I am presented with the message '#{user_name} (#{@data_store['supplieruseremail']}) has been removed as a contributor. They can be invited again at any time.'"
end

And /I should not see the supplier user '(.*)' on the supplier dashboard page$/ do |user_name|
  steps %Q{
    Given I click the 'Your account' link
    Then I am presented with the 'DM Functional Test Supplier' supplier dashboard page
    And I should not see the supplier user '#{user_name}' in the 'Contributors' table
    }
end

And /I should not see the supplier user '(.*)' in the '(.*)' table$/ do |user_name,summary_table_name|
    page.should_not have_selector(:xpath, "//caption[contains(text(), '#{summary_table_name}')]/..//td/span[contains(text(), '#{user_name}')]")
end

Then /I am presented with the '(.*)' page for the supplier '(.*)'$/ do |page_name,supplier_name|
  page.should have_content("#{page_name}")
  page.should have_content('Log out')
  current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/#{page_name.downcase}?supplier_id=#{@servicesupplierID}")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2][contains(text(), 'DM Functional Test Supplier')]")
end

Then /I am presented with the '(.*)' page for all suppliers starting with '(.*)'$/ do |page_name,supplier_search_prefix|
  page.should have_content("#{page_name}")
  page.should have_content('Log out')
  current_url.should end_with("#{dm_frontend_domain}/admin/#{page_name.downcase}?supplier_name_prefix=#{supplier_search_prefix.gsub(' ','+')}")
  page.should have_selector(:xpath, "//table/tbody/tr[1]/td[1]//*[contains(text(),'#{supplier_search_prefix}')]")
  page.find(:xpath,
    "//table/tbody/tr[1]//*[contains(text(),'DM Functional Test Supplier')]/../..//a[contains(@href,'/admin/suppliers/users?supplier_id=11111')][text()]"
  ).text().should have_content('Users')
  page.find(:xpath,
    "//table/tbody/tr[1]//*[contains(text(),'DM Functional Test Supplier')]/../..//a[contains(@href,'/admin/suppliers/services?supplier_id=11111')][text()]"
  ).text().should have_content('Services')
  page.find(:xpath,
    "//table/tbody/tr[2]//*[contains(text(),'DM Functional Test Supplier 2')]/../..//a[contains(@href,'/admin/suppliers/users?supplier_id=11112')][text()]"
  ).text().should have_content('Users')
  page.find(:xpath,
    "//table/tbody/tr[2]//*[contains(text(),'DM Functional Test Supplier 2')]/../..//a[contains(@href,'/admin/suppliers/services?supplier_id=11112')][text()]"
  ).text().should have_content('Services')
  page.should have_no_selector(:xpath, "//table/tbody/tr[3]")
end

And /I can see all listings ordered by lot name followed by listing name$/ do
  service_listed_and_in_correct_order("1123456789012346","1")
  service_listed_and_in_correct_order("1123456789012350","2")
  service_listed_and_in_correct_order("1123456789012347","3")
  service_listed_and_in_correct_order("1123456789012351","4")
  service_listed_and_in_correct_order("1123456789012348","5")
  service_listed_and_in_correct_order("1123456789012352","6")
  service_listed_and_in_correct_order("1123456789012349","7")
  service_listed_and_in_correct_order("1123456789012353","8")
  page.should have_no_selector(:xpath, "*//table/tbody/tr[9][td/text()]")
end

Then /I can see active users associated with '(.*)' on the dashboard$/ do |supplier_name|
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Contributors')]")
  ['Name', 'Email address'].each do |header|
    page.should have_selector(:xpath, "//caption[contains(text(), 'Contributors')]/..//th/span[contains(text(), '#{header}')]")
  end
  [
    'DM Functional Test Supplier User 1', 'testing.supplier.username@dmtestemail.com',
    'DM Functional Test Supplier User 2', 'testing.supplier.username2@dmtestemail.com',
    'DM Functional Test Supplier User 3', 'testing.supplier.username3@dmtestemail.com'
    ].each do |cell|
    page.should have_selector(:xpath, "//caption[contains(text(), 'Contributors')]/..//td/span[contains(text(), '#{cell}')]")
  end
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
  xpath_to_check = find(:xpath, "*//table/tbody/tr[#{order_number}][td/text()]").text()

  if response.code == 404
    puts "Service #{service_id} does not exist"
  else
    xpath_to_check.should have_content("#{service_name}")
    xpath_to_check.should have_content("#{service_lot}")
  end
end

When /I select '(.*)' second listing on the page$/ do |value|
  @data_store = @data_store || Hash.new

  servicename = find(
    :xpath,
    "//*/table/tbody/tr[2]/td[1]/span/a"
  ).text()
  @data_store['servicename'] = servicename

  if value == 'the'
    page.click_link_or_button(@data_store['servicename'])
  elsif value == 'view service for the'
    find(
      :xpath,
      "//*/table/tbody/tr[2]/td[4]/span/a[contains(text(),'View service')]"
    ).click
  end
  serviceid = URI.parse(current_url).to_s.split('services/').last
  @data_store['serviceid'] = serviceid
end

Then /I am presented with the service page for that specific listing$/ do
  page.should have_content(@data_store['servicename'])
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/services/#{@data_store['serviceid']}")
end

When /I select '(.*)' as the service status$/ do |service_status|
  if current_url.include?('suppliers')
    find(
      :xpath,
      "//*[contains(@name, 'status') and contains(@value, '#{service_status}')]"
    ).click
  elsif current_url.include?('admin')
    find(
      :xpath,
      "//*[contains(@name, 'status') and contains(@value, '#{service_status.downcase}')]"
    ).click
  end
end

Then /The service status is set as '(.*)'$/ do |service_status|
  if current_url.include?('suppliers')
    if service_status == 'Public'
      find(:xpath,
        "//a[contains(@href, '/services/#{@servicesupplierID}')]/../../../td[4]/span/a[text()]"
      ).text().should have_content('View service')
    else
      find(
        :xpath,
        "//a[contains(text(), '#{@existing_values['servicename']}')]/../../..//td/*/span"
      ).text().should have_content(service_status)
    end
  elsif current_url.include?('admin')
    find(
      :xpath,
      "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
    ).text().should have_content(service_status)
  end
end

And /I am presented with the message '(.*)'$/ do |message_text|
  page.should have_content(message_text)
end

Then /The status of the service is presented as '(.*)' on the supplier users service listings page$/ do |service_status|
  step "I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page"

  if service_status == 'Public'
    find(:xpath,
      "//a[contains(@href, '/suppliers/services/#{@servicesupplierID}')]/../../../td[4]/span/a[text()]"
    ).text().should have_content('View service')
  else
    find(:xpath,
      "//a[contains(@href, '/suppliers/services/#{@servicesupplierID}')]/../../../td[contains(@class, 'summary-item-field')]/span/span[contains(@class, 'service-status-')][text()]"
    ).text().should have_content("#{service_status}")
  end
end

Then /The status of the service is presented as '(.*)' on the admin users service summary page$/ do |service_status|
  step "Given I am logged in as a 'Administrator' and am on the '#{@servicesupplierID}' service summary page"
  find(
    :xpath,
    "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
  ).text().should have_content("#{service_status}")
end

And /The service '(.*)' be searched$/ do |ability|
  sleep 1
  page.visit("#{dm_frontend_domain}/g-cloud/search?q=#{@servicesupplierID}")
  page.should have_content('Search results')
  if "#{ability.downcase}" == 'can'
    @existing_values = @existing_values || Hash.new
    page.find(
      :xpath,
      "//*[contains(@class, 'search-summary-count') and contains(text(), '1')]"
    )
    page.should have_selector(:xpath, "//a[contains(@href, '/services/#{@serviceID}')]")
    service_name = find(:xpath, "//a[contains(@href, '/services/#{@serviceID}')]").text()
    @existing_values['service_name'] = service_name
  elsif "#{ability.downcase}" == 'can not'
    page.find(
      :xpath,
      "//*[contains(@class, 'search-summary-count') and contains(text(), '0')]"
    )
    page.should have_no_selector(:xpath, "//a[contains(@href, '/services/#{@serviceID}')]")
  end
end

And /The service details page '(.*)' be viewed$/ do |ability|
  page.visit("#{dm_frontend_domain}/g-cloud/services/#{@servicesupplierID}")
  if "#{ability.downcase}" == 'can'
    page.should have_content(@existing_values['service_name'])
  elsif "#{ability.downcase}" == 'can not'
    page.should have_content(@existing_values['service_name'])
    page.should have_content('Page could not be found')
  end
end

Given /I am on the '(.*)' landing page$/ do |page_name|
  if page_name == 'Digital Marketplace'
    page.visit("#{dm_frontend_domain}")
    page.should have_content("#{page_name}")
    page.should have_link('Find cloud technology and support')
    page.should have_link('Buy physical datacentre space for legacy systems')
    page.should have_link('Find specialists to work on digital projects')
  elsif page_name == 'Cloud technology and support'
    page.visit("#{dm_frontend_domain}/g-cloud")
    step "Then I am taken to the '#{page_name}' landing page"
  end
end

When /I click the '(.*)' link$/ do |link_name|
  step "I click the '#{link_name}' button"
end

And /I click the search button for '(.*)'$/ do |action_field|
  find(:xpath, "//label[@for='#{action_field}']/../input[@value='Search']").click
end

Then /I am taken to the '(.*)' landing page$/ do |page_name|
  page.should have_content("#{page_name}")
  page.should have_button('Show services')
  page.should have_link('Software as a Service')
  page.should have_link('Platform as a Service')
  page.should have_link('Infrastructure as a Service')
  page.should have_link('Specialist Cloud Services')
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2][contains(text(), '#{page_name}')]")
end

Then /I am taken to the search results page with results for '(.*)' lot displayed$/ do |lot_name|
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2]//*[contains(text(), 'Cloud technology and support')]")
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class= 'page-heading']//*[contains(text(), 'Search results')]")
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class='lot-filters']//*[contains(text(), 'Choose a category')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search') and contains(text(), 'All categories')]")
  find(:xpath, "//*[@class='search-summary-count']").text().should_not match(/^0$/)
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class= 'search-summary']//*[contains(text(), '#{lot_name}')]")
  page.should have_selector(:xpath, "//*/label[contains(@class, 'option-select-label') and contains(text(), 'Keywords')]")

  step "Then Selected lot is '#{lot_name}' with links to the search for ''"
end

def filter_to_check(filter_name,filter_value,filter_exist)
  if "#{filter_value}" == '' and "#{filter_exist}" == 'yes'
    page.should have_selector(:xpath, "//div[contains(@class, 'option-select-label') and contains(text(), '#{filter_name}')]")
  elsif "#{filter_value}" == '' and "#{filter_exist}" == 'no'
    page.should have_no_selector(:xpath, "//div[contains(@class, 'option-select-label') and contains(text(), '#{filter_name}')]")
  else
    page.should have_selector(:xpath, "//div[contains(@class, 'option-select-label') and contains(text(), '#{filter_name}')]/../..//label[contains(text()[2], '#{filter_value}')]/input[@type='checkbox']")
  end
end

And /All filters for '(.*)' are available$/ do |lot_name|
  filter_to_check("Minimum contract period","","yes")
  filter_to_check("Service management","","yes")
  filter_to_check("Minimum contract period","Hour","")
  filter_to_check("Minimum contract period","Day","")
  filter_to_check("Minimum contract period","Month","")
  filter_to_check("Minimum contract period","Year","")
  filter_to_check("Minimum contract period","Other","")
  filter_to_check("Service management","Support accessible to any third-party suppliers","")

  if "#{lot_name.downcase}" == 'software as a service' or "#{lot_name.downcase}" == 'infrastructure as a service' or "#{lot_name.downcase}" == 'specialist cloud services'
    filter_to_check("Categories","","yes")
  elsif "#{lot_name.downcase}" == 'platform as a service'
    filter_to_check("Categories","","no")
  end

  if "#{lot_name.downcase}" == 'specialist cloud services'
    filter_to_check("Pricing","","no")
    filter_to_check("Datacentre tier","","no")
    filter_to_check("Networks the service is directly connected to","","no")
    filter_to_check("Interoperability","","no")
    filter_to_check("Categories","Implementation","")
    filter_to_check("Categories","Ongoing support","")
    filter_to_check("Categories","Planning","")
    filter_to_check("Categories","Testing","")
    filter_to_check("Categories","Training","")
  elsif "#{lot_name.downcase}" == 'software as a service' or "#{lot_name.downcase}" == 'platform as a service' or "#{lot_name.downcase}" == 'infrastructure as a service'
    filter_to_check("Pricing","","yes")
    filter_to_check("Datacentre tier","","yes")
    filter_to_check("Networks the service is directly connected to","","yes")
    filter_to_check("Interoperability","","yes")
    filter_to_check("Pricing","Free option","")
    filter_to_check("Pricing","Trial option","")
    filter_to_check("Service management","Data extraction/removal plan in place","")
    filter_to_check("Service management","Datacentres adhere to EU Code of Conduct for Operations","")
    filter_to_check("Service management","Backup, disaster recovery and resilience plan in place","")
    filter_to_check("Service management","Self-service provisioning supported","")
    filter_to_check("Datacentre tier","TIA-942 Tier 1","")
    filter_to_check("Datacentre tier","TIA-942 Tier 2","")
    filter_to_check("Datacentre tier","TIA-942 Tier 3","")
    filter_to_check("Datacentre tier","TIA-942 Tier 4","")
    filter_to_check("Datacentre tier","Uptime Institute Tier 1","")
    filter_to_check("Datacentre tier","Uptime Institute Tier 2","")
    filter_to_check("Datacentre tier","Uptime Institute Tier 3","")
    filter_to_check("Datacentre tier","Uptime Institute Tier 4","")
    filter_to_check("Datacentre tier","None of the above","")
    filter_to_check("Networks the service is directly connected to","Internet","")
    filter_to_check("Networks the service is directly connected to","Public Services Network (PSN)","")
    filter_to_check("Networks the service is directly connected to","Government Secure intranet (GSi)","")
    filter_to_check("Networks the service is directly connected to","Police National Network (PNN)","")
    filter_to_check("Networks the service is directly connected to","New NHS Network (N3)","")
    filter_to_check("Networks the service is directly connected to","Joint Academic Network (JANET)","")
    filter_to_check("Networks the service is directly connected to","Other","")
    filter_to_check("Interoperability","API access available and supported","")
    filter_to_check("Interoperability","Open standards supported and documented","")
    filter_to_check("Interoperability","Open-source software used and supported","")
  end

  if "#{lot_name.downcase}" == 'software as a service'
    filter_to_check("Categories","Accounting and finance","")
    filter_to_check("Categories","Business intelligence and analytics","")
    filter_to_check("Categories","Collaboration","")
    filter_to_check("Categories","Creative and design","")
    filter_to_check("Categories","Customer relationship management (CRM)","")
    filter_to_check("Categories","Data management","")
    filter_to_check("Categories","Electronic document and records management (EDRM)","")
    filter_to_check("Categories","Energy and environment","")
    filter_to_check("Categories","Healthcare","")
    filter_to_check("Categories","Human resources and employee management","")
    filter_to_check("Categories","IT management","")
    filter_to_check("Categories","Legal","")
    filter_to_check("Categories","Libraries","")
    filter_to_check("Categories","Marketing","")
    filter_to_check("Categories","Operations management","")
    filter_to_check("Categories","Project management and planning","")
    filter_to_check("Categories","Sales","")
    filter_to_check("Categories","Schools and education","")
    filter_to_check("Categories","Security","")
    filter_to_check("Categories","Software development tools","")
    filter_to_check("Categories","Telecoms","")
    filter_to_check("Categories","Transport and logistics","")
  elsif "#{lot_name.downcase}" == 'infrastructure as a service'
    filter_to_check("Categories","Compute","")
    filter_to_check("Categories","Storage","")
  end
end

Then /I am on a page with that service\.(.*) in search summary text$/ do |attr_name|
  step "I am on a page with '\"#{@service[attr_name]}\"' in search summary text"
end

Then /I am on a page with '(.*)' in search summary text$/ do |value|
  query_string = CGI.escape value
  current_url.should include("q=#{query_string}")

  find(:xpath, "//*[@class='search-summary']/em[1]").text().should == normalize_whitespace(value)
end

Then /Selected lot is that service.lot with links to the search for that service.(.*)$/ do |attr|
  lot = full_lot(@service['lot'])
  query = @service[attr]
  step "Selected lot is '#{lot}' with links to the search for '\"#{query}\"'"
end

Then /Selected lot is '([^']*)'(?: with links to the search for '(.*)')?$/ do |selected_lot, query|
  query = CGI.escape(query || '')
  lots = find(:xpath, ".//div[@class='lot-filters']/ul")
  lot_links = lots.all(:xpath, './li/a').map { |lot| lot[:href] }
  lot_names = lots.all(:xpath, './li').map { |lot| lot.text }

  LOTS.each do |lot, full_lot|
    lot_link = "/g-cloud/search?q=#{query}"
    lot_link += "&lot=#{lot.to_s.downcase}" if lot != :all
    if full_lot == selected_lot
      lot_names.should include(full_lot)
      lot_links.should_not include(lot_link)
      if query.empty?
        current_url.should end_with("/g-cloud/search?lot=#{lot.to_s.downcase}")
        find(:xpath, "//p[@class='search-summary']/em[1]").text.should == full_lot
      else
        current_url.should end_with(lot_link)
        find(:xpath, "//p[@class='search-summary']/em[2]").text.should == full_lot
      end
      page.first(:xpath, ".//ol[@role='breadcrumbs']/li[3]").text.should == full_lot if lot != :all
    else
      lot_names.should include(full_lot)
      lot_links.should include(lot_link)
    end
  end
end

Then /There (?:is|are) (\d+) search results?$/ do |count|
  find(:xpath, "//*[@class='search-summary-count']").text.should == count
end

Then /I am taken to the search results page with a result for the service '(.*)'$/ do |value|
  steps %Q{
    Then I am on a page with '#{value}' in search summary text
    Then Selected lot is 'All categories' with links to the search for '#{value}'
    Then There is 1 search result
  }

  find(:xpath, "//*[@class='search-summary']/em[1]").text().should match("#{value}")
  find(:xpath, ".//*[@id='content']//*[@class='search-result-title']//a[contains(text(),'#{value}')]")
  page.should have_no_selector(:xpath, ".//div[@class='lot-filters']//li[1]/a")
  page.should have_selector(:xpath, ".//p[@class='search-result-supplier'][contains(text(), 'DM Functional Test Supplier')]")
  page.should have_selector(:xpath, ".//*[@class='search-result-metadata-item'][contains(text(), 'Infrastructure as a Service')]")
  page.should have_selector(:xpath, ".//*[@class='search-result-metadata-item'][contains(text(), 'G-Cloud 6')]")
end

Then /I am on a page with that service in search results$/ do
  search_results = all(:xpath, ".//div[@class='search-result']")
  service_result = search_results.find { |r| r.first(:xpath, './h2/a')[:href].include? @service['id']}

  service_result.first(:xpath, "./h2[@class='search-result-title']/a").text.should == normalize_whitespace(@service['serviceName'])
  service_result.first(:xpath, "./p[@class='search-result-supplier']").text.should == normalize_whitespace(@service['supplierName'])
  service_result.first(:xpath, ".//li[@class='search-result-metadata-item'][1]").text.should == full_lot(@service['lot'])
  service_result.first(:xpath, ".//li[@class='search-result-metadata-item'][2]").text.should == @service['frameworkName']
end

Given /I am on the search results page for the searched value of '(.*)'$/ do |search_value|
  steps %Q{
    Given I am on the 'Cloud technology and support' landing page
    When I enter '#{search_value}' in the 'q' field
    And I click 'Show services'
    Then I am taken to the search results page with a result for the service '#{search_value}'
  }
end

Then /Words in the search result excerpt that match the search criteria are highlighted$/ do
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'N3')]").text().should have_content('N3')
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'Secure')]").text().should have_content('Secure')
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'secure')]").text().should have_content('secure')
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'Remote')]").text().should have_content('Remote')
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'Access')]").text().should have_content('Access')
  page.first(:xpath, ".//em[@class='search-result-highlighted-text'][contains(text(),'access')]").text().should have_content('access')
end

Given /I am on the search results page with results for that service.lot displayed$/ do
  step "Given I am on the search results page with results for '#{full_lot(@service['lot'])}' lot displayed"
end

Given /I am on the search results page with results for '(.*)' lot displayed$/ do |lot_name|
  steps %Q{
    Given I am on the 'Cloud technology and support' landing page
    When I click the '#{lot_name}' link
    Then I am taken to the search results page with results for '#{lot_name}' lot displayed
  }
  @data_store = @data_store || Hash.new
  searchsummarycount = find(:xpath, "//*[@class='search-summary-count']").text()
  @data_store['searchsummarycount'] = searchsummarycount
end

Then /The search results is filtered returning just one result for the service '(.*)'$/ do |value|
  query_string = CGI.escape value
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/search?q=#{query_string}&lot=iaas")
  find(:xpath, "//*[@class='search-summary-count']").text().should match(/^1$/)
  find(:xpath, "//*[@class='search-summary']/em[1]").text().should match("#{query_string}")
  find(:xpath, "//*[@class='search-summary']/em[2]").text().should match('Infrastructure as a Service')
  find(
    :xpath,
    ".//*[@id='content']//*[@class='search-result-title']//a[contains(text(),'#{query_string} DM Functional Test N3 Secure Remote Access')]"
  )
  page.should have_no_selector(:xpath, ".//div[@class='lot-filters']//li[4]/a")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{query_string}')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{query_string}') and contains(@href, '&lot=saas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{query_string}') and contains(@href, '&lot=paas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{query_string}') and contains(@href, '&lot=scs')]")
end

When /I select '(.*)' as the filter value under the '(.*)' filter$/ do |filter_value,filter_name|
  page.find(:xpath, "//div[contains(@class, 'option-select-label') and contains(text(), '#{filter_name}')]/../..//label[contains(text()[2], '#{filter_value}')]/input[@type='checkbox']").trigger('click')
end

Then /The search results is narrowed down by the selected filter$/ do
  current_count = find(:xpath, "//*[@class='search-summary-count']").text().to_i
  find(:xpath, "//*[@class='search-summary-count']").text().to_i.should be < @data_store['searchsummarycount'].to_i
  @data_store['searchsummarycount'] = current_count
end

When /I click the first record in the list of results returned$/ do
  @data_store = @data_store || Hash.new
  servicename = first(:xpath, ".//*[@class='search-result-title']/a").text()
  servicesuppliername = first(:xpath, ".//p[@class='search-result-supplier']").text()
  url = first(:xpath, ".//h2[@class='search-result-title']/a")[:href]
  @data_store['servicename'] = servicename
  @data_store['servicesuppliername'] = servicesuppliername
  @data_store['url'] = url
  page.first(:xpath, ".//*[@id='content']/*//h2/a").click
end

Given /I am on the search results page with results for '(.*)'$/ do |search_value|
  visit("#{dm_frontend_domain}/g-cloud/search?q=#{search_value.gsub(' ','+')}")
  page.find(:xpath, "//*[@class='search-summary']/em[1]").text().should match("#{search_value}")
  page.find(:xpath, "//*[@class='search-summary']/em[2]").text().should match('All categories')
end

Then /I am taken to the service listing page of that specific record selected$/ do
  page.should have_content(@data_store['servicename'])
  page.should have_content(@data_store['servicesuppliername'])
  current_url.should end_with("#{dm_frontend_domain}#{@data_store['url']}")
end

When /There is '(.*)' than 100 results returned$/ do |more_or_less|
  @data_store = @data_store || Hash.new
  current_count = find(:xpath, "//*[@class='search-summary-count']").text().to_i
  number_of_pages = (current_count.to_f/100).ceil
  @data_store['currentcount'] = current_count
  @data_store['numberofpages'] = number_of_pages
  @data_store['moreorless'] = more_or_less
end

Then /Pagination is '(.*)'$/ do |availability|
  if current_url.include?('search?')
    if @data_store['currentcount'] > 100 && @data_store['moreorless'] == 'more'
      pagination_available = 'available'
    elsif @data_store['currentcount'] <= 100 && @data_store['moreorless'] == 'less'
      pagination_available = 'not available'
    end
  elsif current_url.include?('suppliers?')
    pagination_available = "#{availability}"
  end

  if pagination_available == 'available'
    page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  elsif pagination_available == 'not available'
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  end
end

Then /I am taken to page '(.*)' of results$/ do |page_number|
  if current_url.include?('search?')
    current_url.should end_with("#{dm_frontend_domain}/g-cloud/search?page=#{page_number}&lot=iaas")
    if page_number >= '2'
      page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
      page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '3 of #{@data_store['numberofpages']}')]")
      page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
      page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '1 of #{@data_store['numberofpages']}')]")
    elsif page_number < '2'
      page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
      page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    end
  elsif current_url.include?('suppliers?')
    current_url.should end_with("#{dm_frontend_domain}/g-cloud/suppliers?framework=gcloud&prefix=#{@data_store['supplier_alphabet']}&page=#{page_number}")
    if page_number >= '2'
      page.should have_no_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
      page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    elsif page_number < '2'
      page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
      page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    end
  end
end

Then /The supplier user '(.*)' is '(.*)'$/ do |user_name,user_lockoractive_state|
  if user_lockoractive_state == 'not active'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'activate')]/../*//button[text()]").text().should match('Activate')
  elsif user_lockoractive_state == 'active'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'activate')]/../*//button[text()]").text().should match('Deactivate')
  elsif user_lockoractive_state == 'locked'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'unlock')]/../*//button[text()]").text().should match('Unlock')
  elsif user_lockoractive_state == 'not locked'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td[5]/span[text()]").text().should match('No')
  end
end

Given /The supplier user '(.*)' has 5 failed login attempts$/ do |user_name|
  step "The user '#{user_name}' is locked"
end

Then /The supplier user '(.*)' is '(.*)' on the admin Users page$/ do |user_name, user_lockoractive_state|
  steps %Q{
    Given I am logged in as a 'Administrator' and navigated to the 'Users' page by searching on supplier ID '11111'
    Then The supplier user '#{user_name}' is '#{user_lockoractive_state}'
  }
end

And /The supplier user '(.*)' '(.*)' listed as a contributor on the dashboard of another user of the same supplier$/ do |user_name,value|
 step "I am logged in as a 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page"

  if value == 'is not'
    page.should have_no_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
    page.should have_no_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username2@dmtestemail.com')]")
  elsif value == 'is'
    page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
    page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username2@dmtestemail.com')]")
  end
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 1')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username@dmtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 3')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), 'testing.supplier.username3@dmtestemail.com')]")
end

Given /I am on the G-Cloud supplier A-Z page$/ do
  page.visit("#{dm_frontend_domain}/g-cloud/suppliers")
  page.should have_content('Suppliers starting with A')
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class='selected']//strong[contains(text(), 'A')]")
  page.should have_no_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=A')]")
  ('B'..'Z').each do |letter|
    page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=#{letter}')]")
  end
  page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=other')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2]//*[contains(text(), 'Cloud technology and support')]")
  page.should have_link('Next')
end

Then /I am on the list of '(.*)' page$/ do |value|
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/suppliers?prefix=D")
  page.should have_content('Suppliers starting with D')
  ('A'..'C').each do |letter|
    page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=#{letter}')]")
  end
  ('E'..'Z').each do |letter|
    page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=#{letter}')]")
  end
  page.should have_no_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=D')]")
  page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=other')]")
  page.should have_selector(:xpath, ".//*[@id='global-atoz-navigation']//*/a[contains(@href, '/g-cloud/suppliers?prefix=other')]")
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class='selected']//strong[contains(text(), 'D')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2]//*[contains(text(), 'Cloud technology and support')]")
end

And /The supplier '(.*)' is '(.*)' on the page$/ do |value,availability|
  if availability == 'listed'
    page.should have_content("#{value}")
    page.should have_selector(:xpath, "//*[@class='search-result-title']/*[contains(text(),'#{value}')]/../following-sibling::*[contains(text(),'Second test supplier solely for use in functional tests.')]")
  elsif availability == 'not listed'
    page.should have_no_content("#{value}")
    page.should have_no_selector(:xpath, "//*[@class='search-result-title']/*[contains(text(),'#{value}')]/../following-sibling::*[contains(text(),'Second test supplier solely for use in functional tests.')]")
  end
end

Given /I navigate to the list of '(.*)' page$/ do |value|
  page.visit("#{dm_frontend_domain}/g-cloud/suppliers?prefix=#{value.split(' ').last}")
  @data_store = @data_store || Hash.new
  @data_store['supplier_alphabet'] = "#{value.split(' ').last}"
end

And /I am taken to the '(.*)' supplier information page$/ do |value|
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/supplier/11112")
  page.should have_selector(:xpath, "//header/p[contains(text(),'Digital Marketplace supplier')]")
  page.should have_selector(:xpath, "//header/h1[contains(text(),'#{value}')]")
  page.should have_selector(:xpath, "//*[@class='supplier-description'][contains(text(),'Second test supplier solely for use in functional tests.')]")
  page.should have_selector(:xpath, "//*[@class='contact-details-organisation']/*[@itemprop='name'][contains(text(),'#{value}')]")
  page.should have_selector(:xpath, "//*[@class='contact-details-block'][1]//*[@itemprop='name'][contains(text(),'Testing Supplier 2 Name')]")
  page.should have_selector(:xpath, "//*[@class='contact-details-block'][2]/*[@itemprop='telephone'][contains(text(),'+44 (0) 123456789')]")
  page.should have_selector(:xpath, "//*[@class='contact-details-block'][3]/*[@itemprop='email']/*[contains(text(),'Testing.supplier.2.NaMe@DMtestemail.com')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2]//*[contains(text(), 'Cloud technology and support')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[3]//*[contains(text(), 'Suppliers')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[4]//*[contains(text(), 'D')]")
end

Given /All services associated with supplier with ID '(.*)' have a status of '(.*)'$/ do |value,status|
  step "I am logged in as a 'Administrator' and navigated to the 'Services' page by searching on supplier ID '#{value}'"
  current_service_status = page.find(:xpath,"//*[@class='summary-item-field-with-action']//*[contains(@href, '1123456789012354')]/../../../td[5][text()]").text()
  if current_service_status == 'Public' || current_service_status == 'Private'
    step "I click the 'Edit' link for the service '1123456789012354'"
  elsif current_service_status == 'Removed'
    step "I click the 'Details' link for the service '1123456789012354'"
  end
  steps %Q{
    When I select '#{status}' as the service status
    And I click the 'Update status' button
    Then The service status is set as '#{status}'
  }
end

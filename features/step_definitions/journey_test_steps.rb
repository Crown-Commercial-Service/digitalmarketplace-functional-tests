# encoding: utf-8
require "ostruct"
require "rest_client"

Given /I am on the '(.*)' login page$/ do |user_type|
  if user_type == 'Administrator'
    visit("#{dm_frontend_domain}/admin/login")
  else user_type == 'Supplier'
    visit("#{dm_frontend_domain}/#{user_type.downcase}s/login")
  end
  page.should have_content("#{user_type}" ' login')
  page.should have_content('Email address')
  page.should have_content('Password')
  page.has_button?('Log in')
end

When /I login as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    fill_in('email_address', :with => (eval "dm_admin_uname"))
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

When /I click Edit for the service '(.*)'$/ do |value|
  find(:xpath, "//*[@class='summary-item-action-field']//a[contains(text(), 'Edit') and contains(@href, '#{value}')]").click
  @serviceID = value
end

Then /I am presented with the summary page for that service$/ do
  @existing_values = @existing_values || Hash.new
  @existing_values['summarypageurl'] = current_url
  servicename = find(
    :xpath,
    "//h1"
  ).text()
  @existing_values['servicename'] = servicename

  if current_url.include?('suppliers')
    servicestatus = find(
      :xpath,
      "//*[@class='selection-button selection-button-inline selection-button-selected']"
    ).text()
    @existing_values['servicestatus'] = servicestatus
  else
    page.should have_content('Pricing')
    page.should have_content('Documents')

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

  current_url.should have_content(@serviceID)
  page.should have_content('Service attributes')
  page.should have_content('Description')
  page.should have_content('Features and benefits')

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
end

Given /I have logged in to Digital Marketplace as a '(.*)' user$/ do |user_type|
  steps %Q{
    Given I am on the '#{user_type}' login page
    When I login as a '#{user_type}' user
  }
end

Given /I am logged in as a '(.*)' and am on the '(.*)' service summary page$/ do |user_type,value|
  if user_type == 'Administrator'
    steps %Q{
      Given I have logged in to Digital Marketplace as a '#{user_type}' user
      When I enter '#{value}' in the 'Service ID' field
      When I click 'Find service'
      Then I am presented with the summary page for that service
    }
  elsif user_type == 'Supplier'
    steps %Q{
      Given I am logged in as a 'DM Functional Test Supplier' '#{user_type}' user and am on the service listings page
      When I click Edit for the service '#{value}'
      Then I am presented with the summary page for that service
    }
  end
end

Then /I am logged out of Digital Marketplace as a '(.*)' user$/ do |user_type|
  if user_type == 'Administrator'
    page.should have_content('You have been logged out')
    page.should have_content('Email address')
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
    "//a[contains(@href , '/services/#{@serviceID.downcase}/#{action.downcase}/#{service_aspect.gsub(' ','_').downcase}')]"
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
  elsif page.has_content?('Pricing')
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
  find(:xpath, ".//*[@name='serviceBenefits']/..//*[@class='button-secondary list-entry-remove']//span[contains(text(), 'number 2')]/..").click
end

And /I add '(.*)' as a '(.*)'$/ do |value,item_to_add|
  record_number_to_add = (10 - ((find(
    :xpath,
    ".//*[@id='serviceFeatures']//button[contains(text(), 'Add another')]"
  ).text()).split(' (').last.split(' remaining').first).to_i)

  find(
    :xpath,
    ".//*[@id='serviceFeatures']//button[contains(text(), 'Add another')]"
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
    page.should have_content(@changed_fields['serviceName'])
    page.should have_content(@changed_fields['serviceSummary'])
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
  page.should have_content('Log out')
  page.should have_content(eval "dm_supplier_uname")
  current_url.should end_with("#{dm_frontend_domain}/suppliers")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[1]//*[contains(text(), 'Digital Marketplace')]")
end

Given /I am logged in as a '(.*)' '(.*)' user and am on the dashboard page$/ do |supplier_name,user_type|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    Then I am presented with the '#{supplier_name}' supplier dashboard page
  }
end

Given /I am logged in as a '(.*)' '(.*)' user and am on the service listings page$/ do |supplier_name,user_type|
  step "Given I have logged in to Digital Marketplace as a '#{user_type}' user"
  page.visit("#{dm_frontend_domain}/suppliers/services")
  step "Then I am presented with the '#{supplier_name}' supplier service listings page"
end

Then /I can see my supplier details on the dashboard$/ do
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Current services')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Supplier information')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Account information')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'G-Cloud 6')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), '8 services')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Supplier summary')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), 'This is a test supplier, which will be used solely for the purpose of running functional test.')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Clients')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content']//*[@class='hint summary-item-no-content'][contains(text(), 'None entered')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Contact name')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), 'Testing Supplier Name')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Website')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), 'www.dmfunctionaltestsupplier.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Email address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), 'Testing.supplier.NaMe@DMtestemail.com')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Phone number')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), '+44 (0) 123456789')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Address')]")
  find(:xpath, "//*[@class='summary-item-field-content']/address").text().should have_content('125 Kingsway London United Kingdom WC2B 6NH')
  page.should have_selector(:xpath, "//*[@class='summary-item-field-name'][contains(text(), 'Email address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-content'][contains(text(), 'testing.supplier.username@dmtestemail.com')]")
end

Then /I am presented with the '(.*)' supplier service listings page$/ do |supplier_name|
  page.should have_content(supplier_name)
  page.should have_content('Log out')
  page.should have_content(eval "dm_supplier_uname")
  current_url.should end_with("#{dm_frontend_domain}/suppliers/services")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[2]//*[contains(text(), '#{supplier_name}')]")
end

And /I can see all my listings ordered by lot name followed by listing name$/ do
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

When /I select the second listing on the page$/ do
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
    find(
      :xpath,
      "//a[contains(text(), '#{@existing_values['servicename']}')]/../../td[contains(@class, 'summary-item-field service-status')][text()]"
    ).text().should have_content(service_status)
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
  service_exist_on_listings_page = find(:xpath,
    "//a[contains(@href, '/service/#{@serviceID}')]"
  )

  if service_exist_on_listings_page == true
    find(:xpath,
      "//a[@href='#{dm_frontend_domain}/service/#{@serviceID}']/text()"
    ).text().should have_content("#{service_status}")
  end
end

Then /The status of the service is presented as '(.*)' on the admin users service summary page$/ do |service_status|
  step "Given I am logged in as a 'Administrator' and am on the '#{@serviceID}' service summary page"

  find(
    :xpath,
    "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
  ).text().should have_content("#{service_status}")
end

And /The service '(.*)' be searched$/ do |ability|
  page.visit("#{dm_frontend_domain}/g-cloud/search?q=#{@serviceID}")
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
  page.visit("#{dm_frontend_domain}/g-cloud/services/#{@serviceID}")
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

Then /I am taken to the '(.*)' landing page$/ do |page_name|
  page.should have_content("#{page_name}")
  page.should have_button('Show services')
  page.should have_link('Software as a Service')
  page.should have_link('Platform as a Service')
  page.should have_link('Infrastructure as a Service')
  page.should have_link('Specialist Cloud Services')
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[2][contains(text(), '#{page_name}')]")
end

Then /I am taken to the search results page with results for '(.*)' lot displayed$/ do |lot_name|
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[1]//*[contains(text(), 'Digital Marketplace')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[2]//*[contains(text(), 'Cloud technology and support')]")
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class= 'page-heading']//*[contains(text(), 'Search results')]")
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class='lot-filters']//*[contains(text(), 'Choose a category')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search') and contains(text(), 'All categories')]")
  find(:xpath, "//*[@class='search-summary-count']").text().should_not match(/^0$/)
  page.should have_selector(:xpath, ".//*[@id='content']//*[@class= 'search-summary']//*[contains(text(), '#{lot_name}')]")
  page.should have_selector(:xpath, "//*/label[contains(@class, 'option-select-label') and contains(text(), 'Keywords')]")

  case "#{lot_name.downcase}"
    when 'software as a service'
      lot = 'saas'
      page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[3][contains(text(), '#{lot_name}')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=paas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=iaas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=scs')]")
    when 'platform as a service'
      lot = 'paas'
      page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[3][contains(text(), '#{lot_name}')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=saas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=iaas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=scs')]")
    when 'infrastructure as a service'
      lot = 'iaas'
      page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[3][contains(text(), '#{lot_name}')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=saas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=paas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=scs')]")
    when 'specialist cloud services'
      lot = 'scs'
      page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']//*[@role='breadcrumbs']//li[3][contains(text(), '#{lot_name}')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=saas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=paas')]")
      page.should have_selector(:xpath, "//a[contains(@href, '/search?q=&lot=iaas')]")
  end

  current_url.should end_with("#{dm_frontend_domain}/g-cloud/search?lot=#{lot}")
  page.should have_no_selector(:xpath, "//a[contains(@href, '/search?q=&lot=#{lot}')]")
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

Then /I am taken to the search results page with a result for the service '(.*)'$/ do |value|
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/search?q=#{value.gsub(' ','+')}")
  find(:xpath, "//*[@class='search-summary-count']").text().to_i.should be > 0
  find(:xpath, "//*[@class='search-summary']/em[1]").text().should match("#{value}")
  find(:xpath, "//*[@class='search-summary']/em[2]").text().should match('All categories')
  find(:xpath, ".//*[@id='content']//*[@class='search-result-title']//a[contains(text(),'#{value}')]")
  page.should have_no_selector(:xpath, ".//div[@class='lot-filters']//li[1]/a")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=saas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=paas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=iaas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=scs')]")
  page.should have_selector(:xpath, ".//p[@class='search-result-supplier'][contains(text(), 'DM Functional Test Supplier')]")
  page.should have_selector(:xpath, ".//*[@class='search-result-metadata-item'][contains(text(), 'Infrastructure as a Service')]")
  page.should have_selector(:xpath, ".//*[@class='search-result-metadata-item'][contains(text(), 'G-Cloud 6')]")
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
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/search?q=#{value.gsub(' ','+')}&lot=iaas")
  find(:xpath, "//*[@class='search-summary-count']").text().should match(/^1$/)
  find(:xpath, "//*[@class='search-summary']/em[1]").text().should match("#{value}")
  find(:xpath, "//*[@class='search-summary']/em[2]").text().should match('Infrastructure as a Service')
  find(
    :xpath,
    ".//*[@id='content']//*[@class='search-result-title']//a[contains(text(),'#{value.split(' ').first} DM Functional Test N3 Secure Remote Access')]"
  )
  page.should have_no_selector(:xpath, ".//div[@class='lot-filters']//li[4]/a")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=saas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=paas')]")
  page.should have_selector(:xpath, "//a[contains(@href, '/search?q=#{value.split(' ').first}') and contains(@href, '&lot=scs')]")
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
  if @data_store['currentcount'] > 100 and @data_store['moreorless'] == 'more'
    page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  else @data_store['currentcount'] <= 100 and @data_store['moreorless'] == 'less'
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  end
end

Then /I am taken to page '(.*)' of results$/ do |page_number|
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
end

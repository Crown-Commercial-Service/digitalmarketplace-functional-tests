# encoding: utf-8
require "ostruct"
require "rest_client"

store = OpenStruct.new

Given /I am on the '(.*)' login page$/ do |value|
  case value
  when "Administrator"
    url = "#{dm_frontend_domain}/admin/login"
    page_header = "#{value} login"
  when "Digital Marketplace"
    url = "#{dm_frontend_domain}/login"
    page_header = "Log in to the Digital Marketplace"
  else
    fail("Unrecognised login page: '#{value}'")
  end

  visit(url)
  if page.has_link?("Log out")
    page.click_link("Log out")
  end

  page.should have_content(page_header)
  current_url.should end_with(url)
  page.should have_content("Email address")
  page.should have_content("Password")
  page.has_button?("Log in")
end

When /I login as a '(.*)' user$/ do |user_type|
  case user_type
  when "Administrator"
    page.fill_in('email_address', :with => dm_admin_email())
    page.fill_in('password', :with => dm_admin_password())
  when "Buyer"
    page.fill_in('email_address', :with => dm_buyer_email())
    page.fill_in('password', :with => dm_buyer_password())
  when "Supplier"
    page.fill_in('email_address', :with => dm_supplier_user_email())
    page.fill_in('password', :with => dm_supplier_password())
  when "CCS Sourcing"
    page.fill_in('email_address', :with => dm_admin_ccs_sourcing_email())
    page.fill_in('password', :with => dm_admin_password())
  when "CCS Category"
    page.fill_in('email_address', :with => dm_admin_ccs_category_email())
    page.fill_in('password', :with => dm_admin_password())
  else
    fail("Unrecognised user type '#{user_type}'")
  end
  @user_type = user_type
  page.click_button("Log in")
end

And /The supplier user '(.*)' '(.*)' login to Digital Marketplace$/ do |user_name,ability|
  visit("#{dm_frontend_domain}/login")
  if user_name == 'DM Functional Test Supplier User 2'
    page.fill_in('email_address', :with => dm_supplier_user2_email())
  elsif user_name == 'DM Functional Test Supplier User 3'
    page.fill_in('email_address', :with => dm_supplier_user3_email())
  end

  page.fill_in('password', :with => dm_supplier_password())
  page.click_button('Log in')

  if ability == 'can not'
    page.should have_content('Make sure you\'ve entered the right email address and password.')
  elsif ability == 'can'
    step "Then I am presented with the 'DM Functional Test Supplier' 'Supplier' dashboard page"
  end
end

Then /I am presented with the admin G-Cloud 7 declaration page$/ do
  page.find(:css, "h1").text().should == "G-Cloud 7 declaration"
  page.find(:css, "header p.context").text().should == @supplierName
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")

  section_headings = page.all(:css, "h2.summary-item-heading")
  section_headings.length.should == 4
  section_headings[0].text().should == "G-Cloud 7 essentials"
  section_headings[1].text().should == "About you"
  section_headings[2].text().should == "Grounds for mandatory exclusion"
  section_headings[3].text().should == "Grounds for discretionary exclusion"

  section_edit_links = page.all(:css, "a.summary-change-link")
  section_edit_links.length.should == 4
  section_edit_links[0][:href].should == "/admin/suppliers/#{@supplierID}/edit/declarations/g-cloud-7/g-cloud-7-essentials"
  section_edit_links[1][:href].should == "/admin/suppliers/#{@supplierID}/edit/declarations/g-cloud-7/about-you"
  section_edit_links[2][:href].should == "/admin/suppliers/#{@supplierID}/edit/declarations/g-cloud-7/grounds-for-mandatory-exclusion"
  section_edit_links[3][:href].should == "/admin/suppliers/#{@supplierID}/edit/declarations/g-cloud-7/grounds-for-discretionary-exclusion"

  page.all(:css, "table.summary-item-body").each do |section_table|
    column_headings = section_table.all(:css, "thead th")
    column_headings.length.should == 2
    column_headings[0].text().should == "Declaration question"
    column_headings[1].text().should == "Declaration answer"
  end

  declaration_answers = page.all(:xpath, "//tr[@class='summary-item-row']//td[2]")
  declaration_answers[0].text().should == "Yes"
  declaration_answers[17].text().should == "Button Moon"
  declaration_answers[30].text().should == "small"
end

Then /I am presented with the updated admin G-Cloud 7 declaration page$/ do
  page.find(:css, "h1").text().should == "G-Cloud 7 declaration"
  page.find(:css, "header p.context").text().should == @supplierName
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")

  declaration_answers = page.all(:xpath, "//tr[@class='summary-item-row']//td[2]")
  declaration_answers[0].text().should == "No"
  declaration_answers[51].text().should == "Everything"
end

Then /I am presented with the admin search page$/ do
  page.should have_content('Admin')
  page.should have_link('Service updates')
  page.should have_link('Service status changes')
  page.should have_link('Log out')
  page.should have_content('Find a service by service ID')
  page.should have_content('Find services by supplier ID')
  page.should have_content('Find users by supplier ID')
  page.should have_content('Find suppliers by name prefix')
  page.should have_content('Find users by email address')
  page.should have_link('G-Cloud 7 statistics')
end

When /I enter that service\.(.*) in the '(.*)' field$/ do |attr_name, field_name|
  step "I enter '\"#{@service[attr_name]}\"' in the '#{field_name}' field"
end

When /I enter the email address for the '(.*)' user in the '(.*)' field$/ do |user,field_name|
  user_email = {
    "DM Functional Test Supplier User 1" => dm_supplier_user_email(),
    "DM Functional Test Supplier User 2" => dm_supplier_user2_email(),
    "DM Functional Test Supplier User 3" => dm_supplier_user3_email()
  }[user]
  step "I enter '#{user_email}' in the '#{field_name}' field"
end

When /I enter '(.*)' in the '(.*)' field$/ do |value,field_name|
  @value_of_interest = @value_of_interest || Hash.new
  page.fill_in(field_name, with: value)

  if current_url.include?('company-contact-details')
    field_name = 'contact_email_address'
  elsif current_url.include?('create-your-account')
    field_name = 'your_email_address'
  else
    field_name = field_name
  end

  @value_of_interest[field_name] = value
  @servicesupplierID = value
end

And /I click the '(.*)' button$/ do |button_name|
  page.click_link_or_button(button_name)
end

When /I click the '(.*)' button for the supplier user '(.*)'$/ do |button_name,user_name|
  find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//input[contains(@type, 'submit') and contains(@value,'#{button_name}')]").click
end

When /I click the '(.*)' link for the service '(.*)'$/ do |link_name,value|
  find(:xpath, "//*[@class='summary-item-field-with-action']//a[contains(text(), '#{link_name}') and contains(@href, '#{value}')]").click
  @servicesupplierID = value
end

When /I click the '(.*)' link for the supplier '(.*)'$/ do |link_name, supplier_name|
  @supplierName = supplier_name
  rows = page.all(:css, "tr.summary-item-row").select do |row|
    row.all(:css, "td").first.text() == supplier_name
  end

  link = rows.first.find_link(link_name)
  if match = link['href'].match(%r"/admin/suppliers/(\d+)/")
    @supplierID = @servicesupplierID = match.captures[0]
  end
  link.click
end

When /I click the '(.*)' link in the '(.*)' column for the supplier '(.*)'/ do |link_name, column_name, supplier_name|
  @supplierName = supplier_name
  column_index = page.all(:css, "thead tr th").find_index {|elem| elem.text == column_name}
  row = page.all(:css, "tr.summary-item-row").select do |candidate_row|
    candidate_row.first(:css, "td").text == supplier_name
  end.first

  column = row.all(:css, "td").at(column_index)
  link = column.find_link(link_name)
  if match = link['href'].match(%r"/admin/suppliers/(\d+)/")
    @supplierID = @servicesupplierID = match.captures[0]
  end
  link.click
end

Then /I am presented with the summary page for that service$/ do
  @existing_values = @existing_values || Hash.new
  @existing_values['summarypageurl'] = current_url
  servicename = find(:xpath, "//h1").text()
  @existing_values['servicename'] = servicename
  serviceid = URI.parse(current_url).to_s.split('services/').last
  @existing_values['serviceid'] = serviceid

  if current_url.include?('suppliers')
    # if the remove button exists
    remove_button = first(
      :xpath,
      "//input[@class='button-destructive' and @value='Remove service']"
    )
    if remove_button
      @existing_values['servicestatus'] = 'Live'
    else
      @existing_values['servicestatus'] = 'Removed'
    end

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
      "//*[contains(text(), 'Pricing document')]/../../td[2]/span/a"
    )['href']
    @existing_values['pricingdocument'] = pricingdocument

    servicedefinitiondocument = find(
      :xpath,
      "//*[contains(text(), 'Service definition document')]/../../td[2]/span/a"
    )['href']
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
    Given I am on the '#{login_page_type(user_type)}' login page
    When I login as a '#{user_type}' user
  }
end

Given /^I am logged in as '(.*)' and am on the '(.*)' service summary page$/ do |user_type,value|
  @servicesupplierID = value
  if user_type == 'Administrator'
    steps %Q{
      Given I have logged in to Digital Marketplace as a '#{user_type}' user
      When I enter '#{value}' in the 'service_id' field
      When I click the search button for 'service_id'
      Then I am presented with the summary page for that service
    }
  elsif user_type == 'Supplier'
    step "I am logged in as 'DM Functional Test Supplier' '#{user_type}' user and am on the service listings page"
    find(
      :xpath,
      ".//a[contains(@href, '/suppliers/services/#{value}')]"
    ).click
    step "I am presented with the summary page for that service"
  end
end

Then /I am logged out of Digital Marketplace as a '(.*)' user$/ do |user_type|
  case user_type
  when "Administrator"
    page.should have_content('You have been logged out')
    page.should have_content('Administrator login')
  when "Buyer" , "Supplier"
  page.has_link?("Log in")
  page.has_link?('Create supplier account')
  page.should have_content('Log in to the Digital Marketplace')
  page.should have_content('Email address')
  page.should have_content('Password')
  page.has_button?('Log in')
  page.has_link?('Forgotten password')
  else
    fail("User type \"#{user_type}\" does not exist")
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

When /^I change '(.*)' to '(.*)'$/ do |field_to_change,new_value|
  page.find(
    :xpath,
    "//*[contains(@id, '#{field_to_change}') and contains(@class, 'text-box')]"
  ).set(new_value)

  @changed_fields = @changed_fields || Hash.new
  @changed_fields[field_to_change] = new_value
end

And /I set '(.*)' as '(.*)'$/ do |field_to_change,new_value|
  within "##{field_to_change}" do
    page.find("option[value=#{new_value}]").select_option
  end
  @changed_fields[field_to_change] = new_value.downcase
end

And /I choose '(.*)' for '(.*)'$/ do |value,field_name|
  within "##{field_name}" do
    page.find(:xpath, ".//label[contains(text(), '#{value}')]").click
  end

  @changed_fields = @changed_fields || Hash.new
  @changed_fields[field_name] = value
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
    price_string = "£#{@changed_fields['input-minimum-price']} to £#{@changed_fields['input-maximum-price']} " \
                   "per #{@changed_fields['input-price-unit']} per #{@changed_fields['input-pricing-interval']}"
    find(
      :xpath,
      "//*[contains(text(), 'Service price')]/../../td[2]/span[text()]"
    ).text().should have_content(price_string)
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

When /^I change '(.*)' file to '(.*)'$/ do |document_to_change,new_document|
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

When /I navigate to the '(.*)' '(.*)' page$/ do |action,page_name|
  step "I click the '#{action}' link for '#{page_name}'"
  if page_name == 'Description'
    page.should have_content(page_name)
    page.should have_content('Service name')
    page.should have_content('Service summary')
  elsif page_name == 'Features and benefits'
    page.should have_content(page_name)
    page.should have_content('Service features')
    page.should have_content('Service benefits')
  elsif page_name == 'Pricing'
    page.should have_content(page_name)
    page.should have_content('VAT included')
    page.should have_content('Education pricing')
    page.should have_content('Trial option')
    page.should have_content('Free option')
    page.should have_content('Minimum contract period')
  elsif page_name == 'Documents'
    page.should have_content(page_name)
    page.should have_content('Service definition document')
    page.should have_content('Please upload your terms and conditions document')
    page.should have_content('Skills Framework for the Information Age (SFIA) rate card')
    page.should have_content('Pricing document')
  elsif page_name == 'Supplier information'
    page.should have_content('Edit '"#{page_name.downcase}")
    page.should have_content('Supplier summary')
    page.should have_content('Clients')
    page.should have_content('Contact name')
    page.should have_content('Website')
    page.should have_content('Email address')
    page.should have_content('Phone number')
    page.should have_content('Business address')
  else
    page.should have_content(page_name)
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
  page.should have_selector(:xpath, "//a[@href = '#{@existing_values['pricingdocument']}']")
end

Then /I am presented with the service details page for that service$/ do
  current_url.should end_with("#{dm_frontend_domain}/g-cloud/services/#{@servicesupplierID}")
  page.should have_content(@existing_values['servicename'])
  page.should have_content(@existing_values['servicesummary'])
  page.should have_content(@existing_values['servicefeature3'])
  page.should have_no_content('2nd service benefit')
  page.should have_content(@existing_values['serviceprice'])
end

Then /I am presented with the '(.*)' '(.*)' dashboard page$/ do |user_type_name, user_type|
  user_type = user_type.downcase
  case user_type
  when "buyer"
    ['Unpublished requirements', 'Published requirements'].each do |header|
      page.should have_selector(:xpath, ".//h2[@class='summary-item-heading'][contains(text(), '#{header}')]")
    end
    page.should have_content(dm_buyer_email())
  when "supplier"
    @existing_values = @existing_values || Hash.new
    @existing_values['summarypageurl'] = current_url
    page.should have_content(dm_supplier_user_email())
  else
    fail("User type \"#{user_type}\" does not exist")
  end
  page.should have_content(user_type_name)
  page.should have_link('Log out')
  current_url.should end_with("#{dm_frontend_domain}/#{user_type}s")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
end

Given /^I am logged in as '(.*)' '(.*)' user and am on the dashboard page$/ do |user_name,user_type|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    Then I am presented with the '#{user_name}' '#{user_type}' dashboard page
  }
end

Given /^I am logged in as '(.*)' and navigated to the '(.*)' page by searching on supplier ID '(.*)'$/ do |user_type,page_name,value|
  if value == '11111'
    supplier_name = 'DM Functional Test Supplier'
  elsif value == '11112'
    supplier_name = 'DM Functional Test Supplier 2'
  end

  if page_name == 'Services'
    search_button_name = 'supplier_id_for_services'
  elsif page_name == 'Users'
    search_button_name = 'supplier_id_for_users'
  end

  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    When I enter '#{value}' in the '#{search_button_name}' field
    And I click the search button for '#{search_button_name}'
    Then I am presented with the '#{page_name}' page for the supplier '#{supplier_name}'
  }
end

Given /^I am logged in as '(.*)' and navigated to the '(.*)' page for supplier '(.*)'$/ do |user_type,page_name,value|
  step "I have logged in to Digital Marketplace as a '#{user_type}' user"
  if value == 'DM Functional Test Supplier'
    supplierID = '11111'
  end

  if page_name == 'Upload a G-Cloud 7 countersigned agreement'
    page.visit("#{dm_frontend_domain}/admin/suppliers/#{supplierID}/countersigned-agreements/g-cloud-7")
  end
end

def login_page_type(user_type)
  case user_type
  when "CCS Sourcing", "CCS Category", "Administrator"
    return "Administrator"
  when "Supplier", "Buyer"
    return "Digital Marketplace"
  else
    fail("User type \"#{user_type}\" does not exist")
  end
end

Given /^I am logged in as '(.*)' and navigated to the '(.*)' page by searching on suppliers by name prefix '(.*)'$/ do |user_type,page_name,name_prefix|
  steps %Q{
    Given I have logged in to Digital Marketplace as a '#{user_type}' user
    When I enter '#{name_prefix}' in the 'supplier_name_prefix' field
    And I click the search button for 'supplier_name_prefix'
    Then I am presented with the 'Suppliers' page for all suppliers starting with '#{name_prefix}'
  }
end

Given /^I am logged in as '(.*)' '(.*)' user and am on the service listings page$/ do |supplier_name,user_type|
  steps %Q{
    Given I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page
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
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span/p[contains(text(), '8 services')]")
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
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span/a[contains(text(), 'www.dmfunctionaltestsupplier.com')]")
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
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user_email()}')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user2_email()}')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 3')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user3_email()}')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-body']/caption[contains(text(), 'Account information')]/following-sibling::*[2]//*[@class='summary-item-field-first']/span[contains(text(), 'Email address')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user_email()}')]")
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
  step "I am presented with the message '#{user_name} (#{@data_store['supplieruseremail']}) has been removed as a contributor.'"
end

And /I should not see the supplier user '(.*)' on the supplier dashboard page$/ do |user_name|
  steps %Q{
    Given I click the 'Your account' link
    Then I am presented with the 'DM Functional Test Supplier' 'Supplier' dashboard page
    And I should not see the supplier user '#{user_name}' in the 'Contributors' table
    }
end

And /I should not see the supplier user '(.*)' in the '(.*)' table$/ do |user_name,summary_table_name|
    page.should_not have_selector(:xpath, "//caption[contains(text(), '#{summary_table_name}')]/..//td/span[contains(text(), '#{user_name}')]")
end

Then /I am presented with the '(.*)' page for the supplier '(.*)'$/ do |page_name,supplier_name|
  if page_name == 'Change supplier name'
    page.should have_selector(:xpath, "*//header/h1[contains(text(), '#{page_name}')]")
    page.should have_selector(:xpath, "//div[@id='new_supplier_name']//*[contains(text(),'New name')]")
    page.should have_selector(:xpath, "//input[contains(@class,'text-box') and contains(@value,'#{supplier_name}')]")
    page.should have_button('Save')
    current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/#{@servicesupplierID}/edit/name")
  else
    if dm_supplier_user_emails().include?(@servicesupplierID) or @servicesupplierID == "DM Functional Test Supplier"
      @servicesupplierID = '11111'
    end

    if page_name == 'Users'
      page.should have_selector(:xpath, "*//header/h1[contains(text(), '#{supplier_name}')]")
      case @user_type
      when 'Administrator'
        page.should have_button('Deactivate')
        page.should have_button('Remove from supplier')
      when 'CCS Category'
        page.should have_no_button('Deactivate')
        page.should have_no_button('Remove from supplier')
      else
        fail("Invalid user on admin suppliers page #{@user_type}")
      end
    elsif page_name == 'Services'
      page.should have_selector(:xpath, "*//header/h1[contains(text(), '#{page_name}')]")
    end
    current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/#{page_name.downcase}?supplier_id=#{@servicesupplierID}")
  end
  page.should have_link('Log out')
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2][contains(text(), '#{supplier_name}')]")
end

Then /I am presented with the 'Suppliers' page for all suppliers starting with 'DM Functional Test Supplier'$/ do ||
  search_prefix = 'DM Functional Test Supplier'
  page.should have_content('Suppliers')
  page.should have_link('Log out')
  URI.decode_www_form(URI.parse(current_url).query).assoc('supplier_name_prefix').last.should == search_prefix

  table_rows = page.all(:css, "tr.summary-item-row")
  table_rows.length.should == 2

  table_rows.each do |row|
    row.all(:css, "td").first.text.should start_with(search_prefix)
  end

  case @user_type
  when 'Administrator'
    expected_links = ['Change name', 'Users', 'Services']
    page.should have_no_link('Edit declaration')
    page.should have_no_link('Download agreement')
    page.should have_no_link('Download signed agreement')
    page.should have_no_link('Upload countersigned agreement')
  when 'CCS Sourcing'
    expected_links = [
      'Edit declaration',
      'Download agreement',
      'Download signed agreement',
      'Upload countersigned agreement'
    ]
    page.should have_no_link('Change name')
    page.should have_no_link('Users')
    page.should have_no_link('Services')
  when 'CCS Category'
    expected_links = ['Users', 'Services']
    page.should have_no_link('Change name')
    page.should have_no_link('Edit declaration')
    page.should have_no_link('Download agreement')
    page.should have_no_link('Download signed agreement')
    page.should have_no_link('Upload countersigned agreement')
  else
    fail("Invalid user on admin suppliers page #{@user_type}")
  end

  table_rows[0].all(:css, "td").first.text.should == "DM Functional Test Supplier"
  expected_links.each do |expected_link|
    table_rows[0].all(:css, "a").map(&:text).should include(expected_link)
  end

  table_rows[1].all(:css, "td").first.text.should == "DM Functional Test Supplier 2"
  expected_links.each do |expected_link|
    table_rows[1].all(:css, "a").map(&:text).should include(expected_link)
  end
end

And /I can see all listings ordered by lot name followed by listing name$/ do
  services_listed([
    "1123456789012348",
    "1123456789012352",
    "1123456789012347",
    "1123456789012351",
    "1123456789012346",
    "1123456789012350",
    "1123456789012349",
    "1123456789012353",
  ])
end

Then /I can see active users associated with '(.*)' on the dashboard$/ do |supplier_name|
  page.should have_selector(:xpath, "//*[@class='summary-item-heading'][contains(text(), 'Contributors')]")
  ['Name', 'Email address'].each do |header|
    page.should have_selector(:xpath, "//caption[contains(text(), 'Contributors')]/..//th/span[contains(text(), '#{header}')]")
  end
  [
    'DM Functional Test Supplier User 1', dm_supplier_user_email(),
    'DM Functional Test Supplier User 2', dm_supplier_user2_email(),
    'DM Functional Test Supplier User 3', dm_supplier_user3_email()
    ].each do |cell|
    page.should have_selector(:xpath, "//caption[contains(text(), 'Contributors')]/..//td/span[contains(text(), '#{cell}')]")
  end
end

def services_listed(service_ids)
  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  service_ids.each.with_index(1) do |service_id, order_number|
    service_url = "#{url}/services/#{service_id}"
    response = RestClient.get(service_url, headers){|response, request, result| response }
    json = JSON.parse(response)
    service_name = json["services"]["serviceName"]
    service_lot = json["services"]["lotName"]
    xpath_to_check = find(:xpath, "*//table/tbody/tr[#{order_number}][td/text()]").text()

    if response.code == 404
      puts "Service #{service_id} does not exist"
    else
      xpath_to_check.should have_content("#{service_name}")
      xpath_to_check.should have_content("#{service_lot}")
    end
  end
end

When /I click the service name link for the second listing on the page$/ do
  @data_store = @data_store || Hash.new

  servicename = find(
    :xpath,
    "//*/table/tbody/tr[2]/td[1]/span/a"
  ).text()
  @data_store['servicename'] = servicename

  page.click_link_or_button(@data_store['servicename'])
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
    find(
      :xpath,
      "//a[contains(text(), '#{@existing_values['servicename']}')]/../../..//td[4]/span"
    ).text().should have_content(service_status)
  elsif current_url.include?('admin')
    find(
      :xpath,
      "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
    ).text().should have_content(service_status)
  end
end

And /I am presented with a service removal message for the '(.*)' service$/ do |value|
  service_name = find(:xpath,
    "//a[contains(@href, '/suppliers/services/#{value}')]"
  ).text()

  step "And I am presented with the message '#{service_name} has been removed.'"
end

And /I am presented with the message '(.*)'$/ do |message_text|
  page.should have_content(message_text)
end

Then /The status of the service is presented as '(.*)' on the supplier users service listings page$/ do |service_status|
  step "I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the service listings page"

  find(:xpath,
    "//a[contains(@href, '/suppliers/services/#{@servicesupplierID}')]/../../../td[4]/span"
  ).text().should have_content("#{service_status}")
end

Then /The status of the service is presented as '(.*)' on the admin users service summary page$/ do |service_status|
  step "I am logged in as 'Administrator' and am on the '#{@servicesupplierID}' service summary page"
  find(
    :xpath,
    "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
  ).text().should have_content("#{service_status}")
end

And /A message stating the supplier has stopped offering this service on todays date is presented on the '(.*)' service summary page$/ do |user_type|
  time = Time.new
  todays_date = time.strftime("%A %d %B %Y")

  case user_type
  when 'Supplier'
    step "I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page"
    page.visit("#{dm_frontend_domain}/suppliers/services/#{@servicesupplierID}")
    page.find(:xpath,
      "//div[@class='banner-temporary-message-without-action']/h2[contains(text(),'This service was removed on #{todays_date}')]/following-sibling::p[@class='banner-message'][contains(text(),'If you don’t know why this service was removed')]"
    )
  when 'Buyer'
    page.find(:xpath,
      "//div[@class='banner-temporary-message-without-action']/h2[contains(text(),'DM Functional Test Supplier stopped offering this service on #{todays_date}.')]/following-sibling::p[@class='banner-message'][contains(text(),'Any existing contracts for this service are still valid')]"
    )
  else
    fail("Unrecognised user type: '#{user_type}'")
  end
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

#TODO - uncomment the following block when DOS goes live
    # page.should have_link('Find an individual specialist')
    # page.should have_link('Find a team to provide an outcome')
    # page.should have_link('Find user research participants')
    # page.should have_link('Find a user research lab')
    # page.should have_link('View your briefs and supplier responses')

    page.should have_link('Find cloud technology and support')
    page.should have_link('Buy physical datacentre space for legacy systems')

  elsif page_name == 'Cloud technology and support'
    page.visit("#{dm_frontend_domain}/g-cloud")
    step "Then I am taken to the '#{page_name}' landing page"
  end
end

When /I click the '(.*)' link$/ do |link_name|
  step "I click the '#{link_name}' button"
end

Then /^I download the contersigned agreement$/ do
    href = page.find(:xpath, './/a[@download=""][contains(text(),"Download agreement")]')[:href]
    url_to_visit=("#{dm_frontend_domain}#{href}")
    page.visit(url_to_visit)
    header = page.response_headers
    store.content_length = header['Content-Length']
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
    filter_to_check("Service management","Datacentres adhere to the EU code of conduct for energy-efficient datacentres","")
    filter_to_check("Service management","Backup, disaster recovery and resilience plan in place","")
    filter_to_check("Service management","Self-service provisioning supported","")
    filter_to_check("Service management","Support accessible to any third-party suppliers","")
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
  find(:xpath, "//*[@class='search-summary']/em[1]").text().should == normalize_whitespace(value)
end

Then /Selected lot is that service.lot with links to the search for that service.(.*)$/ do |attr|
  lot = @service['lotName'] || full_lot(@service['lot'])
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
      lot_links.should_not include_url(lot_link)
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
      lot_links.should include_url(lot_link)
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
  service_result.first(:xpath, ".//li[@class='search-result-metadata-item'][1]").text.should == (@service['lotName'] || full_lot(@service['lot']))
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
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'N3')]").text().should have_content('N3')
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'Secure')]").text().should have_content('Secure')
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'secure')]").text().should have_content('secure')
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'Remote')]").text().should have_content('Remote')
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'Access')]").text().should have_content('Access')
  page.first(:xpath, ".//mark[@class='search-result-highlighted-text'][contains(text(),'access')]").text().should have_content('access')
end

Given /I am on the search results page with results for that service.lot displayed$/ do
  step "Given I am on the search results page with results for '#{@service['lotName'] || full_lot(@service['lot'])}' lot displayed"
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

When /^I choose file '(.*)' for '(.*)'$/ do |file, label|
  attach_file(label, File.join(Dir.pwd, 'fixtures', file))
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

When /There is '(.*)' than the pagination limit results returned$/ do |more_or_less|
  @data_store = @data_store || Hash.new
  current_count = find(:xpath, "//*[@class='search-summary-count']").text().to_i
  number_of_pages = (current_count.to_f/dm_pagination_limit()).ceil
  @data_store['currentcount'] = current_count
  @data_store['numberofpages'] = number_of_pages
  @data_store['moreorless'] = more_or_less
end

Then /Pagination is '(.*)'$/ do |availability|
  if current_url.include?('search?')
    if @data_store['currentcount'] > dm_pagination_limit() && @data_store['moreorless'] == 'more'
      pagination_available = 'available'
    elsif @data_store['currentcount'] <= dm_pagination_limit() && @data_store['moreorless'] == 'less'
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
    current_url.should include("#{dm_frontend_domain}/g-cloud/search?")
    current_url.should include("page=#{page_number}")
    current_url.should include("lot=iaas")
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
    current_url.should include("#{dm_frontend_domain}/g-cloud/suppliers?")
    current_url.should include("prefix=#{@data_store['supplier_alphabet']}")
    current_url.should include("page=#{page_number}")
    current_url.should include("framework=g-cloud")
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
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'activate')]/input[contains(@type,'submit')]").value.should match('Activate')
  elsif user_lockoractive_state == 'active'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'activate')]/input[contains(@type,'submit')]").value.should match('Deactivate')
  elsif user_lockoractive_state == 'locked'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'lock')]/input[contains(@type,'submit')]").value.should match('Unlock')
  elsif user_lockoractive_state == 'not locked'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td[5]/span[text()]").text().should match('No')
  end
end

Given /The supplier user '(.*)' has 5 failed login attempts$/ do |user_name|
  step "The user '#{user_name}' is locked"
end

Then /The supplier user '(.*)' is '(.*)' on the admin Users page$/ do |user_name, user_lockoractive_state|
  steps %Q{
    Given I am logged in as 'Administrator' and navigated to the 'Users' page by searching on supplier ID '11111'
    Then The supplier user '#{user_name}' is '#{user_lockoractive_state}'
  }
end

And /The supplier user '(.*)' '(.*)' listed as a contributor on the dashboard of another user of the same supplier$/ do |user_name,value|
 step "I am logged in as 'DM Functional Test Supplier' 'Supplier' user and am on the dashboard page"

  if value == 'is not'
    page.should have_no_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
    page.should have_no_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user2_email()}')]")
  elsif value == 'is'
    page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 2')]")
    page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user2_email()}')]")
  end
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 1')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user_email()}')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field-first']/span[contains(text(), 'DM Functional Test Supplier User 3')]")
  page.should have_selector(:xpath, "//*[@class='summary-item-field']/span[contains(text(), '#{dm_supplier_user3_email()}')]")
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
  step "I am logged in as 'Administrator' and navigated to the 'Services' page by searching on supplier ID '#{value}'"
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

And /All users for the supplier ID 11111 are listed on the page$/ do
  page.should have_selector(:xpath, "//table/caption[contains(text(),'Users')]/../tbody/*//span[contains(text(),'DM Functional Test Supplier User 1')]")
  page.should have_selector(:xpath, "//table/caption[contains(text(),'Users')]/../tbody/*//span[contains(text(),'DM Functional Test Supplier User 2')]")
  page.should have_selector(:xpath, "//table/caption[contains(text(),'Users')]/../tbody/*//span[contains(text(),'DM Functional Test Supplier User 3')]")
end

Then /The page for the '(.*)' user is presented$/ do |user|
  user_email = {
    "DM Functional Test Supplier User 1" => dm_supplier_user_email(),
    "DM Functional Test Supplier User 2" => dm_supplier_user2_email(),
    "DM Functional Test Supplier User 3" => dm_supplier_user3_email()
  }[user]

  page.should have_content("#{user_email}")
  page.should have_link('Log out')
  current_url.should end_with("#{dm_frontend_domain}/admin/users?email_address=#{user_email.downcase.split('@').first}%40#{user_email.downcase.split('@').last}")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
end

Then /I am presented with the '(.*)' statistics page$/ do |framework_name|
  page.find(
    :xpath,
    "//p[contains(text(), '#{framework_name}')]/../h1[contains(text(), 'Statistics')]"
    )
  case framework_name
  when 'G-Cloud 7'
    current_url.should end_with("#{dm_frontend_domain}/admin/statistics/g-cloud-7")
  when 'Digital Outcomes and Specialists'
    current_url.should end_with("#{dm_frontend_domain}/admin/statistics/digital-outcomes-and-specialists")
  else
    fail("There is no such framework statistics page for \"#{framework_name}\"")
  end

    page.should have_link('Big screen view')
    page.should have_content('Services by status')
    page.should have_content('Complete services by lot')
    page.should have_content('Suppliers')
    page.should have_content('Users by last login time')
    page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
end

Then /I am presented with the Service updates page$/ do
  todays_date = Time.new.strftime("%A %d %B %Y")
  page.find(:xpath,"//p[contains(text(), 'Activity for')]/../h1[contains(text(), '#{todays_date}')]")
  page.should have_selector(:xpath, "//*/div/label[@for='audit_date'][contains(text(), 'Audit Date')]")
  page.should have_selector(:xpath, "//*[contains(@id, 'audit_date') and contains(@placeholder, 'eg, 2015-07-23')]")
  page.should have_selector(:xpath, "//*/div[@class='option-select-label'][contains(text(), 'Show')]")
  page.find(:xpath, "//*/div[@class='options-container']//label[@for='acknowledged-1']/input[@type='radio']/..").text().should match('All')
  page.find(:xpath, "//*/div[@class='options-container']//label[@for='acknowledged-2']/input[@type='radio']/..").text().should match('Acknowledged')
  page.find(:xpath, "//*/div[@class='options-container']//label[@for='acknowledged-3']/input[@type='radio']/..").text().should match('Not acknowledged')
  page.find(:xpath, "//*/button[contains(@class, 'button-save') and contains(@type, 'submit')][text()]").text().should match('Filter')
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2][contains(text(), 'Audits')]")
  page.should have_link('Service updates')
  page.should have_link('Service status changes')
  page.should have_link('Log out')
end

When /I navigate to the Service status changes page for changes made yesterday$/ do
  page.visit("#{dm_frontend_domain}/admin/service-status-updates/#{(Date.today-1)}")
end

Then /I am presented with the Service status changes page for changes made '(.*)'$/ do |day|
  page.should have_selector(:xpath, "//h1[contains(text(),'Service status changes')]")
  todays_date = Date.today.strftime("%A %d %B %Y")
  yesterdays_date = (Date.today-1).strftime("%A %d %B %Y")
  tomorrows_date = (Date.today+1).strftime("%A %d %B %Y")
  previous_date = (Date.today-2).strftime("%A %d %B %Y")

  if page.all(:css, "tr.summary-item-row").length == 0
    page.should have_selector(:xpath, "//p[@class='summary-item-no-content'][contains(text(),'No changes')]")
  else

    case day
    when 'today'
      top_record_time_stamp = page.find(:xpath, "//tbody/tr[1]/td[5]/span").text()
      store.first_time = DateTime.parse(top_record_time_stamp)
      page.find(:xpath,"//h2[contains(text(), '#{todays_date}')]")
      page.should have_no_link('Next day')
      page.should have_no_selector(:xpath, "//a[@rel='previous']/span[@class='pagination-label'][text()='#{tomorrows_date}']")
      date_of_interest = todays_date
    when 'yesterday'
      page.find(:xpath,"//h2[contains(text(), '#{yesterdays_date}')]")
      page.should have_link('Next day')
      page.should have_selector(:xpath, "//a[@rel='previous']/span[@class='pagination-label'][text()='#{todays_date}']")
      date_of_interest = yesterdays_date
    else
      fail("There is no Service status changes page for \"#{day}\"")
    end

    next_pagination_part_title = page.find(:xpath, "//a[@rel='next']/span[@class='pagination-part-title']").text()
    if next_pagination_part_title == "Page 2"
      page.should have_link('Page 2')
      page.should have_selector(:xpath, "//a[@rel='next']/span[@class='pagination-label'][text()='of #{date_of_interest}']")
    elsif next_pagination_part_title == "Previous day"
      page.should have_link('Previous day')
      if day == "today"
        page.should have_selector(:xpath, "//a[@rel='next']/span[@class='pagination-label'][text()='#{yesterdays_date}']")
      elsif day == "yesterday"
        page.should have_selector(:xpath, "//a[@rel='next']/span[@class='pagination-label'][text()='#{previous_date}']")
      end
    else
      fail("There is an error with pagination links/label on the page \"#{next_pagination_label}\"")
    end
  end

  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[2][contains(text(), 'Audits')]")
  page.should have_link('Service updates')
  page.should have_link('Service status changes')
  page.should have_link('Log out')
end

And /There is a new row for the '(.*)' status change in the service status change page$/ do |service_status|
  page.visit("#{dm_frontend_domain}/admin/service-status-updates/#{Date.today}")
  top_record_time_stamp = page.find(:xpath, "//tbody/tr[1]/td[5]/span").text()
  second_time = DateTime.parse(top_record_time_stamp)

  def check_latest_row_correct(service_status)
    top_record_time_stamp = page.find(:xpath, "//tbody/tr[1]/td[5]/span").text()
    case service_status
    when 'Live'
      page.should have_xpath("//tbody/tr[1]/td[3]/span[contains(text(),'Live')]/../../td[5]/span[contains(text(),'#{top_record_time_stamp}')]")
    when 'Removed'
      page.should have_xpath("//tbody/tr[1]/td[3]/span[contains(text(),'Removed')]/../../td[5]/span[contains(text(),'#{top_record_time_stamp}')]")
    else
      fail("There is no such service status: \"#{service_status}\"")
    end
  end

  if store.first_time == nil
    check_latest_row_correct(service_status)
    store.first_time = DateTime.parse(top_record_time_stamp)
  elsif store.first_time < second_time
    check_latest_row_correct(service_status)

  elsif store.first_time == second_time
      fail("An error has occured: There has not been any new status changes recorded")
  end
end

Then /I am presented with the '(.*)' page with the changed supplier name '(.*)' listed on the page$/ do |page_name,supplier_name|
  page.should have_content("#{page_name}")
  page.should have_link('Log out')
  current_url.should end_with("#{dm_frontend_domain}/admin/#{page_name.downcase}?supplier_name_prefix=#{supplier_name.split('M Functional Test Supplier').first}")
  page.should have_selector(:xpath, "//table/tbody/tr/td/span[contains(text(),'#{supplier_name}')]")
end

Then /^there is no '(.*)' link for any supplier$/ do |link_text|
  page.all(:css, "tr.summary-item-row").each do |row|
    row.all(:css, "td a").each do |link|
      link.text().should_not == link_text
    end
  end
end

Given /^no '(.*)' framework agreements exist$/ do |framework_slug|
  ensure_no_framework_agreements_exist(framework_slug)
end

Given /^a '(.*)' signed agreement is uploaded for supplier '(\d+)'$/ do |framework_slug, supplier_id|
  original_framework_status = update_framework_status(framework_slug, "open")
  register_interest_in_framework(framework_slug, supplier_id)
  submit_supplier_declaration(framework_slug, supplier_id, {
    "status" => "complete", "SQ1-1a" => "company name"
  })
  update_framework_agreement_status(framework_slug, supplier_id, true)
  update_framework_status(framework_slug, original_framework_status)
end

Then /^the framework agreement list is empty$/ do
  page.all(:css, ".summary-item-row").length.should == 0
end

Then /^the first signed agreement should be for supplier '(.*)'$/ do |supplier_name|
  page.first(:css, ".summary-item-row").first("td").text().should == supplier_name
end

When /^I click the first download agreement link$/ do
  path = page.first(:css, ".summary-item-row a")[:href]
  url = "#{dm_frontend_domain}#{path}"
  headers = {"Cookie" => page.response_headers['Set-Cookie']}
  @response = RestClient.get(url, headers){|response, request, result| response}
end

Then /^I should get redirected to the correct '(.+)' S3 URL for supplier '(\d+)'$/ do |framework_slug, supplier_id|
  @response.code.should == 302
  @response.headers[:location].should match(%r"/#{framework_slug}/agreements/#{supplier_id}/.*signed-framework-agreement.pdf")
end

Then /^I am presented with the \/"(.*?)" page\/$/ do |page_name|
  current_url.should end_with("#{dm_frontend_domain}/reset-password")
  page.should have_content(page_name)
  page.should have_field("Email address")
  page.should have_button("Send reset email")
end

When /^I attempt to load the '(.*)' page directly via the URL '(.*)'$/ do |page_name,url|
  page.visit("#{dm_frontend_domain}/#{url}")
end

Then /^I am presented with the '(.*)' warning page$/ do |warning_message|
  page.should have_content(warning_message)
end

Then /^There is no '(.*)' link$/ do |link_text|
  page.should_not have_link(link_text)
end

Then /^I am presented with the '(.*)' page$/ do |page_name| #Specific to admin pages only as it checks for the "Admin home" breadcrumb
  case page_name
  when 'Upload Digital Outcomes and Specialists communications'
    current_url.should end_with("#{dm_frontend_domain}/admin/communications/digital-outcomes-and-specialists")
    page.should have_button("Upload files")
  when 'Download user list'
    current_url.should end_with("#{dm_frontend_domain}/admin/users/download")
    page.should have_link("Digital Outcomes and Specialists")
    page.should have_link("G-Cloud 7")
  when 'Upload a G-Cloud 7 countersigned agreement'
    current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/11111/countersigned-agreements/g-cloud-7")
    if page.has_no_content?('No agreements have been uploaded')
      page.should have_link("Download agreement")
      page.should have_link("Remove")
    end
    page.should have_button("Upload file")
  when 'Grounds for discretionary exclusion'
    current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/11111/edit/declarations/g-cloud-7/grounds-for-discretionary-exclusion")
    page.should have_button("Save and return to summary")
    page.should have_link("Return without saving")
  else
    current_url.should end_with("#{dm_frontend_domain}/admin/suppliers/11111/edit/declarations/g-cloud-7/g-cloud-7-essentials")
    page.should have_button("Save and return to summary")
    page.should have_link("Return without saving")
  end
  page.should have_selector(:xpath, "//h1[contains(text(), '#{page_name}')]")
  page.should have_selector(:xpath, ".//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Admin home')]")
end

Then /^The correct file of '(.*)' with file content type of '([^"]*)' is made available$/ do |file_name, content_type|
  header = page.response_headers
  if header['Content-Disposition'] != nil
    header_file = header['Content-Disposition']
    header_file.should match /^attachment/
    header_file.should match /filename=#{file_name}$/
  else
    header_content_length = header['Content-Length']
    header_content_length.should match store.content_length
  end

  header_content_type = header['Content-Type']
  header_content_type.should match /#{content_type}/
end

And /There is no agreement available on the page$/ do
  page.should have_content('No agreements have been uploaded')
  page.should have_no_selector(:xpath, "//tbody/tr[@class='summary-item-row']/*/span[contains(text(), 'G-Cloud 7 countersigned agreement')]")
end

Given /^I navigate directly to the page '(.*)'$/ do |url|
  page.visit("#{dm_frontend_domain}#{url}")
end

Then /I am on the '(.*)' page$/ do |page_name|
  if page_name == 'Create supplier account'
    page.should have_content("#{page_name}")
    current_url.should end_with("#{dm_frontend_domain}/suppliers/create")
    page.should have_link('www.dnb.co.uk/dandb-duns-number')
    page.should have_link('beta.companieshouse.gov.uk/help/welcome')
    page.should have_link('Start')
  elsif page_name == 'Create a buyer account'
    current_url.should end_with("#{dm_frontend_domain}/buyers/create")
    page.should have_content("#{page_name}")
    page.should have_button('Create account')
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

Then /I am taken to the buyers '(.*)' page$/ do |page_name|
  store.framework = URI.parse(current_url).path.split('frameworks/').last.split('/').first
  case page_name
  when "Find an individual specialist"
    page.should have_link('View published requirements')
    page.should have_link('View supplier A to Z')
    page.should have_link('Find out how suppliers are evaluated')
    page.should have_link('How to talk to suppliers before you start')
    page.should have_link('how to buy')
    page.should have_button('Choose specialist role')
    store.lot = "digital-specialists"
    current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}")
  when "Find a team to provide an outcome"
    page.should have_link('View published requirements')
    page.should have_link('View supplier A to Z')
    page.should have_link('Find out how suppliers are evaluated')
    page.should have_link('How to talk to suppliers before you start')
    page.should have_link('how to buy')
    page.should have_button('Choose specialist role')
    store.lot = "digital-outcomes"
    current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}")
  when "Find user research participants"
    page.should have_link('View published requirements')
    page.should have_link('View supplier A to Z')
    page.should have_link('Find out how suppliers are evaluated')
    page.should have_link('How to talk to suppliers before you start')
    page.should have_link('how to buy')
    page.should have_button('Choose specialist role')
    store.lot = "user-research-participants"
    current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}")
  when "Find a user research lab"
    puts "page slow has not been defined/developed"
  else
    fail("The page \"#{page_name}\" does not exist")
  end

  page.should have_selector(:xpath, "//*[@id='global-breadcrumb']/nav/*[@role='breadcrumbs']/li[1]//*[contains(text(), 'Digital Marketplace')]")
end

Given /^I am on the "Overview of work" page for the buyer brief$/ do
  visit "#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}"
  current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}")
end

Then /^I should be on the "Overview of work" page for the buyer brief '(.*)'$/ do |brief_name|
  page.find('h1').should have_content("#{brief_name}")
  page.should have_selector(:xpath, ".//div[@class='marketplace-paragraph']/h2[contains(text(), 'Overview of work')]")
  parts = URI.parse(current_url).path.split('/')
  store.current_brief_id = (parts.select {|v| v =~ /^\d+$/}).last
  store.framework = URI.parse(current_url).path.split('frameworks/').last.split('/').first
  store.lot = URI.parse(current_url).path.split('requirements/').last.split('/').first
  current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}")
end

Given /^I am on the supplier response page for the brief$/ do
  brief_id = @published_brief['id']
  visit "#{dm_frontend_domain}/suppliers/opportunities/#{brief_id}/responses/create"
end

And /^I see correct brief title and requirements for the brief$/ do
  brief_title = @published_brief['title']
  brief_requirements = @published_brief['essentialRequirements'] + @published_brief['niceToHaveRequirements']

  page.find('h1').should have_content("#{brief_title}")
  brief_requirements.each_with_index do |brief_requirement, index|
    page.all('span.question-heading p')[index].should have_content("#{brief_requirement}")
  end
end

Then /^I choose '(.*)' for the '(.*)' requirements$/ do |value, requirements|
  @published_brief[requirements].each_with_index do |_, index|
    input_id = "#{requirements}-#{index}"
    step "I choose \'#{value}\' for \'#{input_id}\'"

Then /^Summary row '(.*)' '(.*)' contain '(.*)'$/ do |field_name, availability, field_value|
  case availability
  when "should"
    page.find(:xpath, "//td/span[contains(text(),'#{field_name}')]/../../td[@class='summary-item-field']/span").should have_content("#{field_value}")
  when "should not"
    page.find(:xpath, "//td/span[contains(text(),'#{field_name}')]/../../td[@class='summary-item-field']/span").should have_no_content("#{field_value}")
  else
    fail("Unrecognised value provided: '#{availability}'")
  end
end

Given /I click the '(.*)' link for '(.*)'$/ do |action, text_of_interest|
  all_headings = page.all(:css, "h2.summary-item-heading").select do |element|
    element.text() == text_of_interest
  end

  if all_headings.length >= 1
    top_level_action = all_headings.first.find(:xpath, "./following-sibling::p[1]/a")
    top_level_action.text().should == action
    top_level_action.click

  else
    all_item_text = page.all(:css, ".summary-item-field-first>span").select do |element|
      element.text() == text_of_interest
    end

    if current_url.include?('submissions') or action == 'Edit'
      top_level_action = all_item_text.first.find(:xpath, "./../../*[@class='summary-item-field-with-action']/span/a[contains(text(),'#{action}')]")
    elsif current_url.include?('requirements')
      top_level_action = all_item_text.first.find(:xpath, "./../../*[@class='summary-item-field']/span/a[contains(text(),'#{action}')]")
    end

    top_level_action.text().should == action
    top_level_action.click
  end
end

And /^The '(.*)' button is '(.*)' available$/ do |button_name, availability|
  case availability
  when "made"
    page.should have_button("#{button_name}")
  when "not"
    page.should have_no_button("#{button_name}")
  else
    fail("Unrecognised variable: '#{availability}'")
  end
end

Given /^A '(.*)' brief with the name '(.*)' exists and I am on the "Overview of work" page for that brief$/ do |brief_type, brief_name|
  steps %Q{
    Given I have a 'draft' brief
    And I am on the "Overview of work" page for the newly created draft brief
  }
end

Then /^The buyer brief '(.*)' '(.*)' listed on the buyer's dashboard$/ do |brief_name,availability|
  case availability
  when "is"
    page.should have_selector(:xpath, "//span/a[contains(@href, '/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}') and contains(text(), '#{brief_name}')]")
  when "is not"
    page.should have_no_selector(:xpath, "//span/a[contains(@href, '/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}') and contains(text(), '#{brief_name}')]")
  else
    fail("Unrecognised variable: '#{availability}'")
  end
end

When /^I edit '(.*)' by changing '(.*)' to '(.*)'$/ do |item_to_change,field_name,new_value|#Step implementation specific to buyer brief
  step "I navigate to the 'Edit' '#{item_to_change}' page"

  case item_to_change
  when "Specialist role", "Location"
    step "I choose '#{new_value}' for '#{field_name}'"
  else
    step "I change '#{field_name}' to '#{new_value}'"
  end

  steps %Q{
    And I click 'Save and continue'
    Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief-edited'
  }
end

When /^I edit '(.*)' by '(.*)' '(.*)' for '(.*)'$/ do |item_to_change,action,field_name,new_value|#Step implementation specific to buyer brief
  step "I navigate to the 'Edit' '#{item_to_change}' page"

  case action
  when "checking", "unchecking"
    step "I '#{action}' '#{new_value}' for '#{field_name}'"
  when "removing", "adding"
    if action == "removing"
      find(:xpath, ".//*[@id='#{field_name}']/../*[@class='button-secondary list-entry-remove']").click
    elsif action == "adding"
      step "I add '#{value}' as a '#{field_name}'"
    end
  else
    fail("Unrecognised action: '#{action}'")
end

  steps %Q{
    And I click 'Save and continue'
    Then I should be on the "Overview of work" page for the buyer brief 'Find an individual specialist brief-edited'
  }
end

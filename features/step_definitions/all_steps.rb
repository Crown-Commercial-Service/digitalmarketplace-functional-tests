require "ostruct"
require "rest_client"

store = OpenStruct.new

Given /^I have a fresh session$/ do
  if page.has_content?('Log out')
    find_link('Log out').click
  end
  Capybara.really_reset_sessions!
end

Given /^I am logged in as a '(.*)'$/ do |user|
  # log user out if still logged in
  visit("#{dm_domain}/login/auth")
  if page.has_content?('Log out')
    find_link('Log out').click
  end

  # make sure we have a new session
  Capybara.really_reset_sessions!
  visit("#{dm_domain}/login/auth")

  if user == 'administrator'
    fill_in('username', :with => ENV['DM_ADMINUSERNAME'])
    fill_in('password', :with => ENV['DM_ADMINPASSWORD'])
    username = ENV['DM_ADMINUSERNAME']
  elsif user == 'supplier'
    fill_in('username', :with => ENV['DM_SUPPLIERUSERNAME'])
    fill_in('password', :with => ENV['DM_SUPPLIERPASSWORD'])
    username = ENV['DM_SUPPLIERUSERNAME']
  elsif user == 'buyer'
    fill_in('username', :with => ENV['DM_BUYERUSERNAME'])
    fill_in('password', :with => ENV['DM_BUYERPASSWORD'])
    username = ENV['DM_BUYERUSERNAME']
  else
    raise "Type of user does not exist or has not been provided."
  end

  find_button('submit').click
  page.should have_content(username)
end

Given /^I am at '(.*)'$/ do |path|
  visit "#{ssp_domain}#{path}"
end

Given /^I am on page '(\d+)'$/ do |page_number|
  visit("#{ssp_domain}/page/#{page_number}/#{store.current_listing}")
end

Given /^I am on the summary page$/ do
  visit("#{ssp_domain}/service/#{store.current_listing}/summary")
end

Given /^I have a G6 service id from the API$/ do
  response = RestClient.get("#{dm_api_domain}/services?page=#{1 + rand(500)}",
    authorization: "Bearer #{dm_api_access_token}")
  @service_id = JSON.parse(response)['services'][rand(10)]['id']
  store.serviceID = @service_id
end

When /^I search for that service id$/ do
  visit "#{dm_domain}/search?keyword=#{@service_id}"
end

When /^I choose '(.*)'$/ do |label|
  choose label
end

When /^I check '(.*)'$/ do |label|
  check label
end

When /^I select '(.*)' from '(.*)'$/ do |option, selector|
  select(option, from: selector)
end

When /^I click '(.*)'$/ do |label|
  find_button(label).click
end

When /^I click the Suppliers button$/ do
  find(
    :xpath,
    ".//*[@id='wrapper']/main/div[2]/a[1]"
  ).click
end

When /^I fill in '(.*)' with '(.*)'$/ do |label, value|
  if label == 'Company Name'
    fill_in(label, :with => value+rand(100000000..999999999).to_s)
  else
    fill_in(label, :with => value)
  end
end

When /^I fill in '(.*)' with:$/ do |label, value|
  fill_in(label, :with => value)
end

When /^I choose file '(.*)' for '(.*)'$/ do |file, label|
  attach_file(label, File.join(Dir.pwd, 'fixtures', file))
end

When /^I continue with my service$/ do
  # Find 'continue' link with the current listing in the href
  find(:xpath, "//a[contains(@href, '/#{store.current_listing}') and contains(text(), 'Continue')]").click
end

Then /^I should be on the '(.*)' page$/ do |title|
  find('h1').should have_content(/#{title}/i)
  parts = URI.parse(current_url).path.split('/')
  while not /^\d+$/.match(parts.last)
    parts.pop
  end
  store.current_listing = parts.pop
end

Then /^I should be on the listing page$/ do
  URI.parse(current_url).path.should == "/"
end

Then /^My service should be in the list$/ do
  page.should have_selector(:xpath, "//a[@href='/service/#{store.current_listing}/summary']")
end

Then /^My service should not be in the list$/ do
  page.should have_no_selector(:xpath, "//a[@href='/service/#{store.current_listing}/summary']")
end

Then /^My service should not have a 'Continue' link$/ do
  # the href points to my listing and the link text contains 'Continue'
  page.should have_no_selector(:xpath, "//a[contains(@href, '#{store.current_listing}') and contains(text(), 'Continue')]")
end

Then /^The string '(.*)' should not be on the page$/ do |string|
  page.should have_no_content(string)
end

Then /^The string '(.*)' should be on the page$/ do |string|
  page.should have_content(string)
end

Then /^The input labelled '(.*)' should be checked$/ do |label|
  page.should have_selector(:xpath, "//label[text()[contains(.,'#{label}')]]/input[contains(@checked, 'checked')]")
end

Then /^Page (\d+) question (\d+) should contain '(.*)'$/ do |page, question, text|
  find(
    :xpath,
    "//h2[@id='page#{page}']/following-sibling::*[2]/tbody/tr[#{question}]"
  ).should have_content(text)
end

Then /^My service should have a 'Return service to drafts' button$/ do
  find(
    :xpath,
    "//tr[.//a[@href='/service/#{store.current_listing}/summary']]"
  ).should have_button('Return service to drafts')
end

Then /^My service should not have a 'Return service to drafts' button$/ do
  page.should have_no_selector(:xpath, "//tr[.//a[@href='/service/#{store.current_listing}/summary']]//button[contains(text(),'Return service to drafts')]")
end

Then /^I click 'Return service to drafts' for my service$/ do
  find(
    :xpath,
    "//tr[.//a[@href='/service/#{store.current_listing}/summary']]//button[contains(text(),'Return service to drafts')]"
  ).click
end

Then /^I get a summary error of '(.*)' and an inline error of '(.*)' for question '(.*)'$/ do |summary_error, inline_error, question|
  find(
    :xpath,
    "//div[@class='validation-masthead']//a[@href='\##{question}']"
  ).should have_content(/#{Regexp.escape(summary_error)}/i)

  find(
    :xpath,
    "//*[@id='#{question}']//p[@class='validation-message']"
  ).should have_content(/#{Regexp.escape(inline_error)}/i)
end

Then /^I get a summary error of '(.*)' and an inline error of '(.*)'$/ do |summary_error, inline_error|
find(
  :xpath,
  "//*[@id='emailSummary']//a[@href='#email']"
).should have_content(/#{Regexp.escape(summary_error)}/i)

find(
  :xpath,
  "//*[@id='supplier']/div/label[2]"
).should have_content(/#{Regexp.escape(inline_error)}/i)
end

When /^I go to the G-Cloud 6 submissions service$/ do
  visit "#{ssp_domain}"
end

Then /^I should be on the G-Cloud 6 submissions page as the supplier$/ do
  page.should have_content('Your G-Cloud 6 submissions')
  page.should have_content(ENV['DM_SUPPLIERUSERNAME'])
end

Given /^That I am an anonymous user$/ do
end

Then /^I should be on the G-Cloud 6 service submission portal \(SSP\) page$/ do
  page.should have_content('G-Cloud 6 service submission portal (SSP)')
end

And /^I see a link to '(.*)'$/ do |link_name|
  page.should have_link(link_name)
end

Then /^I should be on the Log in to the Digital Marketplace page$/ do
  page.should have_content('Log in to the Digital Marketplace')
end

When /^I fill in supplier username and password$/ do
  fill_in('username', :with => ENV['DM_SUPPLIERUSERNAME'])
  fill_in('password', :with => ENV['DM_SUPPLIERPASSWORD'])
end

Given /^Supplier user accounts do not exist for '(.*)':$/ do |supplier_name, table|
  visit "#{dm_domain}/login/auth"
  if page.has_content?('Log out')
    find_link('Log out').click
    visit "#{dm_domain}/login/auth"
  end
  fill_in('username', :with => ENV['DM_ADMINUSERNAME'])
  fill_in('password', :with => ENV['DM_ADMINPASSWORD'])
  find_button('submit').click
  visit "#{dm_domain}/admin"
  page.should have_link('Users')
  find_link('Users').click
  fill_in('keyword', :with => supplier_name)
  find_button('Search').click
  page.should have_table('')

  table.hashes.each do |row|
    email = row['Email']
    if page.has_content?(email)
      find(:xpath, "//tr[td//text()[contains(.,'#{email}')]]//a").click
      find_button('Delete account').click
      find_link('Delete account').click
      page.should have_content("\(#{email}\) deleted")
    end
  end
end

And /^Buyer user account exists$/ do
  if page.has_content?('Log out')
    find_link('Log out').click
  end

  #Check if buyer user exists, if not create it
  visit "#{dm_domain}/login/auth"
  fill_in('username', :with => ENV['DM_BUYERUSERNAME'])
  fill_in('password', :with => ENV['DM_BUYERPASSWORD'])
  find_button('submit').click

  if page.has_content?('Sorry, we couldn\'t find a user with that username and password')
    visit "#{dm_domain}/register"
    fill_in('firstName', :with => 'Smoke Test')
    fill_in('lastName', :with => 'Buyer Add As Supplier')
    fill_in('email', :with => ENV['DM_BUYERUSERNAME'])
    fill_in('password', :with => ENV['DM_BUYERPASSWORD'])
    fill_in('password2', :with => ENV['DM_BUYERPASSWORD'])
    check 'tAndC'
    find_button('Create an account').click
    page.has_content?(ENV['DM_BUYERUSERNAME'])
  end
end

Given /^I am on the marketplace '(.*)' page$/ do |path|
    visit "#{dm_domain}#{path}"
end

Given /^I am on the DSS '(.*)' page$/ do |path|
    visit "#{dss_domain}#{path}"
end

When /^I click '(.*)' link$/ do |label|
  find_link(label).click
end

When /^I click '(.*)' button$/ do |label|
 find(
    :xpath,
    "//a[contains(@class, 'button button-get-started') and contains(text(), '#{label}')]"
  ).click
end

When /^I click '(.*)' filter$/ do |label|
 find(:css, "#filter_capability_37[value='37']").set(true) 
end

When /^I click '(.*)' on the form$/ do |label|
find(
   :xpath,
   "//form[@id='save-search-form']//button[contains(text(), 'Save')]"
   ).click
end

When /^I click '(.*)' link to delete a saved search$/ do |label|
find(
   :xpath,
   "//table/tbody/tr[2]/td[4]//a[@title='Delete Search']"
   ).click
end

Then /^I am on the '(.*)' page$/ do |pagename|
  page.should have_content("#{pagename}")
end

Then /^I am on the '(.*)' page as '(.*)'$/ do |pagename,email|
  page.should have_content("#{pagename}")
  page.should have_content("#{email}")
end

Then /^I should see the following user account creation confirmation '(.*)'$/ do |confirmation|
  page.should have_content("#{confirmation}")
end

Then /^I remain logged in$/ do
  page.has_content?('Log out')
end

Then /^I should be logged out of marketplace$/ do
  page.should have_content('Log in')
end

Then /^I am logged in to the DSS$/ do
  find(
    :xpath,
    "//ul[@id='proposition-links']"
  ).should have_content('My account','Saved searches','Log out')
end

Then /^I should be logged out of DSS$/ do
  page.should have_content('You are now signed out')
  page.should have_content('Log in')
end

When /I click the View and edit supplier information link$/ do
  find(
    :xpath,
    "//div[@class='dashboard supplier']//a[@href='/supplier/edit-supplier-account']"
  ).click
end

When /I see the link to change '(.*)'$/ do |label|
  find(
    :xpath,
    "//a[contains(@class, 'summary-change-link') and contains(@href, '#{label}')]"
  )
end

When /I click the change link for '(.*)'$/ do |label|
  find(
    :xpath,
    "//h2[contains(@class, 'summary-item-heading') and contains (text(), '#{label}')]/following-sibling::*[1]/a"
  ).click
end

Then /I should be at the '(.*)' page$/ do |label|
  find('h1').should have_content("#{label}")
end

And /I fill in '(.*)' with a unique 9 digit number$/ do |label|
  fill_in(label, :with => rand(100000000..999999999))
end

When /I select the first result on the page$/ do
  servicetitle = find(
    :xpath,
    "//*[@id='products-list']/li[1]/div/div/h3/a"
    ).text()

    store.servicetitle = servicetitle

  find(
    :xpath,
    "//*[@id='products-list']/li[1]/div/div/h3/a"
    ).click

  serviceID = find(
    :xpath,
    ".//*[@id='product_addtocart_form']/div[2]/div[3]"
  ).text().split('Service ID: ').last

  store.serviceID = serviceID
end

Then /The service listing page for the selected service is presented$/ do
  current_url.should have_content(store.serviceID.downcase)
  page.should have_content(store.servicetitle)
  page.should have_content(store.serviceID)
end

When /I fill in '(.*)' with the service id of a listing$/ do |label|
  find(
    :xpath,
    "//div[@id='box-results']/div[2]/h1/a"
  ).click

  serviceID = current_url.split('service/').last

  if serviceID.include?('-')
    serviceID = find(
      "p.serviceID"
      ) [:"data-metric-value"]
    else
      serviceID = find(
      "dd.service-id-id"
      ) [:"data-metric-value"]
      store.serviceID = serviceID
    end

  store.serviceID = serviceID
  # find(
  #   :xpath,
  #   "//div[@id='box-results']//div[@class='result'][1]//h1/a"
  # )[:href].split('/').last.gsub('-','.')

  visit "#{dm_domain}/search?keyword=smoke"

  fill_in(label, :with => store.serviceID)
end

Then /The results page is presented with the listing searched for by service id$/ do
  if store.serviceID.include?('.')
    serviceID = find(
      "p.serviceID"
    ) [:"data-metric-value"]
    current_url.should end_with(store.serviceID.gsub('.','-').downcase)
    page.should have_content('Service listing')
    page.should have_content(store.serviceID)
    page.should have_content('Service details')
    page.should have_content('Contact supplier')
  else
    serviceID = find(
      "dd.service-id-id"
    ) [:"data-metric-value"]
    store.serviceID = serviceID
    current_url.should end_with(store.serviceID)
    page.should have_content('Service ID')
    page.should have_content(store.serviceID)
    page.should have_content('Features')
    page.should have_content('Benefits')
  end
end

Then /The results page is presented with the G6 listing searched for by service id$/ do
  current_url.should end_with(store.serviceID.to_s.gsub('.','-').downcase)
  page.should have_content(store.serviceID)
  page.should have_content('Service definition')
end

When /I click the link for the first result on the page$/ do
  find(
    :xpath,
    "//div[@id='box-results']/div[2]/h1/a"
  ).click
end

Then /The service listing page for the selected result is presented$/ do
  store.serviceID = current_url.split('service/').last

  if store.serviceID.include?('-')
    serviceID = find(
      "p.serviceID"
    ) [:"data-metric-value"]
    current_url.should end_with(store.serviceID)
    page.should have_content('Service listing')
    page.should have_content(store.serviceID.gsub('-','.').upcase)
    page.should have_content('Service details')
    page.should have_content('Contact supplier')
  else
    serviceID = find(
      "dd.service-id-id"
    ) [:"data-metric-value"]
    store.serviceID = serviceID
    current_url.should end_with(store.serviceID)
    page.should have_content('Service ID')
    page.should have_content(store.serviceID)
    page.should have_content('Features')
    page.should have_content('Benefits')
  end
end

Then /I should be on the results page for the searched term '(.*)'$/ do |string|
  page.should have_content("results for #{string}")
end

Then /I should get (.*) search results?$/ do |count|
  find("p.count em").text.to_i.should eq(count.to_i)
end

Then /The search is saved$/ do
  page.should have_content('Search saved')
  page.should have_content('Manage your saved searches')
end

And /The saved search '(.*)' is listed on the page$/ do |string|
  page.should have_content('Saved searches')
  page.should have_content(string)
end

Then /I should be on the results page for the SaaS lot subcategory '(.*)'$/ do |string|
  page.should have_content('results')
  page.should have_content(string)
  page.should have_content('SaaS')
end

Then /I should be presented with the available servies for the supplier '(.*)'$/ do |string|
  page.should have_content('services')
  page.should have_content(string)
end

Then /I should see the following invitation confirmation '(.*)'$/ do |string|
  page.should have_content(string)
end

Then /I should see the following confirmation message '(.*)'$/ do |message|
  page.should have_content(message)
end

Then /Results for the applied filter '(.*)' are returned$/ do |filter_value|
  page.should have_content(filter_value)
  page.should have_content('Currently Filtered by:')
  page.should have_content(' suppliers offering Embedding Agile')
end

When /I see the service '(.*)'$/ do |service_name|
  page.should have_content(service_name)
  store.serviceID = find(
    :xpath,
    ".//*[@id='wrapper']/main/div[2]/dl/div[3]/dd"
  ).text().split(' · ').first
end

Then /I see an option to '(.*)' the service$/ do |service_action|
  find(
    :xpath,
    ".//*[@id='wrapper']/main/div[2]/dl/div[3]/dd"
  ).text().should have_content("#{service_action}")
end

Then /There is a link to the service '(.*)'$/ do |link_name|
  page.should have_link(link_name)
end

When /I click '(.*)' link for the specific service$/ do |service_action|
  find(
    :xpath,
    ".//*[@id='wrapper']/main/div[2]/dl/div[3]/dd/a"
  ).click
end

Then /The service is '(.*)'$/ do |service_action_state|
  if service_action_state == 'Deactivated'
    page.should have_no_selector(:xpath, ".//dt[.//*[@id='2']]")
  else
    page.should have_selector(:xpath, ".//dt[.//*[@id='2']]")
  end
end

When /I search for the '(.*)' service by service id$/ do |service_action|
  store.serviceID = store.serviceID.split(' · ').first
  visit "#{dm_domain}/search?keyword=#{store.serviceID}"
end

Then /The service '(.*)' returned in the search results$/ do |value|
  if value == 'is not'
    page.should have_no_content(store.serviceID)
    page.should have_content('There are no services matching the searched terms')
  else
    page.should have_content('1 result for ' "#{store.serviceID}")
  end
end

Then /The following message is presented to the user '(.*)'$/ do |message|
  page.should have_content(message)
end

When /I navigate directly to the service listing page$/ do
  visit "#{dm_domain}/service/#{store.serviceID.gsub('.','-').downcase}"
end

Then /I should see an error page with the message '(.*)'$/ do |not_found_message|
  page.should have_content(not_found_message)
end

Then /The service listing page for the specific service is presented$/ do
  current_url.should have_content(store.serviceID.gsub('.','-').downcase)
  page.should have_content(store.serviceID.upcase)
end

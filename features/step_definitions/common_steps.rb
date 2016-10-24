require 'uri'
require 'securerandom'

Given /^I am on the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  page.should have_content("Digital Marketplace")
end

Given /^I am on the (.* )?(\/.*) page$/ do |app, url|
  # If the app is set, then send the request using rest-client instead of capybara
  # and store the result in @response. Otherwise, poltergeist/phantomjs try to wrap
  # the response JSON in HTML.
  if app
    domain = domain_for_app(app.strip)
    @response = call_api(:get, url, domain: domain)
  else
    page.visit("#{dm_frontend_domain}#{url}")
    page.should have_content("Digital Marketplace")
  end
end

Given /^I have a random g-cloud service from the API$/ do
  frameworks = call_api(:get, "/frameworks")
  live_g_cloud = JSON.parse(frameworks.body)["frameworks"].select {|framework|
    framework["framework"] == "g-cloud" && framework["status"] == "live"
  }.map {|framework| framework["slug"]}.join(",")

  puts "Live g-cloud frameworks: #{live_g_cloud}"

  params = {status: "published", framework: live_g_cloud}
  page_one = call_api(:get, "/services", params: params)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url then
                    1 + rand(CGI.parse(URI.parse(last_page_url).query)['page'][0].to_i)
                  else
                    1
                  end
  random_page = call_api(:get, "/services", params: params)
  services = JSON.parse(random_page.body)['services']
  @service = services[rand(services.length)]
  puts "Service ID: #{@service['id']}"
  puts "Service name: #{@service['serviceName']}"
end

# TODO merge with above step
Given /^I have a random (?:([a-z-]+) )?supplier from the API$/ do |metaframework_slug|
  params = {}
  if metaframework_slug
    params['framework'] = metaframework_slug
  end
  page_one = call_api(:get, "/suppliers", params: params)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url then
                    1 + rand(CGI.parse(URI.parse(last_page_url).query)['page'][0].to_i)
                  else
                    1
                  end
  random_page = call_api(:get, "/suppliers", params: params)
  suppliers = JSON.parse(random_page.body)['suppliers']
  @supplier = suppliers[rand(suppliers.length)]
  puts "Supplier ID: #{@supplier['id']}"
  puts "Supplier name: #{@supplier['name']}"
end

# TODO merge with above step
Given /^I have a random dos brief from the API$/ do
  params = {status: "live,closed", framework: "digital-outcomes-and-specialists"}
  page_one = call_api(:get, "/briefs", params: params)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url then
                    1 + rand(CGI.parse(URI.parse(last_page_url).query)['page'][0].to_i)
                  else
                    1
                  end
  random_page = call_api(:get, "/briefs?with_users=true", params: params)
  briefs = JSON.parse(random_page.body)['briefs']
  @brief = briefs[rand(briefs.length)]

  # furnish the brief with the cosmetic status label used by the frontend
  @brief['statusLabel'] = {
    "live" => "Open",
    "closed" => "Closed",
  }[@brief['status']]

  puts "Brief ID: #{@brief['id']}"
  puts "Brief name: #{@brief['title']}"
end

When /I click #{MAYBE_VAR} ?(button|link)?$/ do |button_link_name, elem_type|
  if elem_type == 'button'
    page.click_button(button_link_name)
  elsif elem_type == 'link'
    page.click_link(button_link_name)
  else
    page.click_link_or_button(button_link_name)
  end
end

When /I check #{MAYBE_VAR} checkbox$/ do |checkbox_label|
  page.check(checkbox_label)
end

When /I check a random '(.*)' checkbox$/ do |checkbox_name|
  checkboxes = all(:xpath, "//input[@type='checkbox'][@name='#{checkbox_name}']")
  checkbox = checkboxes[rand(checkboxes.length)]
  page.check(checkbox[:id])
  puts "Checkbox value: #{checkbox.value}"
end

When /I check all '(.*)' checkboxes$/ do |checkbox_name|
  all(:xpath, "//input[@type='checkbox'][@name='#{checkbox_name}']").each do |element| page.check(element[:id]) end
end

When /^I enter a random value in the '(.*)' field( and click its associated '(.*)' button)?$/ do |field_name, maybe_click_statement, click_button_name|
  @fields||= {}
  @fields[field_name] = SecureRandom.hex
  puts "#{field_name}: #{@fields[field_name]}"
  step "I enter '#{@fields[field_name]}' in the '#{field_name}' field#{maybe_click_statement}"
end

When /^I enter #{MAYBE_VAR} in the '(.*)' field( and click its associated '(.*)' button)?$/ do |value, field_name, maybe_click_statement, click_button_name|
  field_element = page.find_field field_name
  field_element.set value
  if maybe_click_statement
    form_element = field_element.find(:xpath, "ancestor::form")
    form_element.click_button(click_button_name)
  end
end

When(/^I choose a random uppercase letter$/) do
  letters = ('A'..'Z').to_a
  @letter = letters[rand(letters.length)]
  puts "letter: #{@letter}"
end

Then /^I see the '(.*)' breadcrumb$/ do |breadcrumb_text|
  breadcrumb = page.all(:xpath, "//div[@id='global-breadcrumb']/nav//li").last
  breadcrumb.text().should == breadcrumb_text
end

Then /^I see the '(.*)' link$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I am on #{MAYBE_VAR} page$/ do |page_name|
  find('h1').text.should == normalize_whitespace(page_name)
end

Then /^I see #{MAYBE_VAR} in the page's h1$/ do |page_name_fragment|
  find('h1').text.should include(normalize_whitespace(page_name_fragment))
end

Then(/^I see the page's h1 ends in #{MAYBE_VAR}$/) do |term|
  find('h1').text.should end_with term
end

Then /I see #{MAYBE_VAR} as the value of the '(.*)' field$/ do |value, field|
  if page.has_field?(field, {type: 'radio'}) or page.has_field?(field, {type: 'checkbox'})
    page.find_field(field, {checked: true}).value.should == value
  else
    page.find_field(field).value.should == value
  end
end

Then /I see #{MAYBE_VAR} as the value of the '(.*)' JSON field$/ do |value, field|
  json = JSON.parse(@response)
  json.should include(field)
  json[field].should eq(value)
end

Then /Display the value of the '(.*)' JSON field as '(.*)'$/ do |field, name|
  json = JSON.parse(@response)
  json.should include(field)
  puts "#{name}: #{json[field]}"
end

Then(/^I see #{MAYBE_VAR} as the page header context$/) do |value|
  first(:xpath, "//header//*[@class='context']").text.should  == normalize_whitespace(value)
end

require 'uri'
require 'securerandom'

Given /^I am on the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  page.should have_content("Digital Marketplace")
end

Given /^I am on the (\/.*) page$/ do |url|
  page.visit("#{dm_frontend_domain}#{url}")
  page.should have_content("Digital Marketplace")
end

Given /^I have a random g-cloud service from the API$/ do
  params = {status: "published", framework: "g-cloud-6,g-cloud7"}
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
Given /^I have a random g-cloud supplier from the API$/ do
  params = {framework: "g-cloud"}
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
  random_page = call_api(:get, "/briefs", params: params)
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

When /I click (?:the )?'(.*)' ?(button|link)?$/ do |button_link_name, elem_type|
  if elem_type == 'button'
    page.click_button(button_link_name)
  elsif elem_type == 'link'
    page.click_link(button_link_name)
  else
    page.click_link_or_button(button_link_name)
  end
end

When /I click that (\w+)(?:\.(\w+))? ?(button|link)?$/ do |variable_name, attr_name, elem_type|
  var = instance_variable_get("@#{variable_name}")
  step "I click '#{if attr_name then var.fetch(attr_name) else var end}' #{elem_type}"
end

When /I check (?:the )?'(.*)' checkbox$/ do |checkbox_label|
  page.check(checkbox_label)
end

When /I check that (\w+)\.(\w+) checkbox$/ do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  step "I check '#{var.fetch(attr_name)}' checkbox"
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

When /^I enter that (\w+)\.(\w+) in the '(.*)' field$/ do |variable_name, attr_name, field_name|
  var = instance_variable_get("@#{variable_name}")
  step "I enter '#{var.fetch(attr_name)}' in the '#{field_name}' field"
end

When /^I enter a random value in the '(.*)' field$/ do |field_name|
  @fields||= {}
  @fields[field_name] = SecureRandom.hex
  puts "#{field_name}: #{@fields[field_name]}"
  step "I enter '#{@fields[field_name]}' in the '#{field_name}' field"
end

When /^I enter '(.*)' in the '(.*)' field$/ do |value,field_name|
  page.fill_in(field_name, with: value)
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

Then /^I am on that (.*)\.(.*) page$/ do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  step "I am on the '#{var.fetch(attr_name)}' page"
end

Then /^I am on the '(.*)' page$/ do |page_name|
  find('h1').text.should == normalize_whitespace(page_name)
end

Then(/^I see the page's h1 ends in that (\w+)(?:\.(\w+))?$/) do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  find('h1').text.should end_with (if attr_name then var.fetch(attr_name) else var end)
end

Then /I see '(.*)' as the value of the '(.*)' field$/ do |value, field|
  if page.has_field?(field, {type: 'radio'}) or page.has_field?(field, {type: 'checkbox'})
    page.find_field(field, {checked: true}).value.should == value
  else
    page.find_field(field).value.should == value
  end
end

Then (/^I see that (\w+)\.(\w+) as the value of the '(.*)' field$/) do |variable_name, attr_name, field|
  var = instance_variable_get("@#{variable_name}")
  step "I see '#{var.fetch(attr_name)}' as the value of the '#{field}' field"
end

Then(/^I see that (\w+)\.(\w+) as the page's h1$/) do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  step "I am on the '#{normalize_whitespace var.fetch(attr_name)}' page"
end

Then(/^I see '(.*)' in the search summary text$/) do |value|
  find(:xpath, "//*[@class='search-summary']/em[1]").text().should == normalize_whitespace(value)
end

Then(/^I see that (\w+)\.(\w+) in the search summary text$/) do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  step "I see '#{var.fetch(attr_name)}' in the search summary text"
end

Then(/^I see '(.*)' as the page header context$/) do |value|
  first(:xpath, "//header//*[@class='context']").text.should  == normalize_whitespace(value)
end

Then(/^I see that (\w+)\.(\w+) as the page header context$/) do |variable_name, attr_name|
  var = instance_variable_get("@#{variable_name}")
  step "I see '#{var.fetch(attr_name)}' as the page header context"
end

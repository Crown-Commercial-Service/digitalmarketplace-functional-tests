require 'date'
require 'securerandom'
require 'uri'

Given /^I am on the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  expect(page).to have_content("Digital Marketplace")
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
    expect(page).to have_content("Digital Marketplace")
  end
end

Given /^I have a live (.*) framework(?: with the (.*) lot)?$/ do |metaframework_slug, lot_slug|
  response = call_api(:get, "/frameworks")
  expect(response.code).to eq(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if { |framework| framework['framework'] != metaframework_slug || framework['status'] != 'live' }
  if lot_slug
    frameworks.delete_if { |framework| framework['lots'].select { |lot| lot["slug"] == lot_slug }.to_a.empty? }
  end
  expect(frameworks).not_to be_empty, _error(response, "No live '#{metaframework_slug}' frameworks found with lot '#{lot_slug}'")
  @framework = frameworks[0]
  puts @framework['slug']
end

Given /^I have a random g-cloud service from the API$/ do
  frameworks = call_api(:get, "/frameworks")
  live_g_cloud_slugs = JSON.parse(frameworks.body)["frameworks"].select { |framework|
    framework["framework"] == "g-cloud" && framework["status"] == "live"
  }.map { |framework| framework["slug"] }
  # reverse sort by whatever is after the final "-" in the framework slug
  latest_g_cloud_slug = live_g_cloud_slugs.sort_by { |slug| slug.split('-')[-1] }.reverse[0]
  puts "Latest live g-cloud framework slug: #{latest_g_cloud_slug}"

  params = { status: "published", framework: latest_g_cloud_slug }
  page_one = call_api(:get, "/services", params: params)
  expect(page_one.code).to eq(200)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url
                    1 + rand(CGI.parse(URI.parse(last_page_url).query)['page'][0].to_i)
                  else
                    1
                  end
  random_page = call_api(:get, "/services", params: params)
  expect(random_page.code).to eq(200)
  services = JSON.parse(random_page.body)['services']
  @service = services[rand(services.length)]
  puts "Service ID: #{@service['id']}"
  puts "Service name: #{ERB::Util.h @service['serviceName']}"
end

Given /^I have a random g-cloud lot from the API$/ do
  frameworks = call_api(:get, "/frameworks")
  live_g_cloud_frameworks = JSON.parse(frameworks.body)["frameworks"].select { |framework|
    framework["framework"] == "g-cloud" && framework["status"] == "live"
  }
  # reverse sort by whatever is after the final "-" in the framework slug
  g_cloud_lot = live_g_cloud_frameworks.sort_by { |framework| framework["slug"].split('-')[-1] }.reverse[0]["lots"].sample
  puts "G-Cloud lot: #{g_cloud_lot['name']}"
  @lot = g_cloud_lot
end

# TODO merge with above step
Given /^I have a random (?:([a-z-]+) )?supplier from the API$/ do |metaframework_slug|
  params = {}
  if metaframework_slug
    params['framework'] = metaframework_slug
  end
  page_one = call_api(:get, "/suppliers", params: params)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url
                    1 + rand(CGI.parse(URI.parse(last_page_url).query)['page'][0].to_i)
                  else
                    1
                  end
  random_page = call_api(:get, "/suppliers", params: params)
  # Remove suppliers without a DUNS number - these are old imported accounts
  # and it's easier to skip them than to handle the empty DUNS search case
  suppliers = JSON.parse(random_page.body)['suppliers'].select { |supplier|
    supplier['dunsNumber']
  }
  @supplier = suppliers[rand(suppliers.length)]
  puts "Supplier ID: #{@supplier['id']}"
  puts "Supplier name: #{ERB::Util.h @supplier['name']}"
end

# TODO merge with above step
Given /^I have a random dos brief from the API$/ do
  params = { status: "live,closed", framework: "digital-outcomes-and-specialists-2" }
  page_one = call_api(:get, "/briefs", params: params)
  last_page_url = JSON.parse(page_one.body)['links']['last']
  params[:page] = if last_page_url
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
  puts "Brief name: #{ERB::Util.h @brief['title']}"
end

When /I click #{MAYBE_VAR} ?(button|link)?$/ do |button_link_name, elem_type|
  if elem_type == 'button'
    page.all(:xpath, "//input[@value='#{button_link_name}'] | //input[@name='#{button_link_name}'] | //button[text()='#{button_link_name}']")[0].click
  elsif elem_type == 'link'
    page.click_link(button_link_name)
  else
    page.click_link_or_button(button_link_name)
  end
end

When /I click a link with text #{MAYBE_VAR}$/ do |link_text|
  found_links = page.all(:xpath, "//a[normalize-space(string())=normalize-space(#{escape_xpath(link_text)})]")
  if found_links.length > 1
    puts "Warning: #{found_links.length} '#{link_text}' links found"
  end
  found_links[0].click
end

When /I click the (Next|Previous) Page link$/ do |next_or_previous|
  # can't use above as we have services with the word 'next' in the name :(
  klass = ''
  if next_or_previous == 'Next'
    klass = '.next'
  elsif next_or_previous == 'Previous'
    klass = '.previous'
  end
  page.find(:css, "#{klass} :link").click
end

When /I (un)?check #{MAYBE_VAR} checkbox$/ do |maybe_un, checkbox_label|
  if maybe_un
    uncheck_checkbox(checkbox_label)
  else
    check_checkbox(checkbox_label)
  end
end

When /I choose #{MAYBE_VAR} radio button(?: for the '(.*)' question)?$/ do |radio_label, question|
  if question
    within(:xpath, "//span[normalize-space(text())='#{question}']/../..") do
      choose_radio(radio_label)
    end
  else
    choose_radio(radio_label)
  end
end

When /I check a random '(.*)' checkbox$/ do |checkbox_name|
  checkbox = all_fields(checkbox_name, type: 'checkbox').sample
  check_checkbox(checkbox)
end

When /I choose a random '(.*)' radio button$/ do |name|

  radio = all_fields(name, type: 'radio').sample
  choose_radio(radio)
end

When /I check all '(.*)' checkboxes$/ do |checkbox_name|
  all_fields(checkbox_name, type: 'checkbox').each do |checkbox|
    check_checkbox(checkbox)
  end
end

Then /I don't see a '(.*)' checkbox$/ do |checkbox_name|
  expect(all_fields(checkbox_name, type: 'checkbox').length).to eq(0)
end

Then /I don't see any '(.*)' checkboxes$/ do |checkbox_fieldname|
  expect(page).to have_selector(:xpath, "//input[@type='checkbox'][@name='#{checkbox_fieldname}']", count: 0)
end

When /^I enter a random value in the '(.*)' field( and click its associated '(.*)' button)?$/ do |field_name, maybe_click_statement, click_button_name|
  @fields ||= {}
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
  @letter = ('A'..'Z').to_a.sample
  puts "letter: #{@letter}"
end

# the rescue is used because if a banner cannot be found the function throws an exception and does not look for the other option
Then /^I see a (success|warning|destructive|temporary-message) banner message containing '(.*)'$/ do |status, message|
  begin
    banner_message = page.find(:css, ".banner-#{status}-without-action")
  rescue
    banner_message = page.find(:css, ".banner-#{status}-with-action")
  end
  expect(banner_message).to have_content(message)
end

Then /^I don't see a banner message$/ do
  expect(page).not_to have_selector(:xpath, "//*[contains(@class, 'banner-')][contains(@class, '-action')]")
end

Then /^I see a validation message containing '(.*)'$/ do |message|
  validation_message = page.find(:css, ".validation-message")
  expect(validation_message).to have_content(message)
end

Then /^I see #{MAYBE_VAR} breadcrumb$/ do |breadcrumb_text|
  breadcrumb = page.all(:xpath, "//div[@id='global-breadcrumb']/nav//li").last
  expect(breadcrumb.text).to eq(breadcrumb_text)
end

Then /^I (don't |)see the '(.*)' (button|link)$/ do |negative, selector_text, selector_type|
  expect(page).to have_selector(:link_or_button, selector_text) if negative.empty?
  expect(page).not_to have_selector(:link_or_button, selector_text) unless negative.empty?
end

Then /^I see the '(.*)' link with href '(.*)'$/ do |selector_text, href|
  find(:xpath, "//a[substring(@href, string-length(@href) - (string-length('#{href}')) + 1) = '#{href}'][normalize-space(text()) = '#{selector_text}']")
end

Then /^I am on #{MAYBE_VAR} page$/ do |page_name|
  expect(page).to have_selector('h1', text: normalize_whitespace(page_name))
end

Then /^I see #{MAYBE_VAR} in the page's (.*)$/ do |page_name_fragment, selector|
  expect(find(selector).text).to include(normalize_whitespace(page_name_fragment))
end

Then(/^I see the page's h1 ends in #{MAYBE_VAR}$/) do |term|
  expect(find('h1').text).to end_with(term)
end

Then /I see #{MAYBE_VAR} as the value of the '(.*)' field$/ do |value, field|
  if page.has_field?(field, type: 'radio', visible: :all) || page.has_field?(field, type: 'checkbox', visible: :all)
    expect(first_field(field, checked: true).value).to eq(value)
  else
    expect(first_field(field).value).to eq(value)
  end
end

Then /^I do not see the '(.*)' field$/ do |field_name|
  expect(page).not_to have_field(field_name)
end

Then /I see #{MAYBE_VAR} as the value of the '(.*)' JSON field$/ do |value, field|
  json = JSON.parse(@response)
  expect(json).to include(field)
  expect(json[field]).to eq(value)
end

Then /Display the value of the '(.*)' JSON field as '(.*)'$/ do |field, name|
  json = JSON.parse(@response)
  expect(json).to include(field)
  puts "#{name}: #{json[field]}"
end

Then(/^I see #{MAYBE_VAR} as the page header context$/) do |value|
  expect(first(:xpath, "//header//*[@class='context']").text).to eq(normalize_whitespace(value))
end

When /^I choose file '(.*)' for the field '(.*)'$/ do |file, label|
  attach_file(label, File.join(Dir.pwd, 'fixtures', file))
end

When /^I click the top\-level summary table '(.*)' link for the section '(.*)'$/ do |link_name, field_to_edit|
  edit_link = page.find(:xpath, "//h2[contains(text(), '#{field_to_edit}')]/following-sibling::p[1]/a[text()]")
  expect(edit_link.text).to have_content(link_name)
  edit_link.click
end

When /I click the summary table '(.*)' (link|button) for '(.*)'$/ do |link_name, elem_type, field_to_edit|
  case elem_type
    when 'link'
      edit_link = page.find(:xpath, "//tr/*/span[normalize-space(text()) = '#{field_to_edit}']/../..//a[contains(normalize-space(text()), '#{link_name}')]")
    else
      edit_link = page.find(:xpath, "//tr/*/span[normalize-space(text()) = '#{field_to_edit}']/../..//input[normalize-space(@value) = '#{link_name}']")
  end
  edit_link.click
end

When /I update the value of '(.*)' to '(.*)' using the summary table '(.*)' link(?: and the '(.*)' button)?/ do |field_to_edit, new_value, link_name, button_name|
  summary_page = current_url
  button_name ||= "Save and continue"

  step "I click the summary table '#{link_name}' link for '#{field_to_edit}'"
  step "I enter '#{new_value}' in the '#{field_to_edit}' field and click its associated '#{button_name}' button"

  page.visit(summary_page)
end

Then /^I see the '(.*)' summary table filled with:$/ do |table_heading, table|
  result_table_rows = get_table_rows_by_caption(table_heading)

  table.rows.each_with_index do |row, index|
    result_items = result_table_rows[index].all('td')
    expect(result_items[0].text).to eq(row[0])
    expect(result_items[1].text).to eq(row[1])
  end
end

Then /^I see '(.*)' in the '(.*)' summary table$/ do |content, table_heading|
  result_table_rows = get_table_rows_by_caption(table_heading)
  expect(result_table_rows.any? { |row| row.text.include?(content) }).to be true
end

Then /^I see that the '(.*)' summary table has (\d+)(?: or (more|fewer))? entr(?:y|ies)$/ do |table_heading, expected_number_of_rows, comparison|
  number_of_table_rows = get_table_rows_by_caption(table_heading).length
  case comparison
    when 'more'
      expect(number_of_table_rows).to be >= expected_number_of_rows.to_i
    when 'fewer'
      expect(number_of_table_rows).to be <= expected_number_of_rows.to_i
    else
      puts expect(number_of_table_rows).to eq(expected_number_of_rows.to_i)
  end
end

Then /^I see an entry in the '(.*)' table with:$/ do |table_heading, table|
  expected_row = table.rows[0]
  result_table_rows = get_table_rows_by_caption(table_heading)
  match = false

  result_table_rows.each do |row|
    # Get the row as an array of strings to compare with our expected row
    row_text_values = row.all('td').map { |td| td.text }
    # Ensure that the expected strings are in the correct place and that we skip anything with '<ANY>'
    if expected_row.each_with_index.map { |expected_value, expected_index| (expected_value == '<ANY>') || (row_text_values[expected_index] == expected_value) }.all?
      match = true
      break
    end
  end

  expect(match).to be(true), "Expected: #{expected_row.join(' | ')}"
end


Then /^I see the closing date of the brief in the '(.*)' summary table$/ do |table_heading|
  closing_date = DateTime.strptime(@brief['createdAt'], '%Y-%m-%dT%H:%M:%S') + 14
  step "I see '#{closing_date.strftime('%A %-d %B %Y')}' in the '#{table_heading}' summary table"
end

Then /^I see the '(.*)' radio button is checked(?: for the '(.*)' question)?$/ do |radio_button_name, question|
  if question
    within(:xpath, "//span[normalize-space(text())=\"#{question}\"]/../..") do
      expect(first_field(radio_button_name, type: 'radio')).to be_checked
    end
  else
    expect(first_field(radio_button_name, type: 'radio')).to be_checked
  end
end

Then /^I (don't |)see '(.*)' text on the page/ do |negative, expected_text|
  has_content = page.has_content?(expected_text)
  if negative.empty?
    expect(has_content).to be true
  else
    expect(has_content).to be false
  end
end

Then /^I see a '(.*)' attribute with the value '(.*)'/ do |attribute_name, attribute_value|
  place = "//*[@#{attribute_name} = \"#{attribute_value}\"]"
  expect(all(:xpath, place).length).to eq(1)
end

Then /^I take a screenshot/ do
  page.save_screenshot('screenshot.png')
end

And /^I wait for the page to reload/ do
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end

And /^I wait (\d+) seconds/ do |seconds|
  sleep seconds.to_i
end

Then(/^I should get a download file of type '(.*)'$/) do |file_type|
  expect(page.response_headers['Content-Disposition']).to match("attachment;filename=\\S*\\." + file_type)
end

Then(/^a filter checkbox's associated aria-live region contains #{MAYBE_VAR}$/) do |value|
  expect(
    page.find_by_id(
      page.all(
        :xpath,
        "//div[contains(@class, 'govuk-option-select')]//input[@type='checkbox']").sample["aria-controls"]
    ).text
  ).to include(value.to_s)
end

Then /^I set the page reload flag/ do
  page.evaluate_script "$(document.body).addClass('not-reloaded')"
end

Then /^I see that the page has not been reloaded/ do
  expect(page).to have_selector("body.not-reloaded")
end

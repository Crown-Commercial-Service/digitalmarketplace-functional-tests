require 'date'
require 'securerandom'
require 'uri'

Given /^I (?:re-?)?visit the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  expect(page).to have_content("Digital Marketplace")
end

Given /^I (?:re-?)?visit the (.* )?(\/.*) page$/ do |app, url|
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

Given /^the response (?:(header ))?(.*) should be (.*)$/ do |header, attribute, value|
  if header
    expect(@response.headers[attribute.to_sym].to_s).to eq(value)
  else
    expect(@response.send(attribute).to_s).to eq(value)
  end
end

Given /^I have the latest live (\S*) framework(?: with the (.*) lot)?$/ do |metaframework_slug, lot_slug|
  response = call_api(:get, "/frameworks")
  expect(response.code).to eq(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if { |framework| framework['framework'] != metaframework_slug || framework['status'] != 'live' }
  if lot_slug
    frameworks.delete_if { |framework| framework['lots'].select { |lot| lot["slug"] == lot_slug }.to_a.empty? }
  end
  expect(frameworks).not_to be_empty, _error(response, "No live '#{metaframework_slug}' frameworks found with lot '#{lot_slug}'")
  @framework = frameworks.sort_by! { |framework| framework[:id] }.reverse![0]
  puts "Framework: #{@framework['slug']}"
end

Given /^I have a random g-cloud service from the API$/ do
  frameworks = call_api(:get, "/frameworks")
  live_g_cloud_slugs = JSON.parse(frameworks.body)["frameworks"].select { |framework|
    framework["framework"] == "g-cloud" && framework["status"] == "live"
  }.map { |framework| framework["slug"] }
  # reverse sort by whatever is after the final "-" in the framework slug
  latest_g_cloud_slug = live_g_cloud_slugs.sort_by { |slug| slug.split('-')[-1].to_i }.reverse[0]

  puts "Latest live g-cloud framework slug: #{latest_g_cloud_slug}"

  params = { status: "published", framework: latest_g_cloud_slug }
  page_one = call_api(:get, "/services", params: params)
  expect(page_one.code).to eq(200)
  last_page_url = JSON.parse(page_one.body).dig('links', 'last')
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
  g_cloud_lot = live_g_cloud_frameworks.sort_by { |framework| framework["slug"].split('-')[-1].to_i }.reverse[0]["lots"].sample
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
  params = { status: "live,closed", framework: "digital-outcomes-and-specialists-4" }
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
    page.all(:xpath, "//input[@value='#{button_link_name}'] | //input[@name='#{button_link_name}'] | //button[contains(normalize-space(text()), '#{button_link_name}')] | //button[@name='#{button_link_name}']")[0].click
  elsif elem_type == 'link'
    page.click_link(button_link_name)
  else
    page.click_link_or_button(button_link_name)
  end
end

When /I click a( random)? link with text( containing)? #{MAYBE_VAR}(?: in #{MAYBE_VAR})?$/ do |maybe_random, maybe_containing, link_text, element|
  expect(element).not_to be_a(String), "It's not yet decided what a plain String should mean in this context"

  region = element || page
  if maybe_containing
    found_links = region.all(:xpath, "//a[contains(normalize-space(string()), normalize-space(#{escape_xpath(link_text)}))]")
  else
    found_links = region.all(:xpath, "//a[normalize-space(string())=normalize-space(#{escape_xpath(link_text)})]")
  end

  if found_links.length > 1 && !maybe_random
    puts "Warning: #{found_links.length} '#{link_text}' links found"
  end

  (maybe_random ? found_links.sample : found_links[0]).click
end

When /I click the (Next|Previous) Page link$/ do |next_or_previous|
  # can't use above as we have services with the word 'next' in the name :(
  # @TODO: Remove old classes when DM-GOVUK Search Page is released.
  klass = ''
  if next_or_previous == 'Next'
    if page.has_css?('.dm-pagination')
      klass = '.dm-pagination__item--next'
    else
      klass = '.next'
    end
  elsif next_or_previous == 'Previous'
    if page.has_css?('.dm-pagination')
      klass = '.dm-pagination__item--previous'
    else
      klass = '.previous'
    end
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
      choose_radio(radio_label, wait: false)
    end
  else
    choose_radio(radio_label, wait: false)
  end
end

When /I check a random '(.*)' checkbox$/ do |checkbox_name|
  checkbox = all_fields(checkbox_name, type: 'checkbox').sample
  check_checkbox(checkbox)
end

When /I choose a random '(.*)' radio button$/ do |name|

  radio = all_fields(name, type: 'radio').sample
  choose_radio(radio, wait: false)
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

When /^I enter #{MAYBE_VAR} in the '(.*)' field and click the selected autocomplete option?$/ do |value, field_name|
  field_element = page.find_field field_name
  field_element.set value
  # Find the sibling <ul>'s focused autocomplete <li> and click it
  focused_dropdown_item = field_element.find(:xpath, "following-sibling::ul[contains(@class, 'autocomplete__menu')]/li[contains(@class, 'autocomplete__option--focused')]")
  focused_dropdown_item.click
end

When(/^I choose a random uppercase letter$/) do
  @letter = ('A'..'Z').to_a.sample
  puts "letter: #{@letter}"
end

When(/^I choose a random sentence$/) do
  lexicon = %w[apple banana cherry date fig gooseberry juniper]
  @random_sentence = ((0..8).map { |n| lexicon.sample }).join(" ").capitalize + "."
  puts "sentence: #{@random_sentence}"
end

Then /^I see a (success|error|notice) flash message containing #{MAYBE_VAR}$/ do |type, message|
  flash_message = page.find(:css, ".dm-alert.dm-alert--#{type}, div.flash-message-container", wait: false)
  expect(flash_message).to have_content(message)
end

Then /^I don't see a flash message$/ do
  expect(page).not_to have_selector(:css, ".dm-alert")
end

# the rescue is used because if a banner cannot be found the function throws an exception and does not look for the other option
Then /^I see a (success|warning|destructive|temporary-message) banner message containing #{MAYBE_VAR}$/ do |status, message|
  begin
    banner_message = page.find(:css, ".dm-banner, .banner-#{status}-without-action", wait: false)
  rescue Capybara::ElementNotFound => e
    banner_message = page.find(:css, ".banner-#{status}-with-action", wait: false)
  end
  expect(banner_message).to have_content(message)
end

Then /^I don't see a banner message$/ do
  expect(page).not_to have_selector(:xpath, "//*[contains(@class, 'banner-')][contains(@class, '-action')]")
end

Then /^I see a validation message containing '(.*)'$/ do |message|
  validation_message = page.find(:css, ".validation-message, .govuk-error-message")
  expect(validation_message).to have_content(message)
end

Then /^I (don't |)see (?:the|a) '(.*)' (button|link)$/ do |negative, selector_text, selector_type|
  expect(page).to have_selector(:link_or_button, selector_text) if negative.empty?
  expect(page).not_to have_selector(:link_or_button, selector_text) unless negative.empty?
end

Then /^I wait to see (?:the|a) '(.*)' link with href '(.*)'$/ do |selector_text, href|
  find(:xpath, "//a[substring(@href, string-length(@href) - (string-length('#{href}')) + 1) = '#{href}'][normalize-space(text()) = '#{selector_text}']", wait: dm_custom_wait_time)
end

Then /^I am on #{MAYBE_VAR} page$/ do |page_name|
  expect(page).to have_selector('h1', text: normalize_whitespace(page_name))
end

Then /^I am at the (\/.*) url$/ do |page_url|
  expect(page.current_path).to include(page_url)
end

Then /^I see #{MAYBE_VAR} in the page's (.*)$/ do |page_name_fragment, selector|
  expect(page.find('main').find(selector).text).to include(normalize_whitespace(page_name_fragment))
end

Then(/^I see the page's h1 ends in #{MAYBE_VAR}$/) do |term|
  expect(find('h1').text).to end_with(term)
end

Then /I see #{MAYBE_VAR} as the value of the '(.*)' field$/ do |value, field|
  if page.has_field?(field, type: 'radio', visible: :all, wait: false) || page.has_field?(field, type: 'checkbox', visible: :all, wait: false)
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
  expect(page.find(:css, "header .context, [class*='govuk-caption']")).to have_text(value)
end

When /^I choose file '(.*)' for the field '(.*)'$/ do |file, label|
  attach_file(label, File.join(Dir.pwd, 'fixtures', file))
end

When /^I click the top\-level summary table '(.*)' link for the section '(.*)'$/ do |link_name, field_to_edit|
  edit_link = page.find(:xpath, "//h2[contains(text(), '#{field_to_edit}')]/following-sibling::p[1]/a[text()]")
  expect(edit_link.text).to have_content(link_name)
  edit_link.click
end

When /I click the summary (table|list) #{MAYBE_VAR} (link|button) for #{MAYBE_VAR}$/ do |table_or_list, link_name, elem_type, field_to_edit|
  row = page.find(table_or_list == "table" ? "td" : "dt", exact_text: field_to_edit).ancestor(table_or_list == "table" ? "tr" : "dl > *")
  case elem_type
    when 'link'
      edit_link = row.find_link(link_name)
    else
      edit_link = row.find_button(link_name)
  end
  edit_link.click
end

When /I click the summary table #{MAYBE_VAR} (link|button) for #{MAYBE_VAR} link$/ do |link_name, elem_type, field_to_edit|
  row = page.find_link(exact_text: field_to_edit).ancestor("tr")
  case elem_type
    when 'link'
      edit_link = row.find_link(link_name)
    else
      edit_link = page.find_button(link_name)
  end
  edit_link.click
end

When /I click a summary table #{MAYBE_VAR} (link|button) for #{MAYBE_VAR}$/ do |link_name, elem_type, field_to_edit|
  rows = page.all("td", exact_text: field_to_edit)
  case elem_type
    when 'link'
      edit_links = rows.flat_map { |row| row.find_link(link_name) }
    else
      edit_links = rows.flat_map { |row| row.find_button(link_name) }
  end

  if edit_links.length > 1
    puts "Warning: #{edit_links.length} '#{link_name}' links found"
  end

  edit_links.first.click
end

When /I update the value of '(.*)' to '(.*)' using the summary (table|list) '(.*)' link(?: and the '(.*)' button)?/ do |field_to_edit, new_value, table_or_list, link_name, button_name|
  summary_page = current_url
  button_name ||= "Save and continue"

  step "I click the summary #{table_or_list} '#{link_name}' link for '#{field_to_edit}'"
  step "I enter '#{new_value}' in the '#{field_to_edit}' field and click its associated '#{button_name}' button"

  page.visit(summary_page)
end

Then /^I see the '(.*)' summary (table|list) filled with:$/ do |heading, table_or_list, expected_table|
  if table_or_list == "table"
    result_rows = get_table_rows_by_caption(heading)
  else
    result_rows = get_summary_list_rows_by_preceding_heading(heading)
  end
  puts result_rows.length
  expected_table.rows.each_with_index do |expected_row, index|
    if table_or_list == "table"
      tds = result_rows[index].all('td')
      result_key = tds[0]
      result_value = tds[1]
    else
      result_key = result_rows[index].find('dt')
      result_value = result_rows[index].all('dd')[0]
    end

    expect(result_key.text).to eq(expected_row[0])
    # Skip anything with '<ANY>'
    if expected_row[1] != '<ANY>'
      expect(result_value.text(normalize_ws: true)).to eq(expected_row[1])
    end
  end
end

Then /^I (don't |)see #{MAYBE_VAR} in the '(.*)' (?:summary )?table$/ do |negate, content, table_heading|
  result_table_rows = get_table_rows_by_caption(table_heading)
  expect(result_table_rows.any? { |row| row.text.include?(content) }).to be negate.empty?
end

Then /^I (don't |)see #{MAYBE_VAR} in the '(.*)' summary list$/ do |negate, content, table_heading|
  result_table_rows = get_summary_list_rows_by_preceding_heading(table_heading)
  expect(result_table_rows.any? { |row| row.text.include?(content) }).to be negate.empty?
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


Then /^I see the closing date of the brief in the '(.*)' (summary |)table$/ do |table_heading, summary|
  closing_date = DateTime.strptime(@brief['createdAt'], '%Y-%m-%dT%H:%M:%S') + 14
  if summary == 'summary'
    step "I see '#{closing_date.strftime('%A %-d %B %Y')}' in the '#{table_heading}' summary table"
  else
    step "I see '#{closing_date.strftime('%A %-d %B %Y')}' in the '#{table_heading}' table"
  end
end

Then /^I see the '(.*)' (radio button|checkbox) is (not |)checked(?: for the '(.*)' question)?$/ do |elem_name, elem_type, negative, question|
  if elem_type == 'radio button'
    elem_type = 'radio'
  end
  if question
    within(:xpath, "//span[normalize-space(text())=\"#{question}\"]/../.. | //legend[normalize-space(text())=\"#{question}\"]/..") do
      if negative.empty?
        expect(first_field(elem_name, type: elem_type)).to be_checked
      else
        expect(first_field(elem_name, type: elem_type)).not_to be_checked
      end
    end
  else
    if negative.empty?
      expect(first_field(elem_name, type: elem_type)).to be_checked
    else
      expect(first_field(elem_name, type: elem_type)).not_to be_checked
    end
  end
end

Then /^I (don't |)see '(.*?)'(?: or '(.*)')? text on the page/ do |negative, expected_text, alternative_expected_text|
  method = negative.empty? ? :has_content? : :has_no_content?

  result = page.send(method, expected_text)
  alternative_result = alternative_expected_text ? page.send(method, alternative_expected_text) : false

  expect(result || alternative_result).to be true
end

Then /^I see a '(.*)' attribute with the value '(.*)'/ do |attribute_name, attribute_value|
  place = "//*[@#{attribute_name} = \"#{attribute_value}\"]"
  expect(all(:xpath, place).length).to eq(1)
end

Then /^I take a screenshot/ do
  page.save_screenshot('screenshot.png', full: true)
end

And /^I wait for the page to reload/ do
  Timeout.timeout(dm_custom_wait_time) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end

And /^I wait for the page to load/ do
  Timeout.timeout(dm_custom_wait_time) do
    loop until page.evaluate_script('document.readyState') === 'complete'
  end
end

Then(/^I should get an? (download|inline) file(?: with file.?name ending(?: in)? '(.*?)')?(?: (?:and|with) content.?type(?: of)? '(.*?)')?( in a new window)?$/) do |download_inline, ending, content_type, maybe_new_window|
  if maybe_new_window
    # beware - not all drivers *necessarily* keep the windows list in a defined order
    target_window = windows.last
    # any "new window" shouldn't be the current window
    expect(target_window.current?).to be(false)
    # if this is a just-opened window, it shouldn't have any history
    within_window(target_window) do
      expect(page.evaluate_script('window.history.length')).to eq(1)
    end
  else
    target_window = current_window
  end

  within_window(target_window) do
    disposition_parts = page.response_headers['Content-Disposition'].split(";")
    expect(disposition_parts[0]).to eq(case download_inline when "download" then "attachment" else download_inline end)
    if ending
      expect(disposition_parts[1]).to match("^\s*filename=.*#{Regexp.escape(ending)}['\"]?\s*$")
    end
    if content_type
      expect(page.response_headers['Content-Type']).to eq(content_type)
    end
  end
end

Then(/^a filter checkbox's associated aria-live region contains #{MAYBE_VAR}$/) do |value|
  expect(
    page.find_by_id(
      page.all(
        :css,
        "div .govuk-option-select input[type=checkbox], .dm-option-select input[type=checkbox]", visible: :all).sample["aria-controls"]
    ).text(:all)
  ).to include(value.to_s)
end

Then /^I set the page reload flag/ do
  page.evaluate_script "$(document.body).addClass('not-reloaded')"
end

Then /^I see that the page has not been reloaded/ do
  expect(page).to have_selector("body.not-reloaded")
end

When /^I see the '(.*)' field prefilled with #{MAYBE_VAR}?$/ do |field_name, value|
  field_element = page.find_field field_name
  expect(field_element.value).to include(normalize_whitespace(value))
end

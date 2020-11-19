Then (/^I see that supplier in the list of suppliers$/) do
  # we do a broad match using xpath first
  expect(
    page.all(:xpath, "//*[@class='summary-item-row'][.//a[contains(@href, '#{@supplier['id']}')]]").find_all { |row_element|
      # now refine with a much more precise test
      row_element.all(:css, "a").any? { |a_element|
        a_element[:href] =~ Regexp.new('^(.*\D)?' + "#{@supplier['id']}" + '(\D.*)?$')
      } && row_element.all(:css, ".summary-item-field-first-half > span").any? { |span_element|
        span_element.text == normalize_whitespace(@supplier['name'])
      }
    }.length
  ).to eq(1)
end

Then (/^I see the number of suppliers listed is (\d+)$/) do |supplier_count|
  expect(
    page.all(
      :xpath,
      "//*[@class='summary-item-row'][.//*[@class='summary-item-field-first-half']]"
    ).length
  ).to eq(supplier_count.to_i)
end

Given /^I have a (not-submitted|submitted|enabled|disabled|published|failed) service on a live G-Cloud framework$/ do |status|
  @service = get_a_service(status)
  puts "Service id: #{@service['id']}"
  puts "Service name: #{@service['serviceName']}"
end

When /^I enter that service id in the '(.*)' field( and click its associated '(.*)' button)?$/ do |field_name, maybe_click_statement, click_button_name|
  step "I enter '#{@service['id']}' in the '#{field_name}' field and click its associated '#{click_button_name}' button"
end

Then "I am on that service's page" do
  service_name = @service['serviceName']
  step "I am on the '#{service_name}' page"
  puts "Service name: #{service_name}"
end

Then "I see the framework the supplier is on in the 'Frameworks' table" do
  expected_row = [@framework['name'], "View services", "View agreements"]
  table_rows = get_table_rows_by_caption('Frameworks')

  match = table_rows.find do |row|
    expected_row == row.all('td').map { |td| td.text }
  end

  expect(match).not_to be_nil, "Expected: #{expected_row.join(' | ')}"
end

Then (/^I see that supplier in the list of suppliers$/) do
  # we do a broad match using xpath first
  expect(
    page.all(:xpath, "//*[@class='summary-item-row'][.//a[contains(@href, '#{@supplier['id']}')]]").find_all { |row_element|
      # now refine with a much more precise test
      row_element.all(:css, "a").any? { |a_element|
        a_element[:href] =~ Regexp.new('^(.*\D)?' + "#{@supplier['id']}" + '(\D.*)?$')
      } && row_element.all(:css, ".summary-item-field-first > span").any? { |span_element|
        span_element.text == normalize_whitespace(@supplier['name'])
      }
    }.length
  ).to eq(1)
end

Then (/^I see the number of suppliers listed is (\d+)$/) do |supplier_count|
  expect(
    page.all(
      :xpath,
      "//*[@class='summary-item-row'][.//*[@class='summary-item-field-first']]"
    ).length
  ).to eq(supplier_count.to_i)
end

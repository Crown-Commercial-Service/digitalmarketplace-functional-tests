When(/^I click the first letter of that supplier\.name$/) do
  # This step is hardcoded as we need to add a small exception for cases where the first character is non-alphabetic
  if ('a'..'z').include? @supplier['name'][0].downcase
    step "I click '#{@supplier['name'][0].upcase}' link"
  end
end

When(/^I click that specific supplier$/) do
  # This step is hardcoded as we want to make sure we don't somehow click a similarly-named supplier
  # @TODO: Remove else clause when DM-GOVUK search pages are released
  if page.has_css?('.app-search-result')
    result_class = 'app-search-result'
  else
    result_class = 'search-result'
  end

  # we do a broad match using xpath first
  a_elements = page.all(:xpath, "//*[@class='#{result_class}']//h2//a[contains(@href, '#{@supplier['id']}')]").find_all { |a_element|
    # now refine with a much more precise test
    (
      a_element[:href] =~ Regexp.new('^(.*\D)?' + "#{@supplier['id']}" + '(\D.*)?$')
    ) && (
      a_element.text == normalize_whitespace(@supplier['name'])
    )
  }
  expect(a_elements.length).to eq(1)
  a_elements[0].click
end

Then(/^I do not see any suppliers that don't begin with that letter$/) do
  supplier_links = page.all(:css, ".search-result .search-result-title a")
  supplier_links.each { |element|
    expect(element.text[0].upcase).to eq(@letter)
  }
  if supplier_links.length == 0
    puts "(but no suppliers were found)"
  end
end

Then (/^I see that supplier in one of the pages that follow from clicking (#{MAYBE_VAR})$/) do |next_link_label|
  i = 1
  # @TODO: Remove else clause when DM-GOVUK search pages are released
  if page.has_css?('.app-search-result')
    result_class = 'app-search-result'
    result_heading_class = 'govuk-heading-s govuk-!-margin-bottom-1'
  else
    result_class = 'search-result'
    result_heading_class = 'search-result-title'
  end
  until search_result = page.first(:xpath, "//*[@class='#{result_class}'][.//h2//a[contains(@href, '#{@supplier['id']}')]]")
    # ^^^ note assignment, not comparison here ^^^
    i += 1
    page.click_link(next_link_label)
    # if there wasn't another matching "next" link we should have errored out above
  end

  expect(
    search_result.first(:xpath, ".//h2[@class='#{result_heading_class}']/a").text
  ).to eq(normalize_whitespace(@supplier['name']))

  puts "Found supplier on page #{i}"
end

Given(/I navigate to the list of '(.*)' page$/) do |value|
  page.visit("#{dm_frontend_domain}/g-cloud/suppliers?prefix=#{value.split(' ').last}")
  @data_store ||= Hash.new
  @data_store['supplier_alphabet'] = "#{value.split(' ').last}"
end

Then(/I am taken to page '(.*)' of results$/) do |page_number|
  # @TODO: Remove old pagination styles once DM-GOVUK search page is released
  if current_url.include?('suppliers?')
    expect(current_url).to include("#{dm_frontend_domain}/g-cloud/suppliers?")
    expect(current_url).to include("prefix=#{@data_store['supplier_alphabet']}")
    expect(current_url).to include("page=#{page_number}")
    expect(current_url).to include("framework=g-cloud")
    if page_number >= '2'
      expect(page).to have_selector(
        :xpath,
        "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]" \
        "|" \
        "//nav//ul//li//a//span[contains(text(), 'Previous page')]"
      )
    elsif page_number < '2'
      expect(page).to have_selector(
        :xpath,
        "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]" \
        "|" \
        "//nav//ul//li//a//span[contains(text(), 'Next page')]"
      )
      expect(page).not_to have_selector(
        :xpath,
        "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]" \
        "|" \
        "//nav//ul//li//a//span[contains(text(), 'Previous page')]"
      )
    end
  end
end


Then(/pagination is '(.*)'$/) do |availability|
  # @TODO: Remove old pagination styles once DM-GOVUK search page is released
  if current_url.include?('suppliers?')
    pagination_available = "#{availability}"
  else
    fail("Pagination check only works for the suppliers list page these days.")
  end

  if pagination_available == 'available'
    expect(page).to have_selector(
      :xpath,
      "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]" \
      "|" \
      "//nav//ul//li//a//span[contains(text(), 'Next page')]"
    )
    expect(page).not_to have_selector(
      :xpath,
      "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]" \
      "|" \
      "//nav//ul//li//a//span[contains(text(), 'Previous page')]"
    )
  elsif pagination_available == 'not available'
    expect(page).not_to have_selector(
      :xpath,
      "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]" \
      "|" \
      "//nav//ul//li//a//span[contains(text(), 'Next page')]"
    )
    expect(page).not_to have_selector(
      :xpath,
      "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]" \
      "|" \
      "//nav//ul//li//a//span[contains(text(), 'Previous page')]"
    )
  end
end

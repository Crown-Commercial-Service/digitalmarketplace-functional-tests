When(/^I click the first letter of that supplier\.name$/) do
  # This step is hardcoded as we need to add a small exception for cases where the first character is non-alphabetic
  if ('a'..'z').include? @supplier['name'][0].downcase then
    step "I click '#{@supplier['name'][0].upcase}' link"
  end
end

When(/^I click that specific supplier$/) do
  # This step is hardcoded as we want to make sure we don't somehow click a similarly-named supplier

  # we do a broad match using xpath first
  a_elements = page.all(:xpath, "//*[@class='search-result']//h2//a[contains(@href, '#{@supplier['id']}')]").find_all { |a_element|
    # now refine with a much more precise test
    (
      a_element[:href] =~ Regexp.new('^(.*\D)?'+"#{@supplier['id']}"+'(\D.*)?$')
    ) and (
      a_element.text == normalize_whitespace(@supplier['name'])
    )
  }
  a_elements.length.should be(1)
  a_elements[0].click
end

Then(/^I do not see any suppliers that don't begin with that letter$/) do
  supplier_links = page.all(:css, ".search-result .search-result-title a")
  supplier_links.each { |element|
    element.text[0].upcase.should == @letter
  }
  if supplier_links.length == 0 then
    puts "(but no suppliers were found)"
  end
end

Then (/^I see that supplier in one of the pages that follow from clicking '(.*)'$/) do |next_link_label|
  until search_result = page.first(:xpath, "//*[@class='search-result'][.//h2//a[contains(@href, '#{@supplier['id']}')]]")
    page.click_link(next_link_label)
    # if there wasn't another matching "next" link we should have errored out above
  end

  search_result.first(:xpath,
    ".//h2[@class='search-result-title']/a"
  ).text.should == normalize_whitespace(@supplier['name'])
end

Given(/I navigate to the list of '(.*)' page$/) do |value|
  page.visit("#{dm_frontend_domain}/g-cloud/suppliers?prefix=#{value.split(' ').last}")
  @data_store = @data_store || Hash.new
  @data_store['supplier_alphabet'] = "#{value.split(' ').last}"
end

Then(/I am taken to page '(.*)' of results$/) do |page_number|
  if current_url.include?('suppliers?')
    current_url.should include("#{dm_frontend_domain}/g-cloud/suppliers?")
    current_url.should include("prefix=#{@data_store['supplier_alphabet']}")
    current_url.should include("page=#{page_number}")
    current_url.should include("framework=g-cloud")
    if page_number >= '2'
      page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    elsif page_number < '2'
      page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
      page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    end
  end
end


Then(/pagination is '(.*)'$/) do |availability|
  if current_url.include?('suppliers?')
    pagination_available = "#{availability}"
  else
    fail("Pagination check only works for the suppliers list page these days.")
  end

  if pagination_available == 'available'
    page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  elsif pagination_available == 'not available'
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  end
end
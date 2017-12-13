When(/^I click a random result in the list of service results returned$/) do
  search_results = all(:xpath, "//*[@class='search-result']")
  selected_result = search_results[rand(search_results.length)]

  @result = @result || Hash.new

  a_elem = selected_result.first(:xpath, ".//h2[@class='search-result-title']/a")
  @result['title'] = a_elem.text
  puts "Result name: #{ERB::Util.h @result['title']}"

  @result['supplier_name'] = selected_result.first(:xpath, ".//*[@class='search-result-supplier']").text
  puts "Result supplier_name: #{ERB::Util.h @result['supplier_name']}"

  a_elem.click
end

Then (/^I (don't )?see a search result$/) do |negate|
  if negate then
    page.should_not have_selector(:css, "div.search-result")
  else
    page.should have_selector(:css, "div.search-result")
  end
end

Then (/^I see that service in the search results$/) do
  # we do a broad match using xpath first
  page.all(:xpath, "//*[@class='search-result'][.//h2//a[contains(@href, '#{@service['id']}')]]").find_all { |sr_element|
    # now refine with a much more precise test
    sr_element.all(:css, "h2 a").any? { |a_element|
      (
        a_element[:href] =~ Regexp.new('^(.*\D)?'+"#{@service['id']}"+'(\D.*)?$')
      ) and (
        a_element.text == normalize_whitespace(@service['serviceName'])
      )
    } and sr_element.all(:css, "p.search-result-supplier").any? { |p_element|
      p_element.text == normalize_whitespace(@service['supplierName'])
    } and sr_element.all(:css, "li.search-result-metadata-item").any? { |li_element|
      li_element.text == normalize_whitespace(@service['lotName'])
    } and sr_element.all(:css, "li.search-result-metadata-item").any? { |li_element|
      li_element.text == normalize_whitespace(@service['frameworkName'])
    }
  }.length.should be(1)
end

Then(/^I see #{MAYBE_VAR} in the search summary text$/) do |value|
  expect(find(:xpath, "//*[@class='search-summary']").text()).to include(normalize_whitespace(value))
end

Then (/^I note the number of search results$/) do
  @service_count = CatalogueHelpers.get_service_count(page)
end

Then /^I click a random category link$/ do
  links = CatalogueHelpers.get_category_links(page)
  link_el = links.sample
  @category_name = link_el.text.sub(/ \([0-9]*\)/, "")  # remove service count
  link_el.click
end

Then(/^I see fewer search results than noted$/) do
  expect(CatalogueHelpers.get_service_count(page)).to be < @service_count
end

Then(/^I select several random filters$/) do
  page.all(:xpath, "//div[contains(@class, 'govuk-option-select')]//input[@type='checkbox']").sample.click
end

Then(/^I note the number of category links$/) do
  @category_link_count = CatalogueHelpers.get_category_links(page).length
end

Then(/^I am taken to page (\d+) of results$/) do |page_number|
  page_number = page_number.to_i
  current_url.should include("page=#{page_number}")
  page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
  page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '#{page_number+1} of')]")
  if page_number == 1
    page.should have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    page.should have_no_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
  else
    page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    page.should have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '#{page_number-1} of')]")

  end
end

Then(/^I see the same number of category links as noted/) do
  expect(CatalogueHelpers.get_category_links(page).length).to be == @category_link_count
end

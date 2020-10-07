When /^I search for #{MAYBE_VAR} using the search box$/ do |query|
  page.fill_in "q", with: query
  page.click_button("Search")
end

When /^I see #{MAYBE_VAR} as the search query in the search box$/ do |query|
  expect(page.find_field("q").value).to eq(query)
end

When(/^I click a random result in the list of service results returned$/) do
  search_results = all(:xpath, "//*[@class='app-search-result' or @class='search-result']")
  selected_result = search_results[rand(search_results.length)]

  @result = @result || Hash.new

  a_elem = selected_result.first(:css, "h2.govuk-heading-s a, h2.search-result-title a")
  @result['title'] = a_elem.text
  puts "Result name: #{ERB::Util.h @result['title']}"

  @result['supplier_name'] = selected_result.first(:css, "p:nth-of-type(1), .search-result-supplier").text
  puts "Result supplier_name: #{ERB::Util.h @result['supplier_name']}"

  a_elem.click
end

Then (/^I (don't )?see a search result$/) do |negate|
  if negate
    expect(page).not_to have_selector(:css, "li.app-search-result, div.search-result")
  else
    expect(page).to have_selector(:css, "li.app-search-result, div.search-result")
  end
end

Then (/^I continue clicking #{MAYBE_VAR} until I see that service in the search results$/) do |next_link_label|
  i = 1
  until (search_results = CatalogueHelpers.get_service_search_results(page, @service)).length != 0
    # ^^^ note embedded assignment here ^^^
    i += 1
    page.click_link(next_link_label)
    # if there wasn't another matching "next" link we should have errored out above
  end

  expect(search_results.length).to eq(1)
  @search_result = search_results[0]

  puts "Found service on page #{i}"
end

Then(/^I see #{MAYBE_VAR} in the search summary text$/) do |value|
  expect(find(:xpath, "//*[@class='search-summary']").text).to include(normalize_whitespace(value))
end

Then (/^I note the number of search results$/) do
  @result_count = CatalogueHelpers.get_service_count(page)
  puts "Noted result_count: #{@result_count}"
end

Then (/^I note the total number of pages of results$/) do
  @page_count = CatalogueHelpers.get_page_count(page)
  if not @page_count
    puts "Unable to find page count - assuming single page"
    @page_count = "1"
  end
  puts "Noted page_count: #{@page_count}"
end

Then(/^I click the (.*) category link$/) do |category|
  # Look for links only in the lot-filters div so we don't click any
  # search results which happen to include the name of a lot/category.
  page.find(:css, ".lot-filters a", text: category).click
end

Then /^I click a random category link$/ do
  links = CatalogueHelpers.get_category_links(page)
  link_el = links.sample
  @category_name = link_el.text.sub(/ \([0-9]*\)/, "")  # remove service count
  puts "Clicking '#{link_el.text}'"
  link_el.click
end

Then(/^I see fewer search results than noted$/) do
  expect(CatalogueHelpers.get_service_count(page)).to be < @result_count
end

When(/^I (un)?check the (.*) checkbox in the (.*) group$/) do |maybe_un, checkbox_label, group_label|
  if has_css?(".dm-option-select")
    begin
      is_checkbox_visible = page.find("label", text: checkbox_label)
    rescue Capybara::ElementNotFound
      page.find("button.dm-option-select__button", text: group_label).click
    end
  end

  if not maybe_un
    check_checkbox(checkbox_label)
  else
    uncheck_checkbox(checkbox_label)
  end
end

Then(/^I select several random filters$/) do
  # We now hide options by default, so need to open them up first
  if has_css?("button.dm-option-select__button")
    button_el = page.all(:css, 'button.dm-option-select__button').sample
    button_el.click
    page.all(:css, ".js-opened .govuk-checkboxes__label").sample.click
  else
    page.all(:xpath, "//div[contains(@class, 'govuk-option-select')]//input[@type='checkbox']").sample.click
  end
end

Then(/^I note the number of category links$/) do
  @category_link_count = CatalogueHelpers.get_category_links(page).length
  puts "Noted category_link_count: #{@category_link_count}"
end

Then(/^I am taken to page (\d+) of results$/) do |page_number|
  page_number = page_number.to_i
  expect(current_url).to include("page=#{page_number}")

  if page.has_css?('.dm-pagination') # @TODO: New pagination - remove else clause when search page released
    expect(page).to have_selector(:xpath, "//nav//ul//li//a//span[contains(text(), 'Next page')]")
    expect(page).to have_selector(:xpath, "//nav//ul//li//a//span[contains(text(), '#{page_number + 1} of')]")
    if page_number == 1
      expect(page).not_to have_selector(:xpath, "//nav//ul//li//a//span[contains(text(), 'Previous page')]")
    else
      expect(page).to have_selector(:xpath, "//nav//ul//li//a//span[contains(text(), 'Previous page')]")
      expect(page).to have_selector(:xpath, "//nav//ul//li//a//span[contains(text(), '#{page_number - 1} of')]")
    end
  else
    expect(page).to have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]")
    expect(page).to have_selector(:xpath, "//a[contains(text(), 'Next')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '#{page_number + 1} of')]")
    if page_number == 1
      expect(page).not_to have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
    else
      expect(page).to have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]")
      expect(page).to have_selector(:xpath, "//a[contains(text(), 'Previous')]//following-sibling::span[contains(text(),'page')]/..//following-sibling::span[@class='page-numbers'][contains(text(), '#{page_number - 1} of')]")
    end
  end
end

When(/^I visit(?: the)? page number(?: of)? #{MAYBE_VAR}/) do |page_number|
  current_url_uri = URI(current_url)
  query_hash = Hash[URI::decode_www_form(current_url_uri.query || "")]
  query_hash["page"] = page_number
  current_url_uri.query = URI::encode_www_form(query_hash)
  page.visit(current_url_uri.to_s)
end

Then(/^I see the same number of category links as noted/) do
  expect(CatalogueHelpers.get_category_links(page).length).to be == @category_link_count
end

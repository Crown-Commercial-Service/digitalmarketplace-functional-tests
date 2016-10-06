Then(/^I do not see any suppliers that don't begin with that letter$/) do
  supplier_links = page.all(:css, ".search-result .search-result-title a")
  supplier_links.each { |element|
    element.text[0].upcase.should == @letter
  }
  if supplier_links.length == 0 then
    puts "(but no suppliers were found)"
  end
end

When(/^I click the first letter of that supplier\.name$/) do
  # This step is hardcoded as we need to add a small exception for cases where the first character is non-alphabetic
  if ('a'..'z').include? @supplier['name'][0].downcase then
    step "I click '#{@supplier['name'][0].upcase}' link"
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

When(/^I click that specific supplier$/) do
  # This step is hardcoded as we want to make sure we don't somehow click a similarly-named supplier
  link_elem = page.first(:xpath, "//*[@class='search-result']//h2//a[contains(@href, '#{@supplier['id']}')]")
  # make doubly sure we've got the right link
  link_elem.text.should == normalize_whitespace(@supplier['name'])
  link_elem.click
end

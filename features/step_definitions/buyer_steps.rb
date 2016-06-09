Then /^I see a service in the search results$/ do
  page.should have_selector(:css, "div.search-result")
end


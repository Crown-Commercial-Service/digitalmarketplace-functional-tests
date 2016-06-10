Then /^I see a service in the search results$/ do
  page.should have_selector(:css, "div.search-result")
end

Then /I see that service\.(.*) as the value of the '(.*)' field$/ do |attr_name, field|
  step "I see '\"#{@service.fetch(attr_name)}\"' as the value of the '#{field}' field"
end

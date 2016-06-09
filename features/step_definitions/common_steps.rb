Given /^I am on the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  page.should have_content("Digital Marketplace")
end

Given /^I am on the (\/.*) page$/ do |url|
  page.visit("#{dm_frontend_domain}#{url}")
  page.should have_content("Digital Marketplace")
end

When /^I click the '(.*)' link$/ do |link|
  page.click_link(link)
end

Then /^I see the '(.*)' link$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I am on the '(.*)' page$/ do |page_name|
  find('h1').should have_content(/#{page_name}/i)
end

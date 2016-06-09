Given /^I am on the homepage$/ do
  page.visit("#{dm_frontend_domain}")
  page.should have_content("Digital Marketplace")
end

Then /^I see the link to '(.*)'$/ do |link_text|
  page.should have_link(link_text)
end

When /^I click the '(.*)' link$/ do |link|
  page.click_link(link)
end

Given /^I have a live brief$/ do
  brief_id = create_brief("digital-outcomes-and-specialists", "digital-specialists", 1)
  puts "created brief with id #{brief_id}"
  brief = publish_brief(brief_id)
  puts "published brief"
  @brief_id = brief_id
  @brief = brief
end

Given /^I go to that brief page$/ do
  url = "/digital-outcomes-and-specialists/opportunities/#{@brief_id}"
  page.visit("#{dm_frontend_domain}#{url}")
  # Put an assertion here
end

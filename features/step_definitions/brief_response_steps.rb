Given /^I have a live (.*) brief$/ do |lot_slug|
  brief_id = create_brief(lot_slug, @buyer["id"])
  puts "created brief with id #{brief_id}"
  brief = publish_brief(brief_id)
  @brief_id = brief_id
  @brief = brief
end

Given /^I go to that brief page$/ do
  url = "/digital-outcomes-and-specialists/opportunities/#{@brief_id}"
  page.visit("#{dm_frontend_domain}#{url}")
end

Given 'I have a buyer' do
  @buyer = step "I have a buyer user"
end

Given 'I have a supplier' do
  @supplier = create_supplier
end

Given /^that supplier is on the (.*) framework$/ do |framework_slug|
  submit_supplier_declaration(framework_slug, @supplier["id"], {})
end

Given /^that supplier has a service on the (.*) lot$/ do |lot_slug|
  @service = create_live_service(lot_slug, @supplier["id"])
end

Given 'that supplier has a user' do
  @supplier_user = step "I have a supplier user with supplier id #{@supplier['id']}"
end

Given 'that supplier user is logged in' do
  steps %Q{
    And I am on the /login page
    When I enter that supplier_user.emailAddress in the 'Email address' field
    And I enter that supplier_user.password in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' link
  }
end

Given 'that supplier has a completed brief-response' do
  @brief_response = create_brief_response(@service['lotSlug'], @brief_id, @supplier['id'])
end

Then /^I visit the '(.*)' question page for that brief response$/ do |question|
  url = "/suppliers/opportunities/#{@brief_id}/responses/#{@brief_response}/#{question}"
  step "I am on the #{url} page"
end

Then /^I see '(.*)' replayed in the question advice$/ do |replayed_info|
  page.should have_xpath("//span[@class='question-advice']/p", text: replayed_info)
end

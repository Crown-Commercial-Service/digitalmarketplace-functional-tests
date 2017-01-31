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

Given /^Do the setup$/ do
  supplier = create_supplier()
  @supplier = supplier
  puts supplier

  user_details = {
    "emailAddress" => SecureRandom.hex + '-supplier@example.gov.uk',
    "name" => SecureRandom.hex,
    "password" => SecureRandom.hex,
    "role" => 'supplier',
    "supplierId"=> supplier["id"]
  }
  @user_details = user_details
  puts user_details

  supplier_user = ensure_user_exists(user_details)
  @supplier_user = supplier_user
  puts supplier_user

  service = create_live_service(supplier["id"])
  @service = service
  puts service

  declaration = create_declaration(supplier["id"], 'digital-outcomes-and-specialists')
  puts declaration

  steps %Q{
    And I am on the /login page
    When I enter that user_details.emailAddress in the 'Email address' field
    And I enter that user_details.password in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' link
  }
  # Put an assertion here
end

When "I fill in the nice to have evidence" do
  puts 'doing this'
  page.choose('input-yesNo-0-no')
  page.choose('input-yesNo-1-no')
  page.choose('input-yesNo-2-no')
end


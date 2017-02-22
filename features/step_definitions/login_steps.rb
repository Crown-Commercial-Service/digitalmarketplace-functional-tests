Given /^I have a production ([a-z-]+) user$/ do |user_role|
  randomString = SecureRandom.hex

  user_details = {
    "emailAddress" => ENV["DM_PRODUCTION_#{user_role.upcase.gsub('-', '_')}_USER_EMAIL"],
    "name" => "#{user_role.capitalize} Name #{randomString}",
    "password" => ENV["DM_PRODUCTION_#{user_role.upcase.gsub('-', '_')}_USER_PASSWORD"],
    "role" => user_role,
  }

  user_details["supplierId"] = ENV['DM_PRODUCTION_SUPPLIER_USER_SUPPLIER_ID'].to_i if user_role == "supplier"

  @user = user_details.merge(ensure_user_exists(user_details))
  puts "Email address: #{@user['emailAddress']}"
end

Given /^I have a ([a-z-]+) user(?: with supplier id (\d*))?$/ do |user_role, supplier_id|
  randomString = SecureRandom.hex
  password = ENV["DM_PRODUCTION_#{user_role.upcase.gsub('-', '_')}_USER_PASSWORD"]

  user_data = {
    "emailAddress" => randomString + '@example.gov.uk',
    "name" => "#{user_role.capitalize} Name #{randomString}",
    "password" => password,
    "role" => user_role,
    "phoneNumber" => (SecureRandom.random_number(10000000) + 10000000000).to_s,
  }

  user_data['supplierId'] = supplier_id.to_i if user_role == 'supplier'

  response = call_api(:post, "/users", payload: {users: user_data, updated_by: 'functional_tests'})
  response.code.should be(201), response.body
  @user = JSON.parse(response.body)["users"]
  @user['password'] = password
  puts "Email address: #{@user['emailAddress']}"
  @user
end

Given /^I am logged in as (?:a|the) (production )?(\w+) user$/ do |production, user_role|
  login_page = if user_role.start_with? 'admin' then '/admin/login' else '/login' end
  steps %Q{
    Given I have a #{production}#{user_role} user
    And I am on the #{login_page} page
    When I enter that user.emailAddress in the 'Email address' field
    And I enter that user.password in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' link
  }
end

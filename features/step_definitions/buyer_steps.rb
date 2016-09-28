require 'securerandom'

Given (/^I have a buyer user$/) do
  randomString = SecureRandom.hex
  password = SecureRandom.hex
  user_data = {
    emailAddress: randomString + '@example.gov.uk',
    name: 'Buyer Name ' + randomString,
    password: password,
    role: 'buyer',
    phoneNumber: (SecureRandom.random_number(10000000) + 10000000000).to_s,
  }

  response = call_api(:post, "/users", payload: {users: user_data, updated_by: 'functional_tests'})
  response.code.should be(201), response.body
  @user = JSON.parse(response.body)["users"]
  @user['password'] = password
  puts "Email address: #{@user['emailAddress']}"
end

Given (/^I am logged in as a buyer user$/) do
  steps %Q{
    Given I have a buyer user
    And I am on the /login page
    When I enter that user.emailAddress in the 'email_address' field
    And I enter that user.password in the 'password' field
    And I click 'Log in' button
    Then I am on the 'Digital Marketplace' page
  }
end

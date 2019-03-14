Given /^I have (?:an|the) existing ([a-z-]+) user$/ do |user_role|
  randomString = SecureRandom.hex

  user_details = {
    "emailAddress" => ENV["DM_#{user_role.upcase.gsub('-', '_')}_USER_EMAIL"],
    "name" => "#{user_role.capitalize} Name #{randomString}",
    "password" => ENV["DM_#{user_role.upcase.gsub('-', '_')}_USER_PASSWORD"],
    "role" => user_role,
  }

  user_details["supplierId"] = ENV['DM_SUPPLIER_USER_SUPPLIER_ID'].to_i if user_role == "supplier"

  @user = user_details.merge(ensure_user_exists(user_details))
  puts "Email address: #{@user['emailAddress']}"
end

Given /^I am logged in as (a|the existing) ([\w\-]+) user$/ do |existing, user_role|
  login_page = '/user/login'
  steps %{
    Given I have #{existing} #{user_role} user
    And I visit the #{login_page} page
    When I enter that user.emailAddress in the 'Email address' field
    And I enter that user.password in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' button
  }
end

Given /^I have a buyer user$/ do
  @buyer_user = create_user('buyer')
end

Given /^I have a supplier user$/ do
  @supplier = create_supplier
  @supplier_user = create_user('supplier', "supplierId" => @supplier['id'])
end

Given /^I have (?:a|an) ([a-z\-]+) user with:$/ do |role, table|
  custom_user_data = table.rows_hash
  custom_user_data['role'] = role
  instance_variable_set("@#{role}_user".gsub('-', '_'), get_or_create_user(custom_user_data))
end

Given /^I have a supplier$/ do
  @supplier = create_supplier
end

Given /^I have a supplier with:$/ do |table|
  @supplier = get_or_create_supplier(table.rows_hash)
end

Given /^that supplier has a user with:$/ do |table|
  # To be used in conjunction with the above 2 methods to create multiple users on a supplier with specific attributes
  custom_user_data = table.rows_hash
  user_data = { "supplier_id" => @supplier['id'] }
  custom_user_data.update(user_data)
  @supplier_user = get_or_create_user(custom_user_data)
end

Given /^that (supplier|buyer) is logged in$/ do |user_role|
  user = user_role == 'supplier' ? @supplier_user : @buyer_user

  steps %{
    And I visit the /user/login page
    When I enter '#{user['emailAddress']}' in the 'Email address' field
    And I enter '#{user['password']}' in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' button
  }
end

When /^the wrong password is entered (\d+) times for that user$/ do |tries|
  tries.to_i.times do |n|
    steps %{
      Given I visit the /user/login page
      When I enter '#{@user['emailAddress']}' in the 'Email address' field
      And I enter 'the_wrong_password' in the 'Password' field
      And I click the 'Log in' button
    }
  end
end

Then /^that user can not log in using their correct password$/ do
  steps %{
    Given I visit the /user/login page
    When I enter '#{@user['emailAddress']}' in the 'Email address' field
    And I enter '#{@user['password']}' in the 'Password' field
    And I click the 'Log in' button
    Then I see a destructive banner message containing 'Accounts are locked'
    And I don't see the 'Log out' button
  }
end

Given /^that user is on the user research mailing list$/ do
  steps %{
    Given I visit the homepage
    When I click the 'View your account' link
    And I click the 'Join the user research mailing list' link
    And I check 'Send me emails about opportunities to get involved in user research' checkbox
    And I click the 'Save changes' button
  }
end

Then /^that user is able to reset their password$/ do
  steps %{
    Given I visit the /user/login page
    When I click 'Forgotten password'
    Then I am on the 'Reset password' page

    When I enter that user.emailAddress in the 'Email address' field
    And I click 'Send reset email' button
    Then I see a success banner message containing 'send a link to reset the password'
    And I receive a 'reset-password' email for that user.emailAddress
    And I click the link in that email
    Then I am on the 'Reset password' page
    When I enter that user.password in the 'New password' field
    And I enter that user.password in the 'Confirm new password' field
    And I click 'Reset password' button
    Then I am on the 'Log in to the Digital Marketplace' page
    And I see a success banner message containing 'You have successfully changed your password.'
  }
end

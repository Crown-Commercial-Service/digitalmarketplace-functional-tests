# this is a slight piece of nastiness to cover the fact that different types of user will
# have different 'login' pages
Given /^I am on the login page for that (\w+) user$/ do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  step "I am on the #{if var['role'].start_with? 'admin' then '/admin/login' else '/login' end} page"
end

Given /^I am logged in as that (\w+) user$/ do |variable_name|
  var = instance_variable_get("@#{variable_name}")
  steps %Q{
    Given I am on the login page for that #{variable_name} user
    When I enter that #{variable_name}.emailAddress in the 'Email address' field
    And I enter that #{variable_name}.password in the 'Password' field
    And I click the 'Log in' button
    Then I see the 'Log out' link
  }
end

# encoding: utf-8
require "rubygems"
require "rest_client"
require "json"
require "test/unit"

def create_supplier (supplier_id, supplier_name, supplier_description, supplier_contactName, supplier_email, supplier_postcode, supplier_dunsnumber)
  file = File.read("./fixtures/test-supplier.json")
  supplier_data = JSON.parse(file)
  supplier_data["suppliers"]["id"] = supplier_id
  supplier_data["suppliers"]["name"] = supplier_name
  supplier_data["suppliers"]["description"] = supplier_description
  supplier_data["suppliers"]["contactInformation"][0]["contactName"] = supplier_contactName
  supplier_data["suppliers"]["contactInformation"][0]["email"] = supplier_email
  supplier_data["suppliers"]["contactInformation"][0]["postcode"] = supplier_postcode
  supplier_data["suppliers"]["dunsNumber"] = supplier_dunsnumber

  supplier_path = "/suppliers/#{supplier_id}"

  response = call_api(:get, supplier_path)
  if response.code == 404
    response = call_api(:put, supplier_path, payload: supplier_data)
    response.code.should be(201), response.body
  else
    response = call_api(:post, supplier_path, payload: supplier_data)
    response.code.should be(200), response.body

    contact_id = JSON.parse(response.body)["suppliers"]["contactInformation"][0]["id"]
    contact_data = JSON.parse("{\"updated_by\":\"Functional tests\", \"contactInformation\":#{supplier_data ["suppliers"]["contactInformation"][0].to_json}}")
    response = call_api(:post, "/suppliers/#{supplier_id}/contact-information/#{contact_id}", payload: contact_data)
    response.code.should be(200), response.body
  end
end

Given /^I have test suppliers$/ do
  create_supplier(11111,"DM Functional Test Supplier","This is a test supplier, which will be used solely for the purpose of running functional test.","Testing Supplier Name","Testing.supplier.NaMe@DMtestemail.com","WC2B 6NH","930123456789")
  create_supplier(11112,"DM Functional Test Supplier 2","Second test supplier solely for use in functional tests.","Testing Supplier 2 Name","Testing.supplier.2.NaMe@DMtestemail.com","WB1B 5QH","931123456789")
end

def create_live_service (supplier_id, service_id, lot)
  file = File.read("./fixtures/#{supplier_id}-g6-#{lot}-test-service.json")
  service_data = JSON.parse(file)
  service_data["services"]["id"] = service_id
  service_data["services"]["serviceName"] = "#{service_id} #{service_data ["services"]["serviceName"]}"

  service_path = "/services/#{service_id}"

  response = call_api(:get, service_path)
  if response.code == 404
    response = call_api(:put, service_path, payload: service_data)
    response.code.should be(201), response.body
  else
    response = call_api(:post, service_path, payload: service_data)
    response.code.should be(200), response.body

    service_data.delete("services")
    response = call_api(:post, service_path + "/status/published", payload: service_data)
    response.code.should be(200), response.body
  end
end

Given /^The test suppliers have live services$/ do
    create_live_service(11111,"1123456789012346","iaas")
    create_live_service(11111,"1123456789012347","paas")
    create_live_service(11111,"1123456789012348","saas")
    create_live_service(11111,"1123456789012349","scs")
    create_live_service(11111,"1123456789012350","iaas")
    create_live_service(11111,"1123456789012351","paas")
    create_live_service(11111,"1123456789012352","saas")
    create_live_service(11111,"1123456789012353","scs")
    create_live_service(11112,"1123456789012354","iaas")
end

def create_user (email,username,password,role,supplierid=nil)
  file = File.read("./fixtures/test-user.json")
  user_data = JSON.parse(file)
  user_data["users"]["emailAddress"] = email
  user_data["users"]["name"] = username
  user_data["users"]["password"] = password
  user_data["users"]["role"] = role
  user_data["users"]["supplierId"] = supplierid if supplierid

  response = call_api(:get, "/users", params: {email_address: email})
  if response.code == 404
    response = call_api(:post, "/users", payload: user_data)
    response.code.should be(201), response.body
  end
end

def create_supplier_user (supplierid,email,username,password)
  create_user(email,username,password,"supplier",supplierid)
end

def create_admin_user (email,username,password)
  create_user(email,username,password,"admin")
end

And /^The test suppliers have users$/ do
  create_supplier_user(11111,dm_supplier_user_email(),"DM Functional Test Supplier User 1", dm_supplier_password())
  create_supplier_user(11111,dm_supplier_user2_email(),"DM Functional Test Supplier User 2", dm_supplier_password())
  create_supplier_user(11111,dm_supplier_user3_email(),"DM Functional Test Supplier User 3", dm_supplier_password())
  create_supplier_user(11112,dm_supplier2_user_email(),"DM Functional Test Supplier 2 User 1", dm_supplier_password())
end

And /^The test suppliers have declarations$/ do
  declaration = JSON.parse(File.read("./fixtures/11111-g7-declaration.json"))
  payload = {
    "declaration" => declaration,
    "updated_by" => "Test User",
  }
  path = "/suppliers/11111/frameworks/g-cloud-7/declaration"
  response = call_api(:put, path, payload: payload)
  response.code.should be(200), response.body
end

And /^I have an admin user$/ do
  create_admin_user(dm_admin_email(),"DM Functional Test Admin User 1", dm_admin_password())
end

def activate_users (user_name)
  button_action = find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*/form[contains(@action,'activate')]/input[contains(@type,'submit')]").value
  if button_action == 'Activate'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//input[contains(@type, 'submit') and contains(@value,'#{button_action}')]").click
  end
end

And /^Test supplier users are active$/ do
  steps %Q{
    Given I have logged in to Digital Marketplace as a 'Administrator' user
    Then I am presented with the admin search page
  }
  page.visit("#{dm_frontend_domain}/admin/suppliers/users?supplier_id=11111")
  activate_users("DM Functional Test Supplier User 3")
  activate_users("DM Functional Test Supplier User 2")
  activate_users("DM Functional Test Supplier User 1")
end

def unlock_users (user_name)
  lock_state = find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td[5]/*[text()]").text
  if lock_state != 'No'
      find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//input[contains(@type, 'submit') and contains(@value,'Unlock')]").click
  end
end

And /^Test supplier users are not locked$/ do
  steps %Q{
    Given I have logged in to Digital Marketplace as a 'Administrator' user
    Then I am presented with the admin search page
  }
  page.visit("#{dm_frontend_domain}/admin/suppliers/users?supplier_id=11111")
  unlock_users("DM Functional Test Supplier User 3")
  unlock_users("DM Functional Test Supplier User 2")
  unlock_users("DM Functional Test Supplier User 1")
end

And /^The user 'DM Functional Test Supplier User 3' is locked$/ do
  visit("#{dm_frontend_domain}/suppliers/login")

  response = call_api(:get, "/users", params: {email_address: dm_supplier_user3_email()})
  failedlogincount = JSON.parse(response.body)["users"][0]["failedLoginCount"]
  lockstate = JSON.parse(response.body)["users"][0]["locked"]

  while failedlogincount < 6 and lockstate == false
    fill_in('email_address', :with => dm_supplier_user3_email())
    fill_in('password', :with => 'invalidpassword')
    click_link_or_button('Log in')
    failedlogincount += 1
  end
end

def update_and_check_status (service_status)
  page.find(:xpath,"//*[contains(@name, 'status') and contains(@value, '#{service_status.downcase}')]").click
  steps %Q{
    And I click the 'Update status' button
    Then The service status is set as '#{service_status}'
    And I am presented with the message 'Service status has been updated to: #{service_status}'
  }
  current_service_status = page.find(
    :xpath,
    "//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]"
  ).text()
end

def service_status_public (service_id)
  page.visit("#{dm_frontend_domain}/admin/services/#{service_id}")
  page.should have_content('Service status')
  current_service_status = ''
  while current_service_status != 'Public'
    current_service_status = page.find(:xpath,"//*[contains(text(), 'Service status')]/following-sibling::*[@class='selection-button selection-button-selected'][text()]").text()
    if current_service_status == 'Removed'
      update_and_check_status("Private")
    elsif current_service_status == 'Private'
      update_and_check_status("Public")
    end
  end
end

And /^All services for the test suppliers are Public$/ do
  step "I have logged in to Digital Marketplace as a 'Administrator' user"
  service_status_public("1123456789012346")
  service_status_public("1123456789012347")
  service_status_public("1123456789012348")
  service_status_public("1123456789012349")
  service_status_public("1123456789012350")
  service_status_public("1123456789012351")
  service_status_public("1123456789012352")
  service_status_public("1123456789012353")
  service_status_public("1123456789012354")
end

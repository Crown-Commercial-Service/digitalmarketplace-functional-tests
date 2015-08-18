# encoding: utf-8
require "rubygems"
require "rest_client"
require "json"
require "test/unit"

def create_supplier (supplier_id, supplier_name, supplier_contactName, supplier_email, supplier_postcode, supplier_dunsnumber)
  file = File.read("./fixtures/test-supplier.json")
  json = JSON.parse(file)

  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  supplier_url = "#{url}/suppliers/#{supplier_id}"
  supplier_data = JSON.parse(file)
  supplier_data ["suppliers"]["id"] = supplier_id
  supplier_data ["suppliers"]["name"] = supplier_name
  supplier_data ["suppliers"]["contactInformation"][0]["contactName"] = supplier_contactName
  supplier_data ["suppliers"]["contactInformation"][0]["email"] = supplier_email
  supplier_data ["suppliers"]["contactInformation"][0]["postcode"] = supplier_postcode
  supplier_data ["suppliers"]["dunsNumber"] = supplier_dunsnumber

  response = RestClient.get(supplier_url, headers){|response, request, result| response }
  if response.code == 404
    response = RestClient.put(supplier_url, supplier_data.to_json, headers){|response, request, result| response }
    response.code.should == 201
  else
    response = RestClient.post(supplier_url, supplier_data.to_json, headers){|response, request, result| response }
    response.code.should == 200
    contact_id = JSON.parse(response.body)["suppliers"]["contactInformation"][0]["id"]
    contact_url = "#{url}/suppliers/#{supplier_id}/contact-information/#{contact_id}"
    contact_data = JSON.parse("{\"updated_by\":\"Functional tests\", \"contactInformation\":#{supplier_data ["suppliers"]["contactInformation"][0].to_json}}")
    response = RestClient.post(contact_url, contact_data.to_json, headers){|response, request, result| response }
    response.code.should == 200
  end
end

Given /^I have test suppliers$/ do
  create_supplier(11111,"DM Functional Test Supplier", "Testing Supplier Name", "Testing.supplier.NaMe@DMtestemail.com", "WC2B 6NH", "930123456789")
  create_supplier(11112,"DM Functional Test Supplier 2","Testing Supplier 2 Name", "Testing.supplier.2.NaMe@DMtestemail.com", "WB1B 5QH", "931123456789")
end

def create_service (supplier_id, service_id, lot)
  file = File.read("./fixtures/#{supplier_id}-g6-#{lot}-test-service.json")
  json = JSON.parse(file)

  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  service_url = "#{url}/services/#{service_id}"
  service_data = JSON.parse(file)
  service_data ["services"]["id"] = service_id
  service_data ["services"]["serviceName"] = "#{service_id} #{service_data ["services"]["serviceName"]}"

  response = RestClient.get(service_url, headers){|response, request, result| response }
  if response.code == 404
    response = RestClient.put(service_url, service_data.to_json, headers){|response, request, result| response }
    response.code.should == 201
  else
    response = RestClient.post(service_url, service_data.to_json, headers){|response, request, result| response }
    response.code.should == 200
  end
end

Given /^The test suppliers have services$/ do
    create_service(11111,"1123456789012346","iaas")
    create_service(11111,"1123456789012347","paas")
    create_service(11111,"1123456789012348","saas")
    create_service(11111,"1123456789012349","scs")
    create_service(11111,"1123456789012350","iaas")
    create_service(11111,"1123456789012351","paas")
    create_service(11111,"1123456789012352","saas")
    create_service(11111,"1123456789012353","scs")
    create_service(11112,"1123456789012354","iaas")
end

def create_user (supplierid,email,username)
  file = File.read("./fixtures/test-supplier-user.json")
  json = JSON.parse(file)

  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  user_data = JSON.parse(file)
  user_data ["users"]["supplierId"] = supplierid
  user_data ["users"]["emailAddress"] = email
  user_data ["users"]["name"] = username
  user_url = "#{url}/users?email_address=#{email}"

  response = RestClient.get(user_url, headers){|response, request, result| response }
  if response.code == 404
    user_url = "#{url}/users"
    response = RestClient.post(user_url, user_data.to_json, headers){|response, request, result| response }
    response.code.should == 201
  end
end

And /^The test suppliers have users$/ do
  create_user(11111,"Testing.supplier.USERNaMe@DMtestemail.com","DM Functional Test Supplier User 1")
  create_user(11111,"testing.supplier.username2@dmtestemail.com","DM Functional Test Supplier User 2")
  create_user(11111,"testing.supplier.username3@dmtestemail.com","DM Functional Test Supplier User 3")
  create_user(11112,"testing.supplier2.username@dmtestemail.com","DM Functional Test Supplier2 User 1")
end

def activate_deactive_users (user_name)
  button_action = find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//button[text()]").text()
  if button_action == 'Activate'
    find(:xpath, "//*/span[contains(text(),'#{user_name}')]/../../td/*//button[contains(text(),'#{button_action}')]").click
  end
end

And /^Test supplier users are active$/ do
  step "Given I have logged in to Digital Marketplace as a 'Administrator' user"
  page.visit("#{dm_frontend_domain}/admin/suppliers/users?supplier_id=11111")
  activate_deactive_users("DM Functional Test Supplier User 2")
end

And /^The user 'DM Functional Test Supplier User 3' is locked$/ do
  visit("#{dm_frontend_domain}/suppliers/login")

  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  user_url = "#{url}/users?email_address=testing.supplier.username3@dmtestemail.com"

  response = RestClient.get(user_url, headers){|response, request, result| response }
  failedlogincount = JSON.parse(response.body)["users"][0]["failedLoginCount"]
  lockstate = JSON.parse(response.body)["users"][0]["locked"]

  while failedlogincount < 6 and lockstate == false
    fill_in('email_address', :with => (eval "dm_supplier3_uname"))
    fill_in('password', :with => 'invalidpassword')
    click_link_or_button('Log in')
    failedlogincount += 1
  end
end

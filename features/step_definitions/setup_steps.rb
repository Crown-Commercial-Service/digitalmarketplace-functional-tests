# encoding: utf-8
require "rubygems"
require "rest_client"
require "json"
require "test/unit"


SUPPLIERS_JSON = '
{
   "suppliers":
      {
         "id":11111,
         "name":"DM Functional Test Supplier",
         "description":"This is a test supplier, which will be used solely for the purpose of running functional test.",
         "contactInformation": [
             {
               "website": "www.dmfunctionaltestsupplier.com",
               "contactName": "Testing Supplier Name",
               "email": "Testing.supplier.NaMe@DMtestemail.com",
               "phoneNumber": "+44 (0) 123456789",
               "address1": "125 Kingsway",
               "city": "London",
               "country": "United Kingdom",
               "postcode": "WC2B 6NH"
             }
           ],
         "dunsNumber":"930123456789",
         "clients": [
           "First client",
           "Second client",
           "3rd client",
           "Client 4"
         ]
      }
}
'

Given /^I have a test supplier$/ do
    url = dm_api_domain
    token = dm_api_access_token
    response = RestClient.put(url + "/suppliers/11111", SUPPLIERS_JSON,
                              {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
                              ){|response, request, result| response }  # Don't raise exceptions but return the response
    response.code.should == 201
end

Given /^The test supplier has a service$/ do
    create_service("1123456789012346","iaas")
end

def create_user (email,username)
  file = File.read("./fixtures/test-supplier-user.json")
  json = JSON.parse(file)

  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  user_data = JSON.parse(file)
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

And /^The test supplier has multiple users$/ do
  create_user("Testing.supplier.USERNaMe@DMtestemail.com","DM Functional Test Supplier User 1")
  create_user("testing.supplier.username2@dmtestemail.com","DM Functional Test Supplier User 2")
  create_user("testing.supplier.username3@dmtestemail.com","DM Functional Test Supplier User 3")
end

def create_service (service_id, lot)
  file = File.read("./fixtures/g6-#{lot}-test-service.json")
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

Given /^The test supplier has multiple services$/ do
    create_service("1123456789012346","iaas")
    create_service("1123456789012347","paas")
    create_service("1123456789012348","saas")
    create_service("1123456789012349","scs")
    create_service("1123456789012350","iaas")
    create_service("1123456789012351","paas")
    create_service("1123456789012352","saas")
    create_service("1123456789012353","scs")
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

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

USERS_JSON = '
{
    "users":
      {
          "name": "Testing.supplier.USERNaMe@DMtestemail.com",
          "password": "testuserpassword",
          "emailAddress": "Testing.supplier.USERNaMe@DMtestemail.com",
          "supplierId": 11111,
          "role": "supplier"
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

And /^The test supplier has a user$/ do
  url = dm_api_domain
  token = dm_api_access_token
  headers = {:content_type => :json, :accept => :json, :authorization => "Bearer #{token}"}
  users_data = JSON.parse(USERS_JSON)
  email = users_data ["users"]["emailAddress"]
  user_url = "#{url}/users?email=#{email}"

  response = RestClient.get(user_url, headers){|response, request, result| response }
  if response.code != 200
    user_url = "#{url}/users"
    response = RestClient.post(user_url, USERS_JSON, headers){|response, request, result| response }
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

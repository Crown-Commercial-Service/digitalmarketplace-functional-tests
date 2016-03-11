# encoding: utf-8
require "rubygems"
require "rest_client"
require "json"
require "test/unit"

# suppliers
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

# services
def create_live_service (supplier_id, service_id, framework, lot)
  file = File.read("./fixtures/#{framework}-#{lot}-service.json")
  service_data = JSON.parse(file)
  service_data["services"]["id"] = service_id
  service_data["services"]["supplierId"] = supplier_id
  service_data["services"]["serviceName"] = "#{service_id} #{service_data["services"]["serviceName"]}" if framework.start_with? "g-cloud"

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
  create_live_service(11111, "1123456789012346", "g-cloud-6", "iaas")
  create_live_service(11111, "1123456789012347", "g-cloud-6", "paas")
  create_live_service(11111, "1123456789012348", "g-cloud-6", "saas")
  create_live_service(11111, "1123456789012349", "g-cloud-6", "scs")
  create_live_service(11111, "1123456789012350", "g-cloud-6", "iaas")
  create_live_service(11111, "1123456789012351", "g-cloud-6", "paas")
  create_live_service(11111, "1123456789012352", "g-cloud-6", "saas")
  create_live_service(11111, "1123456789012353", "g-cloud-6", "scs")
  create_live_service(11112, "1123456789012354", "g-cloud-6", "iaas")
end

Given /^Test suppliers are eligible to respond to a brief$/ do
  create_live_service(11111, "2123456789012354", "digital-outcomes-and-specialists", "digital-specialists")
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

# users
def create_and_return_user (email,username,password,role,supplierid=nil)
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
  user = JSON.parse(response.body)["users"][0]
  return user
end

def create_supplier_user (supplierid,email,username,password)
  return create_and_return_user(email,username,password,"supplier",supplierid)
end

def create_buyer_user (email,username,password)
  return create_and_return_user(email,username,password,"buyer")
end

def create_buyer_user (email,username,password)
  create_user(email,username,password,"buyer")
end

def create_admin_user (email,username,password)
  return create_and_return_user(email,username,password,"admin")
end

And /^The test suppliers have users$/ do
  create_supplier_user(11111,dm_supplier_user_email(),"DM Functional Test Supplier User 1", dm_supplier_password())
  create_supplier_user(11111,dm_supplier_user2_email(),"DM Functional Test Supplier User 2", dm_supplier_password())
  create_supplier_user(11111,dm_supplier_user3_email(),"DM Functional Test Supplier User 3", dm_supplier_password())
  create_supplier_user(11112,dm_supplier2_user_email(),"DM Functional Test Supplier 2 User 1", dm_supplier_password())
end

Given /^I have a buyer user account$/ do
  user = create_buyer_user(dm_buyer_email(),"DM Functional Test Buyer User 1", dm_buyer_password())
  @buyer_id = user["id"]
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

def activate_users (email)
  button = find(
    :xpath,
    "//span[contains(text(), '#{email}')]/../../td//form[contains(@action, 'activate')]/input[contains(@type, 'submit')]"
  )
  if button.value == 'Activate'
    button.click
  end
end

And /^Test supplier users are active$/ do
  steps %Q{
    Given I have logged in to Digital Marketplace as a 'Administrator' user
    Then I am presented with the admin search page
  }
  page.visit("#{dm_frontend_domain}/admin/suppliers/users?supplier_id=11111")
  dm_supplier_user_emails().each do |email|
    activate_users(email)
  end
end

def unlock_users (email)
  row = find(
    :xpath,
    "//span[contains(text(), '#{email}')]/../.."
  )
  if not row.find(:xpath, 'td[5]').has_content?('No')
    row.find(:xpath, "td//input[contains(@type, 'submit') and contains(@value, 'Unlock')]").click
  end
end

And /^Test supplier users are not locked$/ do
  steps %Q{
    Given I have logged in to Digital Marketplace as a 'Administrator' user
    Then I am presented with the admin search page
  }
  page.visit("#{dm_frontend_domain}/admin/suppliers/users?supplier_id=11111")
  dm_supplier_user_emails().each do |email|
    unlock_users(email)
  end
end

And /^The user 'DM Functional Test Supplier User 3' is locked$/ do
  visit("#{dm_frontend_domain}/login")

  response = call_api(:get, "/users", params: {email_address: dm_supplier_user3_email()})
  failedlogincount = JSON.parse(response.body)["users"][0]["failedLoginCount"]
  lockstate = JSON.parse(response.body)["users"][0]["locked"]

  while failedlogincount < 6 and lockstate == false
    fill_in('email_address', :with => dm_supplier_user3_email())
    fill_in('password', :with => 'invalidpassword')
    click_button('Log in')
    failedlogincount += 1
  end
end

# briefs
def create_and_return_buyer_brief (brief_name, framework_slug, lot, user_id)
  file = File.read("./fixtures/briefs-DOS.json")
  brief_data = JSON.parse(file)
  brief_data["briefs"]["title"] = brief_name
  brief_data["briefs"]["location"] = "Scotland"
  brief_data["briefs"]["frameworkSlug"] = framework_slug
  brief_data["briefs"]["lot"] = lot
  brief_data["briefs"]["userId"] = user_id
  brief_data["briefs"]["startDate"] = '31/12/2016'
  brief_data["briefs"]["specialistRole"] = 'developer'
  brief_data["briefs"]["organisation"] = 'Driver and Vehicle Licensing Agency'
  brief_data["briefs"]["importantDates"] = 'Yesterday'
  brief_data["briefs"]["evaluationType"] = ['pitch']
  brief_data["briefs"]["contractLength"] = '1 day'
  brief_data["briefs"]["backgroundInformation"] = 'Make a flappy bird clone except where the bird drives very safely'
  brief_data["briefs"]["essentialRequirements"] = ['Can you do coding?', 'Can you do Python?']
  brief_data["briefs"]["niceToHaveRequirements"] = ['Do you like cats?', 'Is your cat named Eva?']
  brief_data["updated_by"] = "functional tests"

  response = call_api(:post, "/briefs", payload: brief_data)
  response.code.should be(201), response.body
  brief = JSON.parse(response.body)["briefs"]
  return brief
end

def publish_buyer_brief(brief_id)
  publish_brief_data = {
    updated_by: "functional tests",
    briefs: {status: "live"}
  }
  response = call_api(:put, "/briefs/#{brief_id}/status", payload: publish_brief_data)
  response.code.should be(200), response.body
end


def delete_all_draft_briefs (user_id)
  response = call_api(:get, "/briefs", params: {user_id: user_id})

  JSON.parse(response.body)["briefs"].each do |brief|
    brief_id = brief["id"]
    updated_by = {updated_by: "Functional tests"}

    if brief["status"] != "live"
      puts "deleting draft: #{brief_id}"
      response = call_api(:delete, "/briefs/#{brief_id}", payload: updated_by)
      response.code.should be(200), response.body
    end
  end
end

Given /^I have a '(.*)' brief$/ do |brief_state|
  if not @buyer_id
    fail(ArgumentError.new('No buyer user found!!'))
  end
  @published_brief = create_and_return_buyer_brief("Individual Specialist-Brief deletion test", "digital-outcomes-and-specialists", "digital-specialists", @buyer_id)

  if brief_state == 'published'
    publish_buyer_brief(@published_brief['id'])
  end
end

Given /^I have deleted all draft briefs$/ do
  if not @buyer_id
    fail(ArgumentError.new('No buyer user found!!'))
  end
  delete_all_draft_briefs(@buyer_id)
end
#@wip-create a buyer brief
def create_buyer_brief (brief_name,framework_slug,lot,user_id)
  file = File.read("./fixtures/briefs-DOS.json")
  brief_data = JSON.parse(file)
  brief_data["briefs"]["title"] = brief_name
  brief_data["briefs"]["location"] = "Scotland"
  brief_data["briefs"]["frameworkSlug"] = framework_slug
  brief_data["briefs"]["lot"] = lot
  brief_data["briefs"]["userId"] = user_id

  response = call_api(:get, "/briefs", params: {user_id: user_id})
  # puts response.body
  JSON.parse(response.body)["briefs"].each do |brief|
    puts brief["title"]
  end
  puts response.code
  if response.code == 404
    puts 'in here'
    response = call_api(:post, "/briefs", payload: brief_data)
    response.code.should be(201), response.body
  end
end
#@wip-create a buyer brief
Given /^I have a draft brief$/ do
  #delete all existing draft briefs first
  delete_all_draft_briefs("10349")
  create_buyer_brief("Individual Specialist-Brief deletion test","digital-outcomes-and-specialists","digital-specialists",10349)
end

def delete_all_draft_briefs (user_id)
  response = call_api(:get, "/briefs", params: {user_id: user_id})

  JSON.parse(response.body)["briefs"].each do |brief|
    puts brief["id"]
    brief_id = brief["id"]

    updated_by = JSON.parse("{\"updated_by\":\"Functional tests\"}").to_json

    if brief["status"] != "live"
      puts "#{brief_id}"
      response = call_api(:delete, "/briefs/#{brief_id}", payload: updated_by)
      puts response
      response.code.should be(200), response.body
    end
  end
end

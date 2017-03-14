require "rest_client"

def call_api(method, path, options={})
  domain = options.delete(:domain) || dm_api_domain
  auth_token = options.delete(:auth_token) || dm_api_access_token
  url = "#{domain}#{path}"
  payload = options.delete(:payload)
  options.merge!({
    content_type: :json,
    accept: :json,
    authorization: "Bearer #{auth_token}"
  })
  if payload.nil?
    RestClient.send(method, url, options) {|response, request, result| response}
  else
    # can't send a payload as part of a DELETE request using the ruby rest client
    # http://stackoverflow.com/questions/21104232/delete-method-with-a-payload-using-ruby-restclient
    if method == :delete
      RestClient::Request.execute(method: :delete, url: url, payload: payload.to_json, headers: options) {|response, request, result| response}
    else
      RestClient.send(method, url, payload.to_json, options) {|response, request, result| response}
    end
  end
end

def _error(response, message)
  "#{message}\n#{response.code} - #{response.body}"
end

def update_framework_status(framework_slug, status)
  response = call_api(:get, "/frameworks/#{framework_slug}")
  framework = JSON.parse(response.body)["frameworks"]
  if framework['status'] != status
    response = call_api(:post, "/frameworks/#{framework_slug}", payload: {
      frameworks: {status: status, clarificationQuestionsOpen: status == 'open'},
      updated_by: "functional tests",
    })
    response.code.should be(200), _error(response, "Failed to update framework status #{framework_slug} #{status}")
  end
  return framework['status']
end

def get_user_by_email(email_address)
  response = call_api(:get, "/users", params: {email_address: email_address})
  response.code.should be(200), _error(response, "Failed get details for user #{email_address}")
  users = JSON.parse(response.body)['users']
  users.length.should be(1)
  return users[0]
end

def ensure_user_exists(user_details)
  creation_response = call_api(:post, "/users", payload: {
    users: user_details,
    updated_by: "functional tests",
  })
  if creation_response.code == 409
    # user with this email already exists - let's see if we have the right password...
    auth_response = call_api(:post, "/users/auth", payload: {
      authUsers: {
        emailAddress: user_details['emailAddress'],
        password: user_details['password'],
      },
    })
    unless auth_response.code == 200
      # before we show our failure message we should reset the failed login count so we don't end up locking
      # ourselves out (due to the automated nature of this it would be very easy to do in one run). but to do that we
      # need to discover the user id to target...
      user = get_user_by_email(user_details['emailAddress'])
      reset_failed_login_response = call_api(:post, "/users/#{user['id']}", payload: {
        users: {locked: false},
        updated_by: "functional tests",
      })
      reset_failed_login_response.code.should be(200), _error(reset_failed_login_response, "Failed to ensure user #{user_details['emailAddress']} exists")
      # this should definitely fail now
      auth_response.code.should be(200), _error(auth_response, "User #{user_details['emailAddress']} exists but we couldn't authenticate as them. Does our password agree with the one on the server?")
    end
  else
    creation_response.code.should be(201), _error(creation_response, "Failed to ensure user #{user_details['emailAddress']} exists")
  end
  return get_user_by_email(user_details['emailAddress'])
end

def ensure_no_framework_agreements_exist(framework_slug)
  response = call_api(:get, "/frameworks/#{framework_slug}/suppliers")
  response.code.should be(200), _error(response, "Failed to get framework #{framework_slug}")
  supplier_frameworks = JSON.parse(response.body)["supplierFrameworks"]
  supplier_frameworks.each do |supplier_framework|
    update_framework_agreement_status(framework_slug, supplier_framework["supplierId"], false)
  end
end

def update_framework_agreement_status(framework_slug, supplier_id, status)
  response = call_api(:post, "/suppliers/#{supplier_id}/frameworks/#{framework_slug}", payload: {
    frameworkInterest: {agreementReturned: status},
    updated_by: "functional tests",
  })
  response.code.should be(200), _error(response, "Failed to update agreement status #{supplier_id} #{framework_slug}")
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, payload: {
      updated_by: "functional tests"
    })
    response.code.should match(/20[01]/), _error(response, "Failed to register interest in framework #{framework_slug} #{supplier_id}")
  end
end

def submit_supplier_declaration(framework_slug, supplier_id, declaration)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration"
  response = call_api(:put, path, payload: {
    declaration: declaration,
    updated_by: "functional tests",
  })
  [200, 201].should include(response.code), _error(response, "Failed to submit supplier declaration #{framework_slug} #{supplier_id}")
  JSON.parse(response.body)['declaration']
end

def create_brief(framework_slug, lot_slug, user_id)  
  brief_data = {
    updated_by: "functional tests"
  }
  case lot_slug
  when 'digital-specialists'
    brief_data['briefs'] = Fixtures::DIGITAL_SPECIALISTS_BRIEF
  when 'digital-outcomes'
    brief_data['briefs'] = Fixtures::DIGITAL_OUTCOMES_BRIEF
  when 'user-research-participants'
    brief_data['briefs'] = Fixtures::USER_RESEARCH_PARTICIPANTS_BRIEF
  else
    puts 'Lot slug not recognised'
  end

  brief_data['briefs']['userId'] = user_id
  brief_data['briefs']['frameworkSlug'] = framework_slug

  response = call_api(:post, '/briefs', payload: brief_data)
  response.code.should be(201), _error(response, "Failed to create brief for #{lot_slug}, #{user_id}")
  JSON.parse(response.body)['briefs']['id']
end

def create_brief_response(lot_slug, brief_id, supplier_id)
  brief_response_data = {
    updated_by: "functional tests"
  }
  case lot_slug
  when 'digital-specialists'
    brief_response_data['briefResponses'] = Fixtures::DIGITAL_SPECIALISTS_BRIEF_RESPONSE
  else
    puts 'Lot slug not recognised'
  end

  brief_response_data['briefResponses']['briefId'] = brief_id
  brief_response_data['briefResponses']['supplierId'] = supplier_id

  response = call_api(:post, '/brief-responses', payload: brief_response_data)
  response.code.should be(201), _error(response, "Failed to create brief response for #{lot_slug}, #{brief_id}")
  JSON.parse(response.body)['briefResponses']['id']
end

def publish_brief(brief_id)
  path = "/briefs/#{brief_id}/publish"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests"
  })
  response.code.should be(200), _error(response, "Failed to publish brief #{brief_id}")
  JSON.parse(response.body)['briefs']
end

def create_supplier
  random_string = SecureRandom.hex

  response = call_api(:post, "/suppliers", payload: {
    updated_by: "functional tests",
    suppliers: {
      name: 'functional test supplier ' + random_string,
      dunsNumber: rand(9999999999).to_s,
      contactInformation: [
        {
          contactName: random_string,
          email: random_string + "-supplier@user.dmdev",
          phoneNumber: '%010d' % rand(10 ** 11 -1),
        }
      ]
    }
  })
  response.code.should be(201), _error(response, "Failed to create supplier")
  JSON.parse(response.body)['suppliers']
end

def create_live_service(framework_slug, lot_slug, supplier_id, role=nil)
  # Create a 15 digit service ID, miniscule clash risk
  start = 10 ** 14
  last = 10 ** 15 - 1
  random_service_id = rand(start..last).to_s

  service_data = {
    updated_by: 'functional_tests',
  }

  case lot_slug
    when 'digital-specialists'
      service_data['services'] = Fixtures::DIGITAL_SPECIALISTS_SERVICE
    when 'digital-outcomes'
      service_data['services'] = Fixtures::DIGITAL_OUTCOMES_SERVICE
    when 'user-research-participants'
      service_data['services'] = Fixtures::USER_RESEARCH_PARTICIPANTS_SERVICE
    else
      puts 'Lot slug not recoginsed'
  end

  # Set attributes not included in the fixture
  service_data['services']['id'] = random_service_id
  service_data['services']['supplierId'] = supplier_id
  service_data['services']['frameworkSlug'] = framework_slug

  if lot_slug == 'digital-specialists' and role
    # Override the specialist role from the fixture by removing the old developer keys and adding keys
    # for the new role using the original developer values
    service_data['services']["#{role}Locations".to_sym] = service_data['services'].delete(:developerLocations)
    service_data['services']["#{role}PriceMax".to_sym] = service_data['services'].delete(:developerPriceMax)
    service_data['services']["#{role}PriceMin".to_sym] = service_data['services'].delete(:developerPriceMin)
  end

  service_path = "/services/#{random_service_id}"
  response = call_api(:put, service_path, payload: service_data)
  response.code.should be(201), response.body
  JSON.parse(response.body)['services']
end

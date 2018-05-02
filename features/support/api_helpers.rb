require "rest_client"

def call_api(method, path, options = {})
  safe_for_smoke_tests = options.delete(:safe_for_smoke_tests)
  if @SMOKE_TESTS && method != :get && !safe_for_smoke_tests
    raise "Unsafe API request in smoke tests. Only GET methods are allowed"
  end
  domain = options.delete(:domain) || dm_api_domain
  auth_token = options.delete(:auth_token) || dm_api_access_token
  url = "#{domain}#{path}"
  payload = options.delete(:payload)
  options.merge!(
    content_type: :json,
    accept: :json,
    authorization: "Bearer #{auth_token}"
  )
  if payload.nil?
    RestClient.send(method, url, options) { |response, request, result| response }
  else
    # can't send a payload as part of a DELETE request using the ruby rest client
    # http://stackoverflow.com/questions/21104232/delete-method-with-a-payload-using-ruby-restclient
    if method == :delete
      RestClient::Request.execute(method: :delete, url: url, payload: payload.to_json, headers: options) { |response, request, result| response }
    else
      RestClient.send(method, url, payload.to_json, options) { |response, request, result| response }
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
      frameworks: { status: status, clarificationQuestionsOpen: status == 'open' },
      updated_by: "functional tests",
    })
    expect(response.code).to eq(200), _error(response, "Failed to update framework status #{framework_slug} #{status}")
  end
  framework['status']
end

def get_user_by_email(email_address)
  response = call_api(:get, "/users", params: { email_address: email_address })
  expect(response.code).to eq(200), _error(response, "Failed get details for user #{email_address}")
  users = JSON.parse(response.body)['users']
  expect(users.length).to eq(1)
  users[0]
end

def ensure_user_exists(user_details)
  creation_response = call_api(:post, "/users", payload: {
    users: user_details,
    updated_by: "functional tests",
  }, safe_for_smoke_tests: true)
  if creation_response.code == 409
    # user with this email already exists - let's see if we have the right password...
    auth_response = call_api(:post, "/users/auth", payload: {
      authUsers: {
        emailAddress: user_details['emailAddress'],
        password: user_details['password'],
      },
    }, safe_for_smoke_tests: true)
    unless auth_response.code == 200
      # before we show our failure message we should reset the failed login count so we don't end up locking
      # ourselves out (due to the automated nature of this it would be very easy to do in one run). but to do that we
      # need to discover the user id to target...
      user = get_user_by_email(user_details['emailAddress'])
      reset_failed_login_response = call_api(:post, "/users/#{user['id']}", payload: {
        users: { locked: false },
        updated_by: "functional tests",
      }, safe_for_smoke_tests: true)
      expect(reset_failed_login_response.code).to eq(200), _error(reset_failed_login_response, "Failed to ensure user #{user_details['emailAddress']} exists")
      # this should definitely fail now
      expet(auth_response.code).to eq(200), _error(auth_response, "User #{user_details['emailAddress']} exists but we couldn't authenticate as them. Does our password agree with the one on the server?")
    end
  else
    expect(creation_response.code).to eq(201), _error(creation_response, "Failed to ensure user #{user_details['emailAddress']} exists")
  end
  get_user_by_email(user_details['emailAddress'])
end

def ensure_no_framework_agreements_exist(framework_slug)
  response = call_api(:get, "/frameworks/#{framework_slug}/suppliers")
  expect(response.code).to eq(200), _error(response, "Failed to get framework #{framework_slug}")
  supplier_frameworks = JSON.parse(response.body)["supplierFrameworks"]
  supplier_frameworks.each do |supplier_framework|
    set_supplier_on_framework(framework_slug, supplier_framework["supplierId"], false)
  end
end

def set_supplier_on_framework(framework_slug, supplier_id, status)
  response = call_api(:post, "/suppliers/#{supplier_id}/frameworks/#{framework_slug}", payload: {
    frameworkInterest: { onFramework: status },
    updated_by: "functional tests",
  })
  expect(response.code).to eq(200), _error(response, "Failed to update agreement status #{supplier_id} #{framework_slug}")
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, payload: {
      updated_by: "functional tests"
    })
    expect(response.code).to match(/20[01]/), _error(response, "Failed to register interest in framework #{framework_slug} #{supplier_id}")
  end
end

def submit_supplier_declaration(framework_slug, supplier_id, declaration)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration"
  response = call_api(:put, path, payload: {
    declaration: declaration,
    updated_by: "functional tests",
  })
  expect([200, 201]).to include(response.code), _error(response, "Failed to submit supplier declaration #{framework_slug} #{supplier_id}")
  JSON.parse(response.body)['declaration']
end

def sign_framework_agreement(framework_slug, supplier_id, supplier_user_id)
  path = "/agreements"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests",
    agreement: {
      supplierId: supplier_id,
      frameworkSlug: framework_slug
    }
  })
  agreement = JSON.parse(response.body)['agreement']
  path = "/agreements/#{agreement['id']}"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests",
    agreement: {
      signedAgreementPath: 'test',
    }
  })
  path = "/agreements/#{agreement['id']}/sign"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests",
    agreement: {
      signedAgreementDetails: {
        signerName: "answer_required",
        signerRole: "answer_required",
        uploaderUserId: supplier_user_id
      }
    }
  })
end

def get_brief(brief_id)
  response = call_api(:get, "/briefs/#{brief_id}")
  JSON.parse(response.body)['briefs']
end

def get_briefs(framework_slug, status)
  params = { status: status, framework: framework_slug, with_users: 'True' }
  response = call_api(:get, '/briefs', params: params)
  JSON.parse(response.body)['briefs']
end

def get_brief_responses(framework_slug, brief_response_status, brief_status)
  params = { status: brief_response_status, framework: framework_slug }
  response = call_api(:get, '/brief-responses', params: params)
  brief_response_list = JSON.parse(response.body)['briefResponses']
  brief_response_list = brief_response_list.select { |x| x['brief']['status'] == brief_status }

  # If we have not found any required brief responses so far on the first page then we will iterate
  # through the pages until we do find atleast one
  next_page = 2;
  while brief_response_list.empty? && JSON.parse(response.body)['links']['next']
    response = call_api(:get, "/brief-responses?page=#{next_page}", params: params)
    brief_response_list = JSON.parse(response.body)['briefResponses']
    brief_response_list = brief_response_list.select { |x| x['brief']['status'] == brief_status }
    next_page += 1
  end

  brief_response_list
end

def create_brief(framework_slug, lot_slug, user_id)
  brief_data = {
    updated_by: "functional tests"
  }
  case lot_slug
  when 'digital-specialists'
    brief_data['briefs'] = Fixtures.digital_specialists_brief
  when 'digital-outcomes'
    brief_data['briefs'] = Fixtures.digital_outcomes_brief
  when 'user-research-participants'
    brief_data['briefs'] = Fixtures.user_research_participants_brief
  else
    puts 'Lot slug not recognised'
  end

  brief_data['briefs']['userId'] = user_id
  brief_data['briefs']['frameworkSlug'] = framework_slug

  response = call_api(:post, '/briefs', payload: brief_data)
  expect(response.code).to eq(201), _error(response, "Failed to create brief for #{lot_slug}, #{user_id}")
  JSON.parse(response.body)['briefs']
end

def create_brief_response(lot_slug, brief_id, supplier_id)
  brief_response_data = {
    updated_by: "functional tests"
  }
  case lot_slug
  when 'digital-specialists'
    brief_response_data['briefResponses'] = Fixtures.digital_specialists_brief_response
  else
    puts 'Lot slug not recognised'
  end

  brief_response_data['briefResponses']['briefId'] = brief_id
  brief_response_data['briefResponses']['supplierId'] = supplier_id

  response = call_api(:post, '/brief-responses', payload: brief_response_data)
  expect(response.code).to eq(201), _error(response, "Failed to create brief response for #{lot_slug}, #{brief_id}")
  JSON.parse(response.body)['briefResponses']['id']
end

def submit_brief_response(brief_response_id)
  response = call_api(:post, "/brief-responses/#{brief_response_id}/submit", payload: { updated_by: "functional tests" })
  expect(response.code).to eq(200), _error(response, "Failed to submit brief response for #{brief_response_id}")
end

def publish_brief(brief_id)
  path = "/briefs/#{brief_id}/publish"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests"
  })
  expect(response.code).to eq(200), _error(response, "Failed to publish brief #{brief_id}")
  JSON.parse(response.body)['briefs']
end

def withdraw_brief(brief_id)
  path = "/briefs/#{brief_id}/withdraw"
  response = call_api(:post, path, payload: {
    updated_by: "functional tests"
  })
  expect(response.code).to eq(200), _error(response, "Failed to withdraw brief #{brief_id}")
  JSON.parse(response.body)['briefs']
end

def create_supplier(custom_supplier_data = {})
  random_string = SecureRandom.hex
  supplier_data = {
    name: 'functional test supplier ' + random_string,
    dunsNumber: rand(9999999999).to_s,
    contactInformation: [{
      contactName: random_string,
      email: random_string + "-supplier@example.com",
      phoneNumber: '%010d' % rand(10 ** 11 -1),
    }]
  }
  supplier_data.update(custom_supplier_data)
  response = call_api(
    :post,
    "/suppliers",
    payload: { updated_by: "functional tests", suppliers: supplier_data }
  )
  expect(response.code).to eq(201), _error(response, "Failed to create supplier")
  JSON.parse(response.body)['suppliers']
end

def create_live_service(framework_slug, lot_slug, supplier_id, role = nil)
  # Create a 15 digit service ID, miniscule clash risk
  start = 10 ** 14
  last = 10 ** 15 - 1
  random_service_id = rand(start..last).to_s

  service_data = {
    updated_by: 'functional_tests',
  }

  case lot_slug
    when 'digital-specialists'
      service_data['services'] = Fixtures.digital_specialists_service
    when 'digital-outcomes'
      service_data['services'] = Fixtures.digital_outcomes_service
    when 'user-research-participants'
      service_data['services'] = Fixtures.user_research_participants_service
    when 'user-research-studios'
      service_data['services'] = Fixtures.user_research_studios_service
    when 'cloud-support'
      service_data['services'] = Fixtures.cloud_support_service
    else
      puts 'Lot slug not recoginsed'
  end

  # Set attributes not included in the fixture
  service_data['services']['id'] = random_service_id
  service_data['services']['supplierId'] = supplier_id
  service_data['services']['frameworkSlug'] = framework_slug

  if (lot_slug == 'digital-specialists') && role
    # Override the specialist role from the fixture by removing the old developer keys and adding keys
    # for the new role using the original developer values
    service_data['services']["#{role}Locations".to_sym] = service_data['services'].delete(:developerLocations)
    service_data['services']["#{role}PriceMax".to_sym] = service_data['services'].delete(:developerPriceMax)
    service_data['services']["#{role}PriceMin".to_sym] = service_data['services'].delete(:developerPriceMin)
  end

  service_path = "/services/#{random_service_id}"
  response = call_api(:put, service_path, payload: service_data)
  expect(response.code).to eq(201), response.body
  JSON.parse(response.body)['services']
end

def get_frameworks
  frameworks_from_api = call_api(:get, '/frameworks')
  all_frameworks = JSON.parse(frameworks_from_api.body)['frameworks']
end

def get_a_service(status, framework_type = "g-cloud")
  all_frameworks = get_frameworks
  suitable_framework_slugs = []
  all_frameworks.each do |framework|
    if framework["status"] == "live" && framework["framework"] == framework_type
      suitable_framework_slugs << framework["slug"]
    end
  end
  params = { status: status, framework: suitable_framework_slugs[0] }
  services_from_api = call_api(:get, '/services', params: params)
  JSON.parse(services_from_api.body)['services'].sample
end

def create_user(user_role, custom_user_data = {})
  randomString = SecureRandom.hex
  password = ENV["DM_PRODUCTION_#{user_role.upcase.gsub('-', '_')}_USER_PASSWORD"]

  user_data = {
    "emailAddress" => custom_user_data['emailAddress'] || custom_user_data['email_address'] || randomString + '@example.gov.uk',
    "name" => custom_user_data['name'] || "#{user_role.capitalize} Name #{randomString}",
    "password" => password,
    "role" => custom_user_data['role'] || user_role,
    "phoneNumber" => (SecureRandom.random_number(10000000) + 10000000000).to_s,
  }

  user_data['supplierId'] = custom_user_data['supplierId'] || custom_user_data['supplier_id'] || 0  if user_role == 'supplier'

  response = call_api(:post, "/users", payload: { users: user_data, updated_by: 'functional_tests' })
  expect(response.code).to eq(201), response.body
  @user = JSON.parse(response.body)["users"]
  @user['password'] = password
  puts "Email address: #{@user['emailAddress']}"
  @user
end

def get_or_create_supplier(custom_supplier_data)
  # This method is used to search for a supplier, and if it does not exist create that supplier. It will return
  # that supplier and also set it to the global @supplier var.
  # The possible argument combinations for the getting of a supplier are dependent on the available end points for
  # suppliers.
  # Therefore this method supports:
  # id: being the supplier_id of the supplier (and should not be used with any other args as it's a primary key)
  # name: name prefix of the supplier. This may result in unpredictable behaviour if the provided name is not unique.
  # Should the supplier not be found we will attempt a post create with the provided supplier data.
  if custom_supplier_data["id"] != nil
    response = call_api(:get, "/suppliers/#{custom_supplier_data['id']}")
    @supplier = JSON.parse(response.body)["suppliers"]
    return @supplier
  end
  if custom_supplier_data["name"] != nil
    response = call_api(:get, '/suppliers', params: { prefix: custom_supplier_data['name'] })
    @supplier = JSON.parse(response.body)['suppliers'][0]
  end
  if not @supplier
    @supplier = create_supplier(custom_supplier_data)
  end
  @supplier
end

def get_or_create_user(custom_user_data)
  # This method is used to search for a user, and if it does not exist create that user. It will return that user and
  # also sets it to the global @user var.
  # The possible argument combinations for the getting of a user are dependent on the available end points for users.
  # Therefore this method supports:
  # id: being the id of the user (and should not be used with any other args as it's a primary key)
  # email_address: email_address of the account. This can be used independently.
  # supplier_id: supplier id of the user. May result in unpredictable behaviour if there is more than one user with the
  #     supplier_id and an email address is not specified
  # Should the user not be found we will attempt a post create with the provided user data.
  if custom_user_data["id"] != nil
    response = call_api(:get, "/users/#{custom_user_data['id']}")
    @user = JSON.parse(response.body)["users"]
    return @user
  end
  if (custom_user_data["email_address"] != nil) || (custom_user_data["supplier_id"] != nil)
    response = call_api(
      :get,
      "/users",
      params: {
        email_address: custom_user_data['email_address'],
        supplier_id: custom_user_data['supplierId']
      }
    )
    @user = response.code == 200 ? JSON.parse(response.body)["users"][0] : nil
  end
  if not @user
    role = custom_user_data['role'] || (custom_user_data['supplier_id'] ? 'supplier' : 'buyer')
    @user = create_user(role, custom_user_data)
  end
  @user
end

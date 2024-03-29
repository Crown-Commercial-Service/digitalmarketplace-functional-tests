require "rest_client"

def call_api(method, path, options = {})
  safe_for_smoke_tests = options.delete(:safe_for_smoke_tests)
  if (@SMOKE_TESTS || @SMOULDER_TESTS) && method != :get && !safe_for_smoke_tests
    raise "Unsafe API request in smoke/smoulder tests. Only GET methods are allowed"
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

def iter_api(method, path, key, options = {})
  page = 1
  Enumerator.new do |enum|
    loop do
      response = JSON.parse call_api(method, path + "?page=#{page}", options).body
      response.fetch(key).each { |x| enum << x }
      response["links"].key?("next") ? page += 1 : break
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
      expect(auth_response.code).to eq(200), _error(auth_response, "User #{user_details['emailAddress']} exists but we couldn't authenticate as them. Does our password agree with the one on the server?")
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
  expect(response.code).to eq(200), _error(response, "Failed to update supplier_framework status #{supplier_id} #{framework_slug}")
end

def confirm_company_details_for_framework(framework_slug, supplier_id)
  response = call_api(:post, "/suppliers/#{supplier_id}/frameworks/#{framework_slug}", payload: {
    frameworkInterest: { applicationCompanyDetailsConfirmed: true },
    updated_by: "functional tests",
  })
  expect(response.code).to eq(200), _error(response, "Failed to confirm supplier's company details for framework #{supplier_id} #{framework_slug}")
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, payload: {
      updated_by: "functional tests"
    })
    expect(response.code).to be_between(200, 201), _error(response, "Failed to register interest in framework #{framework_slug} #{supplier_id}")
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

def get_briefs(status)
  params = {
    human: 'True',  # sort by latest first
    status: status,
    with_users: 'True',
  }
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

def iter_brief_responses(brief_response_status, brief_status)
  params = {
    human: 'True',  # sort by latest first
    status: brief_response_status,
  }
  Enumerator.new do |enum|
    brief_responses = iter_api(:get, '/brief-responses', 'briefResponses', params: params)
    brief_responses = brief_responses.select { |x| x['brief']['status'] == brief_status }
    brief_responses.each { |x| enum << x }
  end
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
    dunsNumber: 9.times.map { rand(10) }.join,
    contactInformation: [{
      contactName: random_string,
      email: random_string + "-supplier@example.com",
      phoneNumber: '%010d' % rand(10**11 - 1),
      address1: "14 Duke Street",
      city: "Dublin",
      postcode: "H3 LY5",
    }],
    registrationCountry: "country:IE",
  }
  supplier_data.update(custom_supplier_data)

  # the "create supplier" endpoint is restricted in the attributes it will allow to be set at creation time,
  # so we have to separate these out and possibly follow the creation up with an update to set the remaining
  # attributes
  creatable_attrs = {}
  updatable_attrs = {}
  supplier_data.each do |key, value|
    if %i[id companiesHouseNumber contactInformation dunsNumber description name].include? key
      creatable_attrs[key] = value
    else
      updatable_attrs[key] = value
    end
  end

  response = call_api(
    :post,
    "/suppliers",
    payload: { updated_by: "functional tests", suppliers: creatable_attrs }
  )
  expect(response.code).to eq(201), _error(response, "Failed to create supplier")
  parsed_response = JSON.parse(response.body)['suppliers']

  if !updatable_attrs.empty?
    response = call_api(
      :post,
      "/suppliers/#{parsed_response['id']}",
      payload: { updated_by: "functional tests", suppliers: updatable_attrs }
    )
    expect(response.code).to eq(200), _error(response, "Failed to update created supplier with provided attributes")
  end
  JSON.parse(response.body)['suppliers']
end

def update_supplier(supplier_id, data)
  response = call_api(
    :post,
    "/suppliers/#{supplier_id}",
    payload: { updated_by: "functional tests", suppliers: data }
  )
  expect(response.code).to eq(200), _error(response, "Failed to update supplier")
  JSON.parse(response.body)['suppliers']
end

def create_live_service(framework_slug, lot_slug, supplier_id, role = nil)
  # Create a 15 digit service ID, miniscule clash risk
  start = 10**14
  last = 10**15 - 1
  random_service_id = rand(start..last).to_s

  service_data = {
    updated_by: 'functional_tests',
  }

  case lot_slug
    when 'digital-specialists'
      if framework_slug == 'digital-outcomes-and-specialists-4'
        service_data['services'] = Fixtures.digital_specialists_service_dos4
      else
        service_data['services'] = Fixtures.digital_specialists_service
      end
    when 'digital-outcomes'
      if framework_slug == 'digital-outcomes-and-specialists-4'
        service_data['services'] = Fixtures.digital_outcomes_service_dos4
      else
        service_data['services'] = Fixtures.digital_outcomes_service
      end
    when 'user-research-participants'
      service_data['services'] = Fixtures.user_research_participants_service
    when 'user-research-studios'
      if framework_slug == 'digital-outcomes-and-specialists-5'
        service_data['services'] = Fixtures.user_research_studios_service_dos5
      else
        service_data['services'] = Fixtures.user_research_studios_service
      end
    when 'cloud-support'
      service_data['services'] = Fixtures.cloud_support_service
    else
      puts 'Lot slug not recognised'
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

    if framework_slug == 'digital-outcomes-and-specialists-4'
      # Additional service attribute for DOS4 specialists
      service_data['services']["#{role}AccessibleApplications".to_sym] = service_data['services'].delete(:developerAccessibleApplications)
    end
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

def get_a_service(status, framework_type = "g-cloud", must_be_copyable = false, lot_slug = nil)
  all_frameworks = get_frameworks
  suitable_framework_slugs = []
  all_frameworks.each do |framework|
    if framework["status"] == "live" && framework["framework"] == framework_type
      suitable_framework_slugs << framework["slug"]
    end
  end
  params = { status: status, framework: suitable_framework_slugs[0] }
  if !lot_slug.nil?
    params['lot'] = lot_slug
  end

  response = call_api(:get, '/services', params: params)
  service_list = JSON.parse(response.body)['services']

  if must_be_copyable
    # Check if the service has already been used to create a draft service
    service_list = service_list.select { |x| x['copiedToFollowingFramework'] == false }

    # If we have not found any required brief responses so far on the first page then we will iterate
    # through the pages until we do find atleast one
    next_page = 2
    while service_list.empty? && JSON.parse(response.body)['links']['next']
      response = call_api(:get, "/services?page=#{next_page}", params: params)
      service_list = JSON.parse(response.body)["services"]
      service_list = service_list.select { |x| x['copiedToFollowingFramework'] == false }
      next_page += 1
    end
  end

  service_list.sample
end

def create_user(user_role, custom_user_data = {})
  custom_user_data = custom_user_data.camelize(:lower)
  randomString = SecureRandom.hex
  password = ENV["DM_#{user_role.upcase.gsub('-', '_')}_USER_PASSWORD"]

  user_data = {
    "emailAddress" => custom_user_data['emailAddress'] || randomString + '@example.gov.uk',
    "name" => custom_user_data['name'] || "#{user_role.capitalize} Name #{randomString}",
    "password" => password,
    "role" => custom_user_data['role'] || user_role,
    "phoneNumber" => (SecureRandom.random_number(10000000) + 10000000000).to_s,
  }

  user_data['supplierId'] = custom_user_data['supplierId'] || 0  if user_role == 'supplier'

  response = call_api(:post, "/users", payload: { users: user_data, updated_by: 'functional_tests' })
  expect(response.code).to eq(201), response.body

  @user = JSON.parse(response.body)["users"]

  if (custom_user_data['active'] || '').casecmp("false").zero?
    # this can't be specified at creation time so we need to follow up with an update to the user
    @user = update_user(@user['id'], 'active': false)
  end
  @user['password'] = password
  puts "Email address: #{@user['emailAddress']}"
  @user
end

def update_user(user_id, data)
  response = call_api(
    :post,
    "/users/#{user_id}",
    payload: { updated_by: "functional tests", users: data }
  )
  expect(response.code).to eq(200), _error(response, "Failed to update user")
  JSON.parse(response.body)['users']
end

def get_supplier_by_name_starting_with(name_prefix)
  response = call_api(:get, '/suppliers', params: { prefix: name_prefix })
  JSON.parse(response.body)["suppliers"][0]
end

def get_supplier_by_registered_name(registered_name)
  response = call_api(:get, '/suppliers', params: { name: registered_name })
  JSON.parse(response.body)["suppliers"][0]
end

def get_or_create_supplier_with_data(name_prefix, custom_supplier_data)
  # Get the supplier by name or registered name if it exists. This may result in unpredictable behaviour if the provided name is not unique.
  # registered_name is optional.
  # Create the supplier if it does not exist.
  # In any case, ensure the supplier has the supplied data. Return the supplier.
  supplier = get_supplier_by_name_starting_with(name_prefix)

  if custom_supplier_data["registeredName"] != nil
    supplier ||= get_supplier_by_registered_name(custom_supplier_data["registeredName"])
  end

  supplier ||= create_supplier

  update_supplier(supplier['id'], custom_supplier_data)
end

def get_user_by_email_address(email_address)
  response = call_api(
    :get,
    '/users',
    params: { email_address: email_address }
  )
  JSON.parse(response.body).dig("users", 0)
end

def get_or_create_user(custom_user_data)
  # Get the user by email address if they exist. Then ensure the user has
  # the supplied custom data.
  # Create a new user if they do not already exist or if the caller does
  # not provide an email address.
  # In both cases, return the user and set the global `@user` variable.
  custom_user_data = custom_user_data.camelize(:lower)
  if custom_user_data["emailAddress"] != nil
    @user = get_user_by_email_address(custom_user_data["emailAddress"])

    if @user != nil
      @user['password'] = ENV["DM_#{@user['role'].upcase.gsub('-', '_')}_USER_PASSWORD"]

      mismatched_properties = custom_user_data.map.reject do |k, v|
        v == nil || @user[k] == nil || detect_boolean_strings(v) == detect_boolean_strings(@user[k])
      end.to_h

      if mismatched_properties.any?
        @user = update_user(@user['id'], mismatched_properties)
      end

      return @user
    end
  end

  role = custom_user_data['role'] || (custom_user_data['supplierId'] ? 'supplier' : 'buyer')
  @user = create_user(role, custom_user_data)
end

def get_unacknowledged_service_update_audit_events(service_id)
  response = call_api(
    :get,
    "/audit-events",
    params: {
      "object-type": "services",
      "object-id": service_id,
      "latest-first": "true",
      "audit-type": "update_service",
      "acknowledged": "false",
    },
  )
  expect(response.code).to eq(200), response.body
  JSON.parse(response.body)
end

def acknowledge_all_service_updates(service_id)
  listing_response_json = get_unacknowledged_service_update_audit_events(service_id)

  if listing_response_json["auditEvents"].length != 0
    puts "Acknowledging #{listing_response_json['auditEvents'].length} audit events"
    ack_response = call_api(
      :post,
      "/services/#{service_id}/updates/acknowledge",
      payload: {
        "latestAuditEventId": listing_response_json["auditEvents"][0]['id'],
        "updated_by": "functional_tests",
      },
    )
    expect(ack_response.code).to eq(200), ack_response.body
  end
end

def update_service(service_id, service_data, updated_by)
  response = call_api(
    :post,
    "/services/#{service_id}",
    payload: {
      "services": service_data,
      "updated_by": updated_by,
    },
  )
  expect(response.code).to eq(200), response.body
end

def get_supplier_with_reusable_declaration(reuse_for_framework = {})
  # the logic for whether a supplier can reuse a declaration is as follows:
  # for all frameworks
  #   except the one the supplier is applying to
  #   that allow declaration reuse
  #   and are closed
  # find the most recent
  # from https://github.com/alphagov/digitalmarketplace-supplier-frontend/blob/5bb727aa7b4ec852ba98a7f3d16f858609de8cf0/app/main/views/frameworks.py#L414

  reusable_frameworks = (get_frameworks.select { |framework|
    framework['allowDeclarationReuse'] && framework['slug'] != reuse_for_framework['slug']
  }).shuffle

  supplier_framework = nil
  reusable_frameworks.detect do |framework|
    body_json = JSON.parse(call_api(:get, "/frameworks/#{framework['slug']}/suppliers?with_declarations=false").body)
    supplier_framework = body_json['supplierFrameworks'].shuffle.detect do |sf|
      sf['onFramework'] && sf['allowDeclarationReuse']
    end
  end

  expect(supplier_framework).not_to be_nil
  JSON.parse(call_api(:get, "/suppliers/#{supplier_framework['supplierId']}").body)['suppliers']
end

def get_supplier_with_copyable_service(framework, lot_slug = nil)
  @existing_service = get_a_service("published", framework['family'], must_be_copyable = true, lot_slug = lot_slug)
  puts "Service name: #{@existing_service['serviceName']}"
  puts "Service ID: #{@existing_service['id']}"
  puts "Lot name: #{@existing_service['lotName']}"
  JSON.parse(call_api(:get, "/suppliers/#{@existing_service['supplierId']}").body)['suppliers']
end

def remove_supplier_declaration(supplier_id, framework_slug)
  response = call_api(
    :post,
    "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration",
    payload: { updated_by: "functional_tests" },
  )
  expect(response.code).to eq(200), response.body
end

def set_supplier_framework_prefill_declaration(supplier_id, framework_slug, from_framework_slug)
  response = call_api(
    :post,
    "/suppliers/#{supplier_id}/frameworks/#{framework_slug}",
    payload: {
      frameworkInterest: { prefillDeclarationFromFrameworkSlug: from_framework_slug },
      updated_by: "functional_tests",
    },
  )
  expect(response.code).to eq(200), response.body
end

def get_draft_service_copied_from(old_service, framework_slug)
  response = call_api(
    :get,
    "/draft-services",
    params: {
      supplier_id: old_service['supplierId'],
      framework: framework_slug,
    },
  )

  expect(response.code).to eq(200), response.body
  all_services = JSON.parse(response.body)["services"]
  copied_services = all_services.reverse.find_all { |s| s['copiedFromServiceId'] == old_service['id'] }

  # there should only be one, if there are more let the dev know
  expect(copied_services.length).to eq(1), "expected draft service to be copied only once, found #{copied_services.length} copies"

  copied_services[0]
end

def get_direct_award_project(user, project_name)
  response = call_api(
    :get,
    "/direct-award/projects",
    params: {
      "user-id": user["id"],
      "latest-first": true,
    },
  )

  expect(response.code).to eq(200), response.body
  all_projects = JSON.parse(response.body)["projects"]
  all_projects.find { |s| s["name"] == project_name }
end

def create_direct_award_project(user, project_name, search_query)
  response = call_api(
    :post,
    "/direct-award/projects",
    payload: {
      "project": {
        "name": project_name,
        "userId": user["id"]
      },
      "updated_by": "functional tests"
    }
  )

  expect(response.code).to eq(201), response
  project = JSON.parse(response.body)["project"]

  response = call_api(
    :post,
    "/direct-award/projects/#{project['id']}/searches",
    payload: {
      "search": {
        "searchUrl": "#{dm_search_api_domain}/#{@framework['slug']}/services/search?#{search_query}",
        "userId": @user["id"]
      },
      "updated_by": "functional tests"
    }
  )

  expect(response.code).to eq(201), response

  project
end

def export_direct_award_project
  response = call_api(
    :post,
    "/direct-award/projects/#{@project['id']}/lock",
    payload: {
      "updated_by": "functional tests"
    }
  )

  expect(response.code).to eq(200), response
end

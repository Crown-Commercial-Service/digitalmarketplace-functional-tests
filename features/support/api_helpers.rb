require "rest_client"

def call_api(method, path, options={})
  domain = options.delete(:domain) || dm_api_domain
  auth_token = options.delete(:auth_token) || dm_api_access_token
  url = "#{domain}#{path}"
  payload = options.delete(:payload)
  options.merge!({
    :content_type => :json,
    :accept => :json,
    :authorization => "Bearer #{auth_token}"
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
      "frameworks" => {"status" => status, "clarificationQuestionsOpen" => status == 'open'},
      "updated_by" => "functional tests",
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
    "users" => user_details,
    "updated_by" => "functional tests",
  })
  if creation_response.code == 409
    # user with this email already exists - let's see if we have the right password...
    auth_response = call_api(:post, "/users/auth", payload: {
      "authUsers" => {
        "emailAddress" => user_details['emailAddress'],
        "password" => user_details['password'],
      },
    })
    unless auth_response.code == 200
      # before we show our failure message we should reset the failed login count so we don't end up locking
      # ourselves out (due to the automated nature of this it would be very easy to do in one run). but to do that we
      # need to discover the user id to target...
      user = get_user_by_email(user_details['emailAddress'])
      reset_failed_login_response = call_api(:post, "/users/#{user['id']}", payload: {
        "users" => {"locked" => false},
        "updated_by" => "functional tests",
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
    "frameworkInterest" => {"agreementReturned" => status},
    "updated_by" => "functional tests",
  })
  response.code.should be(200), _error(response, "Failed to update agreement status #{supplier_id} #{framework_slug}")
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, payload: {
      "updated_by" => "functional tests"
    })
    response.code.should match(/20[01]/), _error(response, "Failed to register interest in framework #{framework_slug} #{supplier_id}")
  end
end

def submit_supplier_declaration(framework_slug, supplier_id, declaration)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration"
  response = call_api(:put, path, payload: {
    "declaration" => declaration,
    "updated_by" => "functional tests",
  })
  [200, 201].should include(response.code), _error(response, "Failed to submit supplier declaration #{framework_slug} #{supplier_id}")
end

def create_brief(framework_slug, lot_slug, user_id)
  path = "/briefs"
  response = call_api(:post, path, payload: {
    "updated_by" => "functional tests",
    "briefs"=> {
      "frameworkSlug"=> framework_slug,
      "lot"=> lot_slug,
      "userId"=> user_id,
      "requirementsLength" => "2 weeks",
      "culturalWeighting" => 5,
      "workplaceAddress" => "London",
      "culturalFitCriteria" => [
        "Just a great guy gal",
        "blah blah"
      ],
      "technicalWeighting" => 75,
      "numberOfSuppliers" => 3,
      "workingArrangements" => "Hard work",
      "title" => "Tea drinker",
      "location" => "London",
      "summary" => "Drink lots of tea. Brew kettle.",
      "existingTeam" => "Lots of us",
      "specialistWork" => "Drink tea",
      "specialistRole" => "developer",
      "startDate" => "31\/12\/2016",
      "organisation" => "NAO",
      "priceWeighting" => 20,
      "niceToHaveRequirements" => [
        "Talk snobbishly about water quality",
        "Sip quietly", "Provide biscuits"
      ],
      "essentialRequirements" => [
        "Boil kettle",
        "Taste tea",
        "Wash mug",
        "do lots of things and then do some more and lots and lots of those because we require this"
      ]
    }
  })
  response.code.should be(201), _error(response, "Failed to create brief for #{framework_slug}, #{lot_slug}, #{user_id}")
  return JSON.parse(response.body)['briefs']['id']
end

def publish_brief(brief_id)
  path = "/briefs/#{brief_id}/publish"
  response = call_api(:post, path, payload: {
    "updated_by" => "functional tests"
  })
  response.code.should be(200), _error(response, "Failed to publish brief #{brief_id}")
end

def create_supplier()
  path = "/suppliers"
  response = call_api(:post, path, payload: {
    "updated_by" => "functional tests",
    "suppliers"=> {
      "name"=> 'functional test supplier',
      "dunsNumber"=> rand(9999999999).to_s,
      "contactInformation"=> [
        {
          "contactName"=> SecureRandom.hex,
          "email"=> SecureRandom.hex + "-supplier@user.dmdev",
          "phoneNumber"=> '%010d' % rand(10 ** 11 -1),
        }
      ]
    }
  })
  response.code.should be(201), _error(response, "Failed to create supplier")
  supplier = JSON.parse(response.body)['suppliers']
  return supplier
end

def create_live_service(supplier_id)
  # Create a 15 digit service ID, miniscule clash risk
  start = 10 ** 14
  last = 10 ** 15 - 1
  random_service_id = rand(start..last).to_s

  service_path = "/services/#{random_service_id}"
  service_data = {
    "updated_by" => "functional tests",
    "services"=> {
      "id" => random_service_id,
      "supplierId"=> supplier_id,
      "frameworkSlug"=> "digital-outcomes-and-specialists",
      "lot"=> "digital-specialists",
      "developerLocations"=> [
        "London",
        "Scotland"
      ],
      "developerPriceMax"=> "200",
      "developerPriceMin"=> "100",
      "bespokeSystemInformation"=> true,
      "dataProtocols"=> true,
      "helpGovernmentImproveServices"=> true,
      "openStandardsPrinciples"=> true
    }
  }

  response = call_api(:put, service_path, payload: service_data)
  response.code.should be(201), response.body
  puts "created draft service"
  service = JSON.parse(response.body)['services']

  return service
end

def create_declaration(supplier_id, framework_slug)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration"
  response = call_api(:put, path, payload: {
    "updated_by" => "functional tests",
    "declaration"=> {}
  })
  response.code.should be(201), _error(response, "Failed to create declaration")
  declaration = JSON.parse(response.body)['declaration']
  return declaration
end

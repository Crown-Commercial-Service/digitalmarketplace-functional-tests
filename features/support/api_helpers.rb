
def call_api(method, path, options={})
  domain = options.delete(:domain) || dm_api_domain
  url = "#{domain}#{path}"
  payload = options.delete(:payload)
  options.merge!({
    :content_type => :json,
    :accept => :json,
    :authorization => "Bearer #{dm_api_access_token}"
  })
  if payload.nil?
    RestClient.send(method, url, options) {|response, request, result| response}
  else
    RestClient.send(method, url, payload.to_json, options) {|response, request, result| response}
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
      "frameworks" => {"status" => status},
      "updated_by" => "functional tests",
    })
    response.code.should be(200), _error(response, "Failed to update framework status #{framework_slug} #{status}")
  end
  return framework['status']
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
    "update_details" => {"updated_by" => "functional tests"},
  })
  response.code.should be(200), _error(response, "Failed to update agreement status #{supplier_id} #{framework_slug}")
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, payload: {
      "update_details" => {"updated_by" => "functional tests"}
    })
    response.code.should be(200), _error(response, "Failed to register interest in framework #{framework_slug} #{supplier_id}")
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

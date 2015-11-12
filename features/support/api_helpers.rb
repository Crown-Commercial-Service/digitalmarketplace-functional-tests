
def call_api(method, path, payload=nil)
  headers = {
    :content_type => :json,
    :accept => :json,
    :authorization => "Bearer #{dm_api_access_token}"
  }
  url = "#{dm_api_domain}#{path}"
  if payload.nil?
    return RestClient.send(method, url, headers) {|response, request, result| response}
  else
    return RestClient.send(method, url, payload.to_json, headers) {|response, request, result| response}
  end
end

def update_framework_status(framework_slug, status)
  response = call_api(:get, "/frameworks/#{framework_slug}")
  framework = JSON.parse(response.body)["frameworks"]
  if framework['status'] != status
    response = call_api(:post, "/frameworks/#{framework_slug}", {
      "frameworks" => {"status" => status},
      "updated_by" => "functional tests",
    })
    response.code.should == 200
  end
  return framework['status']
end

def ensure_no_framework_agreements_exist(framework_slug)
  response = call_api(:get, "/frameworks/#{framework_slug}/suppliers")
  response.code.should == 200
  supplier_frameworks = JSON.parse(response.body)["supplierFrameworks"]
  supplier_frameworks.each do |supplier_framework|
    update_framework_agreement_status(framework_slug, supplier_framework["supplierId"], false)
  end
end

def update_framework_agreement_status(framework_slug, supplier_id, status)
  response = call_api(:post, "/suppliers/#{supplier_id}/frameworks/#{framework_slug}", {
    "frameworkInterest" => {"agreementReturned" => status},
    "update_details" => {"updated_by" => "functional tests"},
  })
  response.code.should == 200
end

def register_interest_in_framework(framework_slug, supplier_id)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}"
  response = call_api(:get, path)
  if response.code == 404
    response = call_api(:put, path, {
      "update_details" => {"updated_by" => "functional tests"}
    })
    if response.code == 400
      puts(response.body)
    end
  end
end

def submit_supplier_declaration(framework_slug, supplier_id, declaration)
  path = "/suppliers/#{supplier_id}/frameworks/#{framework_slug}/declaration"
  response = call_api(:put, path, {
    "declaration" => declaration,
    "updated_by" => "functional tests",
  })
  [200, 201].should include(response.code)
end

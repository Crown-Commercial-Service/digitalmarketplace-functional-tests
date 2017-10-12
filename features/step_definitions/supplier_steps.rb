Given 'There is at least one framework that can be applied to' do
  response = call_api(:get, "/frameworks")
  response.code.should be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if {|framework| not ['coming', 'open'].include?(framework['status'])}
  if frameworks.empty?
    puts 'SKIPPING as there are no coming or open frameworks'
    skip_this_scenario
  end
end

Given 'There is at most one framework that can be applied to' do
  response = call_api(:get, "/frameworks")
  response.code.should be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if {|framework| not ['coming', 'open'].include?(framework['status'])}
  if frameworks.length > 1
    puts 'SKIPPING as there is more than one framework coming or open'
    skip_this_scenario
  end
end

Given /^that(?: (micro|small|medium|large))? supplier has applied to be on that framework$/ do |organisation_size|
  organisation_size ||= ['micro', 'small', 'medium', 'large'].sample
  submit_supplier_declaration(@framework['slug'], @supplier["id"], {'status': 'complete', 'organisationSize': organisation_size})
end

Given 'we accept that suppliers application to the framework' do
  set_supplier_on_framework(@framework['slug'], @supplier["id"], true)
end

Given 'that supplier returns a signed framework agreement for the framework' do
  sign_framework_agreement(@framework['slug'], @supplier['id'], @supplier_user['id'])
end

Given /^that supplier has a service on the (.*) lot(?: for the (.*) role)?$/ do |lot_slug, role_type|
  @service = create_live_service(@framework['slug'], lot_slug, @supplier["id"], role_type)
end

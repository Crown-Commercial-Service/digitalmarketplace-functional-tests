Given 'There is at least one framework that can be applied to' do
  response = call_api(:get, "/frameworks")
  expect(response.code).to eq(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if { |framework| not %w[coming open].include?(framework['status']) }
  if frameworks.empty?
    puts 'SKIPPING as there are no coming or open frameworks'
    skip_this_scenario
  end
end

Given 'There is at most one framework that can be applied to' do
  response = call_api(:get, "/frameworks")
  expect(response.code).to eq(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if { |framework| not %w[coming open].include?(framework['status']) }
  if frameworks.length > 1
    puts 'SKIPPING as there is more than one framework coming or open'
    skip_this_scenario
  end
end

Given /^there is a framework that is open for applications(?: with clarification questions (open|closed))?$/ do |cq_open_closed|
  response = call_api(:get, "/frameworks")
  expect(response.code).to be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if { |framework| not ['open'].include?(framework['status']) }
  if cq_open_closed
    frameworks.delete_if { |framework| (cq_open_closed == 'open') != framework['clarificationQuestionsOpen'] }
  end
  if frameworks.empty?
    puts "SKIPPING as there are no open frameworks#{if cq_open_closed then " with clarification questions #{cq_open_closed}" end}"
    skip_this_scenario
  else
    @framework = frameworks[0]
    puts "Framework: '#{@framework['slug']}'"
  end
end

Given /^that(?: (micro|small|medium|large))? supplier has applied to be on that framework$/ do |organisation_size|
  organisation_size ||= %w[micro small medium large].sample
  update_supplier(@supplier["id"], 'organisationSize': organisation_size)
  @declaration = submit_supplier_declaration(
    @framework['slug'],
    @supplier["id"],
    'status': 'complete',
    'nameOfOrganisation': 'foobarbaz',
    'primaryContactEmail': 'foo.bar@example.com',
    'supplierCompanyRegistrationNumber': '87654321',
    'supplierRegisteredName': 'DM Functional Test Suppliers Ltd.',
    'supplierRegisteredBuilding': '10 Downing Street',
    'supplierRegisteredCountry': 'country:GB',
    'supplierRegisteredPostcode': 'AB1 2CD',
    'supplierRegisteredTown': 'London',
  )
end

Given 'we accepted that suppliers application to the framework' do
  set_supplier_on_framework(@framework['slug'], @supplier["id"], true)
end

Given 'that supplier has returned a signed framework agreement for the framework' do
  sign_framework_agreement(@framework['slug'], @supplier['id'], @supplier_user['id'])
end

Given /^that supplier has a service on the (.*) lot(?: for the (.*) role)?$/ do |lot_slug, role_type|
  @service = create_live_service(@framework['slug'], lot_slug, @supplier["id"], role_type)
  puts "service id: #{@service['id']}"
end

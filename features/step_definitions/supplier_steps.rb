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
  update_supplier(@supplier["id"],  'organisationSize': organisation_size,
                                    'registeredName': 'DM Functional Test Suppliers Ltd.')
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

Given 'I ensure that all update audit events for that service are acknowledged' do
  acknowledge_all_service_updates(@service['id'])
end

Given /^that service has( no)? unacknowledged update audit events$/ do |negate|
  audit_events_json = get_unacknowledged_service_update_audit_events(@service['id'])
  if negate
    expect(audit_events_json['auditEvents'].length).to eq(0), "#{audit_events_json['auditEvents'].length} found"
  else
    expect(audit_events_json['auditEvents'].length).not_to eq(0), "None found"
    puts "Found #{audit_events_json['auditEvents'].length}"
  end
end

Given /^user #{MAYBE_VAR} sets the (\w+) of that service to #{MAYBE_VAR}$/ do |editor_email, field_name, new_text|
  update_service(
    @service['id'],
    { field_name => new_text },
    editor_email,
  )
end

Given 'I have a supplier with a reusable declaration' do
  @supplier = get_supplier_with_reusable_declaration
  puts "supplier id: #{@supplier['id']}"
end


Given 'I have a supplier with a copyable service' do
  @supplier = get_supplier_with_copyable_service(@framework)
  puts "supplier id: #{@supplier['id']}"
end

Given /^I have the latest live or standstill framework$/ do
  response = call_api(:get, "/frameworks")
  expect(response.code).to eq(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  live_or_standstill_frameworks = frameworks.select { |f| f['status'] == 'live' || f['status'] == 'standstill' }
  if live_or_standstill_frameworks.empty?
    puts 'SKIPPING as there are no live or standstill frameworks'
    skip_this_scenario
  end
  @framework = live_or_standstill_frameworks.max_by { |f| f['applicationsCloseAtUTC'] }
  puts "Framework: #{@framework['slug']}"
end

Then /^I see (.*) within the page's text$/ do |text|
  expect(page.find('main').text).to include(normalize_whitespace(text))
end


Given(/^I visit the start sign framework agreement page for that framework$/) do
  url = "/suppliers/frameworks/#{@framework['slug']}/start-framework-agreement-signing"
  page.visit("#{dm_frontend_domain}#{url}")
end

Then(/^I see the sign agreement confirmation page$/) do
  confirmation_message = "You’ve signed the #{@framework['name']} Framework Agreement"
  expect(page).to have_selector('h1', text: normalize_whitespace(confirmation_message))
end

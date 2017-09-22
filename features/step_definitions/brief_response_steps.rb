Given 'I have a live digital outcomes and specialists framework' do
  response = call_api(:get, "/frameworks")
  response.code.should be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if {|framework| framework['framework'] != 'digital-outcomes-and-specialists' || framework['status'] != 'live'}
  frameworks.empty?.should be(false), _error(response, "No live digital outcomes and specialists frameworks found")
  @framework = frameworks[0]
  puts @framework['slug']
end

Given /^I have a (draft|live|withdrawn) (.*) brief$/ do |status, lot_slug|
  brief = create_brief(@framework['slug'], lot_slug, @buyer["id"])
  puts "created brief with id #{brief['id']}"
  brief = publish_brief(brief['id']) unless status == "draft"
  withdraw_brief(brief['id']) if status == "withdrawn"
  @brief = brief
end

Given /^I am logged in as the buyer of a closed brief$/ do
  closed_brief = get_briefs('digital-outcomes-and-specialists-2', 'closed').sample
  @brief = closed_brief
  @buyer = closed_brief['users'][0]
  @lot_slug = closed_brief['lotSlug']
  @framework_slug = closed_brief['frameworkSlug']
  @buyer.update({'password' => ENV["DM_PRODUCTION_BUYER_USER_PASSWORD"]})
  steps %Q{
    Given that buyer is logged in
  }
end

Given /^I am logged in as the buyer of a closed brief with responses$/ do
  submitted_brief_response = get_brief_responses('digital-outcomes-and-specialists-2', 'submitted', 'closed').sample
  @brief = get_brief(submitted_brief_response['brief']['id'])
  @lot_slug = @brief['lotSlug']
  @framework_slug = @brief['frameworkSlug']
  @buyer = @brief['users'][0]
  @buyer.update({'password' => ENV["DM_PRODUCTION_BUYER_USER_PASSWORD"]})
  steps %Q{
    Given that buyer is logged in
  }
end

Given /^I go to that brief page$/ do
  url = "/digital-outcomes-and-specialists/opportunities/#{@brief['id']}"
  page.visit("#{dm_frontend_domain}#{url}")
end

Given /^I click the '(.*)' link for that brief$/ do | link_text |
  page.find(:xpath, "//a[text()='#{link_text}' and contains(@href, '#{@brief['id']}')]").click

end

Given /^I go to that brief overview page$/ do
  url = "/buyers/frameworks/#{@framework_slug}/requirements/#{@lot_slug}/#{@brief['id']}"
  page.visit("#{dm_frontend_domain}#{url}")
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

Given 'that supplier has filled in their response to that brief but not submitted it' do
  @brief_response = create_brief_response(@brief['lotSlug'], @brief['id'], @supplier['id'])
end

Given 'that supplier submits their response to that brief' do
  submit_brief_response(@brief_response)
end

Then /^I visit the '(.*)' question page for that brief response$/ do |question|
  snaked = question.downcase.split.each_with_index do |word, index|
    word.capitalize! if index != 0
  end
  question_id = snaked.join
  url = "/suppliers/opportunities/#{@brief['id']}/responses/#{@brief_response}/#{question_id}"
  step "I am on the #{url} page"
end

Then /^I see '(.*)' replayed in the question advice$/ do |replayed_info|
  page.should have_xpath("//span[@class='question-advice']/p", text: replayed_info)
end

Then /^I am on the '(.*)' page with brief '(.*)'/ do |str, brief_attribute|
  page.should have_selector('h1', text: normalize_whitespace(str % (@brief[brief_attribute])))
end

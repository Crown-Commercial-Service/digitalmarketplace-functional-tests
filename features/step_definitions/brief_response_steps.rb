Given 'I have a live digital outcomes and specialists framework' do
  response = call_api(:get, "/frameworks")
  response.code.should be(200), _error(response, "Failed getting frameworks")
  frameworks = JSON.parse(response.body)['frameworks']
  frameworks.delete_if {|framework| framework['framework'] != 'digital-outcomes-and-specialists' || framework['status'] != 'live'}
  frameworks.empty?.should be(false), _error(response, "No live digital outcomes and specialists frameworks found")
  @framework = frameworks[0]
  puts @framework['slug']
end

Given /^I have a live (.*) brief$/ do |lot_slug|
  brief_id = create_brief(@framework['slug'], lot_slug, @buyer["id"])
  puts "created brief with id #{brief_id}"
  brief = publish_brief(brief_id)
  @brief_id = brief_id
  @brief = brief
end

Given /^I go to that brief page$/ do
  url = "/digital-outcomes-and-specialists/opportunities/#{@brief_id}"
  page.visit("#{dm_frontend_domain}#{url}")
end

Given 'that supplier is on that framework' do
  submit_supplier_declaration(@framework['slug'], @supplier["id"], {})
end

Given /^that supplier has a service on the (.*) lot(?: for the (.*) role)?$/ do |lot_slug, role_type|
  @service = create_live_service(@framework['slug'], lot_slug, @supplier["id"], role_type)
end

Given 'that supplier has filled in their application but not submitted it' do
  @brief_response = create_brief_response(@brief['lotSlug'], @brief_id, @supplier['id'])
end

Then /^I visit the '(.*)' question page for that brief response$/ do |question|
  snaked = question.downcase.split.each_with_index do |word, index|
    word.capitalize! if index != 0
  end
  question_id = snaked.join
  url = "/suppliers/opportunities/#{@brief_id}/responses/#{@brief_response}/#{question_id}"
  step "I am on the #{url} page"
end

Then /^I see '(.*)' replayed in the question advice$/ do |replayed_info|
  page.should have_xpath("//span[@class='question-advice']/p", text: replayed_info)
end

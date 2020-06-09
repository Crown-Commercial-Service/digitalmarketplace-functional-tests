Given /^I have a (draft|live|withdrawn) (.*) brief$/ do |status, lot_slug|
  brief = create_brief(@framework['slug'], lot_slug, @buyer_user["id"])
  puts "created brief with id #{brief['id']}"
  brief = publish_brief(brief['id']) unless status == "draft"
  withdraw_brief(brief['id']) if status == "withdrawn"
  @brief = brief
end

Given /^I am logged in as the buyer of a (closed|live) brief$/ do |status|
  @brief = get_briefs(status).sample
  if @brief
    puts "brief id: #{@brief['id']}"
  else
    raise "could not find a #{status} brief"
  end

  @buyer_user = (@brief['users'].select { |u| u["active"] && !u["locked"] })[0]
  if @buyer_user
    puts "user id: #{@buyer_user['id']}"
  else
    raise "could not find active user for #{status} brief #{brief['id']}"
  end

  @lot_slug = @brief['lotSlug']
  @framework_slug = @brief['frameworkSlug']
  @buyer_user.update('password' => ENV["DM_BUYER_USER_PASSWORD"])
  steps "Given that buyer is logged in"
end

Given /^I am logged in as the buyer of a closed brief with responses$/ do
  submitted_brief_responses = iter_brief_responses('submitted', 'closed')
  submitted_brief_responses.each do |brief_response|
    @brief = get_brief(brief_response['brief']['id'])
    @buyer_user = (@brief['users'].select { |u| u["active"] && !u["locked"] })[0]
    break if @buyer_user
  end
  raise "could not find an active user for a closed #{framework} brief with responses" if not @buyer_user

  @lot_slug = @brief['lotSlug']
  @framework_slug = @brief['frameworkSlug']
  puts "brief id: #{@brief['id']}"
  puts "user id: #{@buyer_user['id']}"
  @buyer_user.update('password' => ENV["DM_BUYER_USER_PASSWORD"])
  steps "Given that buyer is logged in"
end

Given /^I go to that brief page$/ do
  url = "/digital-outcomes-and-specialists/opportunities/#{@brief['id']}"
  page.visit("#{dm_frontend_domain}#{url}")
end

Given /^I click the '(.*)' link for that brief$/ do |link_text|
  page.find(:xpath, "//a[text()='#{link_text}' and contains(@href, '#{@brief['id']}')]").click
end

Given /^I go to that brief overview page$/ do
  url = "/buyers/frameworks/#{@framework_slug}/requirements/#{@lot_slug}/#{@brief['id']}"
  page.visit("#{dm_frontend_domain}#{url}")
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
  step "I visit the #{url} page"
end

Then /^I see '(.*)' replayed in the question advice$/ do |replayed_info|
  expect(page).to have_xpath("//span[@class='question-advice']/p", text: replayed_info)
end

Then /^I am on the '(.*)' page with brief '(.*)'/ do |str, brief_attribute|
  expect(page).to have_selector('h1', text: normalize_whitespace(str % (@brief[brief_attribute])))
end

Given /^I publish an answer to a question$/ do
  @random_question_text = SecureRandom.hex
  @random_answer_text = SecureRandom.hex
  steps %{
    Then I enter '#{@random_question_text}' in the 'question' field
    Then I enter '#{@random_answer_text}' in the 'answer' field
    Then I click the 'Publish question and answer' button
  }
end

Then /^I see the published question and answer$/ do
  steps %{
    Then I see '#{@random_question_text}' in the 'Questions asked by suppliers' summary list
    Then I see '#{@random_answer_text}' in the 'Questions asked by suppliers' summary list
  }
end

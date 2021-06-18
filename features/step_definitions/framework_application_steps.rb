When /^I start that framework application$/ do
  page.all(:xpath, "//form[contains(@action, \"" + @framework["slug"] + "\")]//input[@type='submit']")[0].click
end

Then /^I am on (#{MAYBE_VAR}) page for that framework application$/ do |page_title|
  page_title.sub! "framework", @framework['name']
  step "I am on the '#{page_title}' page"
end

Then /^I click (#{MAYBE_VAR}) link for that framework application$/ do |link_title|
  link_title.sub! "framework", @framework['name']
  step "I click a link with text '#{link_title}'"
end

Then(/^I follow the first 'Edit' link and answer all questions on that page and those following until I'm (?:back )?on (#{MAYBE_VAR}) page$/) do |terminating_page_name|
  # TODO: We can remove the first branch of xpath when we've deployed the Declaration Overview changes
  edit_links = page.all(:xpath, "//p[@class='summary-item-top-level-action']/a[text()='Edit'] | //div[@class='dm-section-action-link']/a[contains(text(),'Edit')]")
  edit_links[0].click
  page_name = nil
  until page.all(:xpath, "//h1")[0].text == terminating_page_name
    if page_name == page.all(:xpath, "//h1")[0].text
      options = get_answers_for_validated_questions
      answer = fill_form with: options
    else
      page_name = page.all(:xpath, "//h1")[0].text
      answer = fill_form
    end
    merge_fields_and_print_answers(answer)
    first(:button, text: /(Save and continue)|(Save and return to declaration overview)/).click
  end
end

Then(/^I submit a service for each lot$/) do
  lots_options = find_elements_by_xpath("//input[@type='radio']")

  lots_options.each_with_index do |_option, index|
    link = find_elements_by_xpath("//input[@type='radio']")[index]
    link.click
    click_on 'Save and continue', wait: false
    begin
      click_on 'Add a service', wait: false
    rescue Capybara::ElementNotFound => e
      answer_all_dos_lot_questions "Edit"
      answer_all_service_questions "Add"
      first(:button, "Mark as complete").click
    else
      answer = fill_form
      merge_fields_and_print_answers(answer)
      click_on 'Save and continue', wait: false
      answer_all_dos_lot_questions "Edit"
      answer_all_service_questions "Answer question"
      first(:button, "Mark as complete").click
      click_on "Back to application", wait: false
    end
    click_on 'Add a service', wait: false
  end
end

Then("I submit a copied service") do
  if @framework["family"] == "digital-outcomes-and-specialists"
    answer_all_dos_lot_questions "Edit"
    answer_all_service_questions "Add"
  elsif @framework["family"] == "g-cloud"
    answer_all_service_questions "Answer question"
  end
  first(:button, "Mark as complete").click
end

And(/^I fill in all the missing details$/) do
  answer_all_service_questions "Answer required"
end

Given /^that supplier has confirmed their company details for that application$/ do
  confirm_company_details_for_framework(@framework['slug'], @supplier['id'])
end

Given /^that supplier has begun the application process for that framework$/ do
  register_interest_in_framework(@framework['slug'], @supplier['id'])
end

Given /^that supplier has not begun the declaration for that application$/ do
  remove_supplier_declaration(@supplier['id'], @framework['slug'])
  set_supplier_framework_prefill_declaration(@supplier['id'], @framework['slug'], nil)
end

Then /^I( don't)? receive a (follow-up|clarification) question( confirmation)? email regarding that question for (#{MAYBE_VAR})$/ do |negate, question_type, maybe_confirmation, target_address|
  ref_prefix = (
    case question_type
    when 'follow-up'
      expect(maybe_confirmation).to be_nil  # no such thing as a follow up confirmation
      'fw-follow-up-question'
    else
      if maybe_confirmation
        'fw-clarification-question-confirm'
      else
        'fw-clarification-question'
      end
    end
  )
  expected_ref = "#{ref_prefix}-#{DMNotify.hash_string(@fields['clarification_question'].strip)}-#{DMNotify.hash_string(target_address)}"
  puts "Notify ref: #{expected_ref}"

  messages = DMNotify.get_email_raw(expected_ref)
  expect(messages.collection.length).to (negate ? eq(0) : be > 0)
  if not negate
    @email = messages.collection[0]
    puts "Notify id: #{@email.id}"
  end
end


Then 'I select the lot for the existing service' do
  lotSlug = @existing_service['lotSlug']
  page.save_screenshot("select.png")
  lot_option = find_elements_by_xpath("//input[@type='radio' and @value='#{lotSlug}']")
  lot_option[0].click
end


Then /^I click the link to view and add services from the previous framework/ do
  # The previous framework name includes a &nbsp, so use the link here instead
  framework_slug = @framework['slug']
  lot_slug = @existing_service['lotSlug']
  step "I visit the /suppliers/frameworks/#{framework_slug}/submissions/#{lot_slug}/previous-services page"
end

When 'I ensure I am on the services page' do
  if ! page.all(:xpath, "//a[contains(text(), 'Back to services')]").empty?
    step "I click 'Back to services'"
  end
end

Then /^I am on (#{MAYBE_VAR}) page for that lot$/ do |page_title|
  page_title.sub! "lot", @existing_service['lotName'].downcase
  step "I am on the '#{page_title}' page"
end

Then /^I( don't)? see the existing service in the copyable services table$/ do |negate|
  previous_framework_slug = @existing_service['frameworkSlug']
  expected_link = "/suppliers/frameworks/#{previous_framework_slug}/services/#{@existing_service['id']}"

  if negate
    expect(page).not_to have_link(href: expected_link)
  else
    expect(page).to have_link(href: expected_link)
  end
end

Then "I click the 'Add' button for the existing service" do
  # We want to pick our specific service, as there could be multiple ones on the page.
  # TODO: replace use of data analytics label with a proper unique identifier
  button_analytics_label = "ID: #{@existing_service['id']}"
  button = page.all(:xpath, "//form//button[@data-analytics-label='#{button_analytics_label}']")[0]
  button.click

  new_service = get_draft_service_copied_from(@existing_service, @framework['slug'])
  @new_service_href = "/suppliers/frameworks/#{@framework['slug']}/submissions/#{new_service['lotSlug']}/#{new_service['id']}"
  puts "Draft service URL: #{@new_service_href}"
end

Then(/^I( don't)? see that service in the Draft services section$/) do |negate|
  if negate
    expect(page).not_to have_link(href: @new_service_href)
  else
    expect(page).to have_link(href: @new_service_href)
  end
end

Then "I click the link to edit the newly copied service" do
  find_link(href: @new_service_href).click
end

Then "I am on the draft service page" do
  service_name = normalize_whitespace(@existing_service['serviceName'])
  step "I am on the '#{service_name}' page"
end

Then "I see confirmation that I have removed that draft service" do
  service_name = normalize_whitespace(@existing_service['serviceName'])
  step "I see a success flash message containing '#{service_name} was removed'"
end

Then "I have submitted services for each lot" do
  lot_count = @framework['lots'].length
  step "I see '#{lot_count} SERVICES' text on the page"
end

Then "I see all my services are ready for submission" do
  lot_count = @framework['lots'].length

  step "I see 'Ready for submission (#{lot_count})' text on the page"
end

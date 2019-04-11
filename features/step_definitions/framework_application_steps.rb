When /^I start that framework application$/ do
  page.all(:xpath, "//form[contains(@action, \"" + @framework["slug"] + "\")]//input[@type='submit']")[0].click
end

Then /^I am on #{MAYBE_VAR} page for that framework application$/ do |page_title|
  page_title.sub! "framework", @framework['name']
  step "I am on the '#{page_title}' page"
end

Then /^I click #{MAYBE_VAR} link for that framework application$/ do |link_title|
  link_title.sub! "framework", @framework['name']
  step "I click a link with text '#{link_title}'"
end

Then(/^I follow the first 'Edit' link and answer all questions on that page and those following until I'm (?:back )?on #{MAYBE_VAR} page$/) do |terminating_page_name|
  edit_links = page.all(:xpath, "//p[@class='summary-item-top-level-action']/a[text()='Edit']")
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
    find_and_click_submit_button
  end
end

Then(/^I submit a service for each lot$/) do
  lots_links = find_elements_by_xpath("//ul[@class='browse-list']//a")
  lots_links.each_with_index do |_link, index|
    link = find_elements_by_xpath("//ul[@class='browse-list']//a")[index]
    link.click
    begin
      click_on 'Add a service', wait: false
    rescue Capybara::ElementNotFound => e
      answer_all_dos_lot_questions "Edit"
      answer_all_service_questions "Add"
      find_elements_by_xpath("//input[@value='Mark as complete']")[0].click
    else
      answer = fill_form
      merge_fields_and_print_answers(answer)
      click_on 'Save and continue', wait: false
      answer_all_dos_lot_questions "Edit"
      answer_all_service_questions "Answer question"
      find_elements_by_xpath("//input[@value='Mark as complete']")[0].click
      click_on "Back to application", wait: false
    end

    # turn on when debugging to make a screenshot when a service for a lot is submitted:
    # page.save_screenshot("screenshot#{index}.png")
  end
end

And(/^I fill in all the missing details$/) do
  answer_all_service_questions "Answer required"
end

Given /^that supplier has confirmed their company details for that application$/ do
  confirm_company_details_for_framework(@framework['slug'], @supplier['id'])
end

Then /^I( don't)? receive a (follow-up|clarification) question( confirmation)? email regarding that question for #{MAYBE_VAR}$/ do |negate, question_type, maybe_confirmation, target_address|
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

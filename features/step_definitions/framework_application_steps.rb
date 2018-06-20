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

Then(/^I answer all questions on that page$/) do
  page_header_at_start = page.all(:xpath, "//h1")[0].text
  edit_links = page.all(:xpath, "//p[@class='summary-item-top-level-action']/a[text()='Edit']")
  edit_links[0].click
  page_header = nil
  until page_header_at_start == page.all(:xpath, "//h1")[0].text
    if page_header == page.all(:xpath, "//h1")[0].text
      options = get_answers_for_validated_questions
      answer = fill_form with: options
    else
      page_header = page.all(:xpath, "//h1")[0].text
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

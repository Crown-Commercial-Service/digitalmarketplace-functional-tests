Then /^I am on the #{MAYBE_VAR} page for that framework application$/ do |page_title|
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
  while true
    if page_header == page.all(:xpath, "//h1")[0].text
      options = get_answers_for_validated_questions
      answer = fill_form :with => options
    else
      page_header = page.all(:xpath, "//h1")[0].text
      answer = fill_form
    end
      @fields.merge! answer
      puts answer
    if page.all(:xpath, "//input[@class='button-save']")[0].value == 'Save and continue'
      click_on 'Save and continue'
    else
      click_on page.all(:xpath, "//input[@class='button-save']")[0].value
    end
    if page_header_at_start == page.all(:xpath, "//h1")[0].text
      break
    end
  end
end

Then(/^I submit a service for each lot$/) do
  lots_links_length = page.all(:xpath, "//ul[@class='browse-list']//a").length
  index = 0
  lots_links_length.times do
    link = page.all(:xpath, "//ul[@class='browse-list']//a")[index]
    link.click
    click_on 'Add a service'
    @fields.merge! fill_form
    click_on 'Save and continue'
    answer_all_service_questions
    page.all(:xpath, "//input[@value='Mark as complete']")[0].click
    click_on "Back to application"
    index += 1
    page.save_screenshot("screenshot#{index}.png")
  end
end

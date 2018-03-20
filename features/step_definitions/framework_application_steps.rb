Then /^I am on the #{MAYBE_VAR} page for that framework application$/ do |page_title|
  page_title.sub! "framework", @framework['name']
  step "I am on the '#{page_title}' page"
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

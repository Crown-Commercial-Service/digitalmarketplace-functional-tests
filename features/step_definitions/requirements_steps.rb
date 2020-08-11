Before do
  @fields = {}
end

Given "I have created $type requirement" do |type|
  page.visit("#{dm_frontend_domain}")

  click_on "Find #{type}", wait: false

  expect(page).to have_selector('h1', text: "Find #{type}")

  click_on 'Create requirement', wait: false

  answers = fill_form

  @fields.merge! answers

  click_on 'Save and continue', wait: false

  expect(page).to have_selector('h1', text: answers['title'])
end

Then(/^'(.*)' should (not |)be ticked$/) do |label, negative|
  expr = "//li[a[text()='#{label}']]/span[@class='tick']"

  count = case negative.empty? when true then 1 else 0 end

  expect(page).to have_selector(:xpath, expr, count: count)
end

When "I answer the following questions:" do |table|

  table.rows.flatten.each { |question|
    expr = "//li[a[text()='#{question}']]/span[@class='tick']"

    # should be no tick mark beside the question name on the overview page
    expect(page).to have_selector(:xpath, expr, count: 0)

    # click the question name on the overview page (eg, "Location")
    click_on question, wait: false

    @fields.merge! fill_form

    click_on 'Save and continue', wait: false

    expect(page).to have_selector(:xpath, expr, count: 1)
  }
end

When "I answer all summary questions with:" do |table|
  with = {}
  expected_summary_table_values = {}

  if table
    table.rows.each do |k, v, s|
      # Parse Cucumber table
      v = JSON.parse(v) if ['{', '['].include? v[0]
      with[k] = v
      # Only add this k: v pair to the expected_summary_table_values if the value exists (taken from the
      # expected_summary_table_value column)
      # {table field: expected summary table value}
      expected_summary_table_values[k] = s if s != ''
    end
  end

  is_summary_table = page.first('tr.summary-item-row')

  # Hack to make it work with both cases until we remove summary table
  if is_summary_table
    row_class = 'tr.summary-item-row'
    cell_class = 'td'
    cell_index = 1
  else
    row_class = 'div.govuk-summary-list__row'
    cell_class = 'dd.govuk-summary-list__value'
    cell_index = 0
  end

  all(row_class).to_a.each_with_index do |row, index|
    within all(row_class)[index] do
      click_on first('a').text, wait: false
    end

    answer = fill_form with: with

    merge_fields_and_print_answers(answer)

    substitutions = find_substitutions

    click_on 'Save and continue', wait: false

    within all(row_class)[index] do
      # Find the value in the summary table.
      # Can be overriden using the expected_summary_table_value column of the Cucumber table
      answer.each do |k, v|
        if v.respond_to? :each
          v.each do |v|
            expect(all(cell_class)[cell_index].text).to include(expected_summary_table_values[k] || substitutions[k][v] || v)
          end
        else
          expect(all(cell_class)[cell_index].text).to include(expected_summary_table_values[k] || substitutions[k][v] || v)
        end
      end
    end
  end
end

When "I answer all summary questions" do
  steps %{
     When I answer all summary questions with:
       | field | value |
  }
end

Then "I see '$expected_text' text in the desktop preview panel" do |expected_text|
  within_frame(0) do
    expect(page).to have_content expected_text
  end
end

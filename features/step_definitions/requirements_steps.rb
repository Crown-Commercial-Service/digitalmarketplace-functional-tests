Before do
  @fields = {}
end


#Given (/^I have created (.+?) requirement(?: with\:)?$/) do |type, table|
#
 # table ||= nil
  #page.visit("#{dm_frontend_domain}")
#
 # click_on "Find #{type}"
#
 # page.should have_selector('h1', text: "Find #{type}")
#
 # click_on 'Create requirement'
  #answers_hash = {}
#  if table
 #   table.rows.each do |k, v|
#      answers_hash.merge!({k => v})
#    end
#  end
#  puts answers_hash
#  answers = fill_form(options=answers_hash)
#
 # @fields.merge! answers
#
 # click_on 'Save and continue'
#
 # page.should have_selector('h1', text: answers['title'])
#end



 Given "I have created $type requirement with:" do |type, table|
   page.visit("#{dm_frontend_domain}")

   click_on "Find #{type}"

   page.should have_selector('h1', text: "Find #{type}")

   click_on 'Create requirement'
   answers_hash = {}
   table.rows.each do |k, v|
     answers_hash.merge!({k: v})
   end
   answers = fill_form(options=answers_hash)


   @fields.merge! answers

   click_on 'Save and continue'

   page.should have_selector('h1', text: answers['title'])
 end

 Given "I have created $type requirement" do |type|
    step "I have created #{type} requirement with:"
 end

Then(/^'(.*)' should (not |)be ticked$/) do |label, negative|
  expr = "//li[a[text()='#{label}']]/span[@class='tick']"

  count = case negative.empty? when true then 1 else 0 end

  page.should have_selector(:xpath, expr, :count => count)
end

When "I answer the following questions:" do |table|

  table.rows.flatten.each { |question|
    expr = "//li[a[text()='#{question}']]/span[@class='tick']"

    # should be no tick mark beside the question name on the overview page
    page.should have_selector(:xpath, expr, :count => 0)

    # click the question name on the overview page (eg, "Location")
    click_on question

    @fields.merge! fill_form

    click_on 'Save and continue'

    page.should have_selector(:xpath, expr, :count => 1)
  }
end

When "I answer all summary questions with:" do |table|
  with = {}
  expected_summary_table_values = {}

  table.rows.each do |k, v, s|
    # Parse Cucumber table
    v = JSON.parse(v) if ['{', '['].include? v[0]
    with[k] = v
    # Only add this k: v pair to the expected_summary_table_values if the value exists (taken from the
    # expected_summary_table_value column)
    # {table field: expected summary table value}
    expected_summary_table_values[k] = s if s != ''
  end if table

  all('tr.summary-item-row').to_a.each_with_index do |row, index|
    within all('tr.summary-item-row')[index] do
      click_on first('a').text
    end

    answer = fill_form :with => with

    @fields.merge! answer

    substitutions = find_substitutions

    puts answer

    click_on 'Save and continue'

    within all('tr.summary-item-row')[index] do
      # Find the value in the summary table.
      # Can be overriden using the expected_summary_table_value column of the Cucumber table
      answer.each do |k, v|
        if v.respond_to? :each
          v.each { |v| all('td')[1].text.should include(expected_summary_table_values[k] || substitutions[k][v] || v) }
        else
          all('td')[1].text.should include(expected_summary_table_values[k] || substitutions[k][v] || v)
        end
      end
    end
  end
end

When "I answer all summary questions" do
  steps %Q{
     When I answer all summary questions with:
       | field | value |
  }
end

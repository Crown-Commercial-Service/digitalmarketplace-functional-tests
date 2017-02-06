Before do
  @fields = {}
end

Given "I have created $type requirement" do |type|
  page.visit("#{dm_frontend_domain}")

  click_on "Find #{type}"

  page.should have_selector('h1', text: "Find #{type}")

  click_on 'Create requirement'

  answers = fill_form

  @fields.merge! answers

  click_on 'Save and continue'

  page.should have_selector('h1', text: answers['title'])
end

Then(/^'(.*)' should (not |)be ticked$/) do |label, negative|
  expr = "//li[a[text()='#{label}']]/span[@class='tick']"

  count = case negative.empty? when true then 1 else 0 end

  page.should have_selector(:xpath, expr, :count => count)
end

When "I answer the following questions:" do |table|

  table.rows.flatten.each { |question|
    expr = "//li[a[text()='#{question}']]/span[@class='tick']"

    page.should have_selector(:xpath, expr, :count => 0)

    click_on question

    @fields.merge! fill_form

    click_on 'Save and continue'

    page.should have_selector(:xpath, expr, :count => 1)
  }
end

When "I answer all summary questions with:" do |table|
  with = {}

  table.rows.each do |k, v|
    v = JSON.parse(v) if ['{', '['].include? v[0]
    with[k] = v
  end if table

  all('tr.summary-item-row').to_a.each_with_index do |row, index|
    within all('tr.summary-item-row')[index] do
      click_on first('a').text
    end

    answer = fill_form :with => with

    @fields.merge! answer

    substitutions = find_substitutions

    puts answer
    puts substitutions

    click_on 'Save and continue'

    within all('tr.summary-item-row')[index] do
      answer.each do |k, v|
        if v.respond_to? :each
          v.each { |v| all('td')[1].text.should include(substitutions[k][v] || v) }
        else
          all('td')[1].text.should include(substitutions[k][v] || v)
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

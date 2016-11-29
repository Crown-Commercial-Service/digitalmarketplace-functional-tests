Before do
  @substitutions = {}
  @fields = {}
end

Given /^I have created (an individual specialist|a team to provide an outcome) requirement$/ do |type|

  page.visit("#{dm_frontend_domain}")

  click_on "Find #{type}"

  assert_selector('h1', text: "Find #{type}")

  click_on 'Create requirement'

  answers = fill_form

  @fields.merge! answers

  click_on 'Save and continue'

  assert_selector('h1', text: answers['title'])
end

Then(/^'(.*)' should (not |)be ticked$/) do |label, negative|
  expr = "//li[a[text()='#{label}']]/span[@class='tick']"
  
  count = case negative.empty? when true then 1 else 0 end

  assert_selector(:xpath, expr, :count => count)
end

When "I answer the following questions:" do |table|

  table.rows.flatten.each { |question|
    expr = "//li[a[text()='#{question}']]/span[@class='tick']"

    assert_selector(:xpath, expr, :count => 0)
    
    click_on question
    
    @fields.merge! fill_form

    click_on 'Save and continue'

    assert_selector(:xpath, expr, :count => 1)
  }
end

When /^I answer the question$/ do 
  @answer = fill_form

  @fields.merge! @answer
end

When "I use the following substitutions:" do |table|
  @substitutions.merge! Hash[table.rows]
end

When "I answer all summary questions" do
  all('tr.summary-item-row').to_a.each_with_index do |row, index|
    within all('tr.summary-item-row')[index] do
      click_on first('a').text
    end

    answer = fill_form

    @fields.merge! answer

    click_on 'Save and continue'

    within all('tr.summary-item-row')[index] do
      answer.each do |k, v|
        if v.respond_to? :each 
          v.each { |v| all('td')[1].text.should include(@substitutions[v] || v) }
        else
          all('td')[1].text.should include(@substitutions[v] || v)
        end
      end
    end
  end
end

When "I answer all summary questions with:" do |table|
  with = {}

  table.rows.each do |k, v|
    v = JSON.parse(v) if ['{', '['].include? v[0]
    with[k] = v
  end

  all('tr.summary-item-row').to_a.each_with_index do |row, index|
    within all('tr.summary-item-row')[index] do
      click_on first('a').text
    end

    answer = fill_form :with => with

    @fields.merge! answer

    click_on 'Save and continue'

    within all('tr.summary-item-row')[index] do
      answer.each do |k, v|
        if v.respond_to? :each 
          v.each { |v| all('td')[1].text.should include(@substitutions[v] || v) }
        else
          all('td')[1].text.should include(@substitutions[v] || v)
        end
      end
    end
  end
end
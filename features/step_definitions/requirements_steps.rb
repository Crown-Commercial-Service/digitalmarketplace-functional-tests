Given /^I have created (an individual specialist|a team to provide an outcome) requirement$/ do |type|
  steps %Q{
    Given I am on the homepage
     When I click 'Find #{type}'
     Then I am on the 'Find #{type}' page
     When I click 'Create requirement'
      And I enter a random value in the 'title' field and click its associated 'Save and continue' button
     Then I am on that fields.title page
  }
end

Then(/^'(.*)' should (not |)be ticked$/) do |label, negative|
  page.all(:xpath, "//li[a[text()='#{label}']]").empty?.should == false
  
  expr = "//li[a[text()='#{label}']]/span[@class='tick']"
  
  !page.all(:xpath, expr).empty?.should == negative.empty?
end


Then /^I should (not |)see #{MAYBE_VAR} in #{MAYBE_VAR} summary item$/ do |negative, value, label|
  expr = "//tr[td[@class='summary-item-field-first']/span[text() = '#{label}']]/td[@class='summary-item-field' and contains(., '#{value}')]"

  !page.all(:xpath, expr).empty?.should == negative.empty?
end

When /^I answer the following questions:?$/ do |table|
  table.rows.flatten.each { |question|
    step "I click '#{question}'"
    step "I answer the question"
    step "I click 'Save and continue'"
    step "'#{question}' should be ticked"
  }
end

When /^I answer the question$/ do 
  text = page.all(:xpath, '//input[@type="text"] | //textarea').to_a
  radios = page.all(:xpath, '//input[@type="radio"]').to_a
  checks = page.all(:xpath, '//input[@type="checkbox"]').to_a

  name = [text, radios, checks].flatten[0][:name]
  
  step "I enter a random value in the '#{name}' field" unless text.empty?
  
  step "I choose a random '#{name}' radio button" unless radios.empty?
  
  step "I check a random '#{name}' checkbox" unless checks.empty?
  
  @answer = @fields[name]
end

When /^I answer the following summary questions:?$/ do |table|
  table.rows.each { |title, question, value|
    step "I click '#{question}'"
    step "I answer the question"
    step "I click 'Save and continue'"
    step "I should see that answer in the '#{title}' summary item"
  }
end


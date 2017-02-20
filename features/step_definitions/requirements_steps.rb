store = OpenStruct.new

Given /^I am on the '(.*)' requirements overview page$/ do |brief_name|
  visit "#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}"
  page.find('h1').should have_content("#{brief_name}")
  current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}")
end

Given /^I am on the details page for the selected opportunity$/ do
  current_url.should end_with("#{dm_frontend_domain}/digital-outcomes-and-specialists/opportunities/#{store.current_brief_id}")
end

Then /^I am taken to the '(.*)' requirements overview page$/ do |brief_name|
  page.find('h1').should have_content(brief_name)
  page.all(:css, '.instruction-list h2').map {|e| e.text }.should == [
    "1. Write requirements",
    "2. Set how you’ll evaluate suppliers",
    "3. Publish requirements",
    "4. Answer supplier questions",
    "5. Shortlist",
    "6. Evaluate",
    "7. Award a contract"
  ]
  parts = URI.parse(current_url).path.split('/')
  store.current_brief_id = (parts.select {|v| v =~ /^\d+$/}).last
  store.framework = URI.parse(current_url).path.split('frameworks/').last.split('/').first
  store.lot = URI.parse(current_url).path.split('requirements/').last.split('/').first
  current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}")
end

Then /^'(.*)' section is marked as complete$/ do |section|
  page.all(:xpath, '//span[@class="tick"]/following-sibling::a').map {|e| e.text }.should include(section)
end

Given /^A (.*) '(.*)' buyer requirements with the name '(.*)' exists and I am on the "Overview of work" page$/ do |brief_state, brief_type, brief_name|
  steps %Q{
    Given I have a '#{brief_state}' set of requirements named '#{brief_name}'
    And I am on the "Overview of work" page for the newly created buyer requirements
  }
  page.find('h1').should have_content(brief_name)
  parts = URI.parse(current_url).path.split('/')
  store.current_brief_id = (parts.select {|v| v =~ /^\d+$/}).last
  store.framework = URI.parse(current_url).path.split('frameworks/').last.split('/').first
  store.lot = URI.parse(current_url).path.split('requirements/').last.split('/').first
  current_url.should end_with("#{dm_frontend_domain}/buyers/frameworks/#{store.framework}/requirements/#{store.lot}/#{store.current_brief_id}")
end

When /^I click on the link to the opportunity I have posted a question for$/ do
  page.find(:xpath, "//h2/a[contains(@href, '/digital-outcomes-and-specialists/opportunities/#{store.current_brief_id}')]").click
end

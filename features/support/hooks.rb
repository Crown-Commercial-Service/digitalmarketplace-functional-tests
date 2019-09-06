Before('@smoke-tests') do
  @SMOKE_TESTS = true
end

Before('@smoulder-tests') do
  @SMOULDER_TESTS = true
end

Before do
  Capybara.reset_sessions!
end

Before do
  Capybara.page.current_window.resize_to 1366, 768
end

require 'fileutils'
FileUtils.mkdir_p "reports"
DEBUG_FILE = File.open("reports/debug.#{Process.pid}.out", "a")

AfterStep do |result, test_step|
  DEBUG_FILE.write "#{Time.now.utc.round(10).iso8601(6)}: #{test_step.location}\n"
end


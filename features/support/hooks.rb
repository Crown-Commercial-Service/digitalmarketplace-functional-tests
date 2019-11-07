Before('@smoke-tests') do
  @SMOKE_TESTS = true
end

Before('@smoulder-tests') do
  @SMOULDER_TESTS = true
end

Before do
  Capybara.reset_sessions!
end

require 'fileutils'
FileUtils.mkdir_p "reports"
DEBUG_FILE = File.open("reports/debug.#{Process.pid}.out", "a")

AfterStep do |result, test_step|
  timestr = Time.now.utc.round(10).iso8601(6)
  DEBUG_FILE.write "#{timestr}: #{test_step.location}: #{current_url}\n"
  cp = URI(current_url).path
  # buyer FE
  # if cp.start_with? "/buyers/direct-award" or not cp.start_with?("/admin", "/suppliers", "/buyers", "/user")
  # supplier FE
  if cp.start_with? "/suppliers"
    page.save_screenshot("walkthrough/#{timestr}.png", full: true)
  end
end


Before('@smoke-tests') do
  @SMOKE_TESTS = true
end

Before('@smoulder-tests') do
  @SMOULDER_TESTS = true
end

Before do
  Capybara.reset_sessions!
end

DEBUG_FILE = File.open("debug.out", "w+")

AfterStep do |result, test_step|
  DEBUG_FILE.write "#{Time.now.getutc}: #{test_step.location}\n"
end


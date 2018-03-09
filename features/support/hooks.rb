Before('@smoke-tests') do
  @SMOKE_TESTS = true
end

Before do
  Capybara.reset_sessions!
end

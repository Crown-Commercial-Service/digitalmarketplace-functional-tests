require 'erb'
require 'rspec'
require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara-screenshot/cucumber'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:expect] }
end

if (ENV['BROWSER'] == 'true')
  require 'selenium-webdriver'
  Capybara.default_driver = :selenium

  Capybara.register_driver :selenium do |app|
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 180
    Capybara::Selenium::Driver.new(app, browser: :firefox, http_client: http_client)
  end
else
  Capybara.default_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app, timeout: 180, phantomjs_logger: File.open(File::NULL, "w"), phantomjs_options: [])
  end
end

def domain_for_app(app)
  case app
  when "api"
    dm_api_domain
  when "search-api"
    dm_search_api_domain
  when "frontend"
    dm_frontend_domain
  else
    raise ArgumentError, "Invalid app name #{app}"
  end
end

def dm_environment
  ENV['DM_ENVIRONMENT'] || 'development'
end

def dm_api_domain
  ENV['DM_API_DOMAIN'] || 'http://localhost:5000'
end

def dm_api_access_token
  ENV['DM_API_ACCESS_TOKEN'] || 'myToken'
end

def dm_search_api_domain
  ENV['DM_SEARCH_API_DOMAIN'] || 'http://localhost:5001'
end

def dm_search_api_access_token
  ENV['DM_SEARCH_API_ACCESS_TOKEN'] || 'myToken'
end

def dm_frontend_domain
  ENV['DM_FRONTEND_DOMAIN']
end

def dm_pagination_limit
  (ENV['DM_PAGINATION_LIMIT'] || 100).to_i
end

def dm_notify_api_key
  ENV['DM_NOTIFY_API_KEY']
end

def dm_documents_bucket_name
  ENV['DM_DOCUMENTS_BUCKET_NAME']
end

def dm_custom_wait_time
  5
end

Capybara.asset_host = dm_frontend_domain
Capybara.save_path = "reports/"
Capybara.default_max_wait_time = 0.05

if ENV['DM_DEBUG_SLOW_TESTS']
  # Monkeypatch Capybara's synchronize method to let us catch places where we're using the 'wrong' kind of finder
  # Capybara has waiting and non-waiting finders. If we use a waiting finder to look for text that isn't present, when we
  # actually expect the text *not* to be there, our tests will run slower than they should.
  # Sourced from https://github.com/ngauthier/capybara-slow_finder_errors (MIT licence).
  module Capybara
    class SlowFinderError < CapybaraError; end

    module Node
      class Base
        def synchronize_with_timeout_error(*args, &block)
          start_time = Time.now
          synchronize_without_timeout_error(*args, &block)
        rescue Capybara::ElementNotFound => e
          seconds = args.first || Capybara.default_max_wait_time
          if seconds > 0 && Time.now - start_time > seconds
            raise SlowFinderError, "Timeout reached while running a *waiting* Capybara finder...perhaps you wanted to return immediately? Use a non-waiting Capybara finder. More info: http://blog.codeship.com/faster-rails-tests?utm_source=gem_exception"
          end

          raise
        end
        alias_method :synchronize_without_timeout_error, :synchronize
        alias_method :synchronize, :synchronize_with_timeout_error
      end
    end
  end
end

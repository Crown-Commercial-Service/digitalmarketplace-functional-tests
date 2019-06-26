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
      app, timeout: 180, phantomjs_logger: File.open(File::NULL, "w"), phantomjs_options: ["--ssl-protocol=tlsv1.2"])
  end
end

def domain_for_app(app)
  case app
  when "api"
    dm_api_domain
  when "search-api"
    dm_search_api_domain
  when "antivirus-api"
    dm_antivirus_api_domain
  when "assets"
    dm_assets_domain
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

def dm_antivirus_api_domain
  ENV['DM_ANTIVIRUS_API_DOMAIN'] || 'http://localhost:5008'
end

def dm_assets_domain
  ENV['DM_ASSETS_DOMAIN']
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

def dm_pre_load_wait_time
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

module Capybara
  module Node
    class Base
      # Monkeypatch the internals of the syncronise method to wait for `dm_custom_wait_time` seconds unless the error is
      # Capybara::ElementNotFound in which case use the `default_max_wait_time`. We require a shorter wait time on
      # ElementNotFound in case we are checking that an element does not exist. We don't want to wait 5 seconds for it
      # it to appear.
      # https://github.com/teamcapybara/capybara/blob/2.18.0/lib/capybara/node/base.rb#L77
      def synchronize(seconds = session_options.default_max_wait_time, options = {})
        start_time = Capybara::Helpers.monotonic_time
        if session.synchronized
          yield
        else
          session.synchronized = true
          begin
            yield
          rescue => e # rubocop:disable RescueStandardError
            session.raise_server_error!
            raise e unless driver.wait?
            raise e unless catch_error?(e, options[:errors])
            puts(e.class)
            seconds = e.class == Capybara::ElementNotFound ? seconds : dm_custom_wait_time
            puts(seconds)
            raise e if (Capybara::Helpers.monotonic_time - start_time) >= seconds

            sleep(0.05)
            raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if Capybara::Helpers.monotonic_time == start_time

            reload if session_options.automatic_reload
            retry
          ensure
            session.synchronized = false
          end
        end
      end

      # Monkeypatch Capybara's synchronize method to wait longer if it detects the page to be in a loading state.
      # Note this is done *after* the possible patching via synchronize_with_timeout_error, so that it wraps
      # *outside* that.

      def synchronize_with_unload_wait(*args, &block)
        Timeout.timeout(dm_pre_load_wait_time) do
          until driver.evaluate_script('window.performance.timing.navigationStart < window.performance.timing.loadEventEnd')
            DEBUG_FILE.write "#{Time.now.getutc}: #{caller.to_a.select { |pth| pth.include? '/features/' }}\n"
            # navigationStart has been updated more recently than loadEventEnd, loadEventEnd presumably still
            # carrying the value set when the *old* page got loaded - that means the dom is probably in the
            # process of loading (or at least requesting) a new page. any following page queries will
            # presumably be targeted at the upcoming page, which isn't ready.
            sleep(0.01)
          end
        end
        synchronize_without_unload_wait(*args, &block)
      end
      alias_method :synchronize_without_unload_wait, :synchronize
      alias_method :synchronize, :synchronize_with_unload_wait
    end
  end
end

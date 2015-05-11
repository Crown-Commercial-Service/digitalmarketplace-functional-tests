require 'nokogiri'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara-screenshot/cucumber'

module Capybara
  class << self
    alias :really_reset_sessions! :reset_sessions!

    def reset_sessions!
    end
  end
end

if (ENV['BROWSER'] == 'true')
  require 'selenium-webdriver'
  Capybara.default_driver = :selenium

  Capybara.register_driver :selenium do |app|
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 180
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
  end
else
  Capybara.default_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, timeout: 180, :phantomjs_options => ['--ssl-protocol=TLSv1'])
  end
end

def dm_api_domain()
  ENV['DM_API_DOMAIN'] || 'http://localhost:5000'
end

def dm_api_access_token()
  ENV['DM_API_ACCESS_TOKEN'] || 'myToken'
end

def dm_search_api_domain()
  ENV['DM_SEARCH_API_DOMAIN'] || 'http://localhost:5001'
end

def dm_search_api_access_token()
  ENV['DM_SEARCH_API_ACCESS_TOKEN'] || 'myToken'
end

def dm_frontend_domain()
  ENV['DM_FRONTEND_DOMAIN'] || 'http://localhost:5002'
end

Capybara::Screenshot.prune_strategy = { keep: 100 }

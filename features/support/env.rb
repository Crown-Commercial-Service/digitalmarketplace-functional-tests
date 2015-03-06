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

def ssp_domain()
  ENV['SSP_DOMAIN'] || 'http://localhost:9000'
end

def dm_domain()
  ENV['DM_DOMAIN'] || ''
end

def dm_api_domain()
  ENV['DM_API_DOMAIN'] || ''
end

def dm_api_access_token()
  ENV['DM_API_ACCESS_TOKEN']
end

def dss_domain()
  ENV['DSS_DOMAIN'] || ''
end

Capybara::Screenshot.prune_strategy = { keep: 100 }

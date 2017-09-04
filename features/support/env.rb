require 'erb'
require 'rspec'
require 'nokogiri'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara-screenshot/cucumber'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
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
    Capybara::Poltergeist::Driver.new(
      app, :timeout => 180, :phantomjs_logger => File.open(File::NULL, "w"), :phantomjs_options => [])
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
  ENV['DM_FRONTEND_DOMAIN']
end

def dm_pagination_limit()
  (ENV['DM_PAGINATION_LIMIT'] || 100).to_i
end

Capybara.asset_host = dm_frontend_domain
Capybara.save_path = "reports/"

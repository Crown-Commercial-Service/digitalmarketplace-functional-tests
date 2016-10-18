require 'rspec'
require 'nokogiri'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara-screenshot/cucumber'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
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
  when "dm_api"
    dm_api_domain()
  when "dm_search_api"
    dm_search_api_domain()
  when "dm_frontend"
    dm_frontend_domain()
  else
    raise ArgumentError, "Invalid app name #{app}"
  end
end

def access_token_for_app(app)
  case app
  when "dm_api"
    dm_api_access_token()
  when "dm_search_api"
    dm_search_api_access_token()
  when "dm_frontend"
    dm_frontend_access_token()
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

def dm_production_supplier_user_email()
  ENV['DM_PRODUCTION_SUPPLIER_USER_EMAIL']
end

def dm_production_supplier_user_name()
  ENV['DM_PRODUCTION_SUPPLIER_USER_NAME']
end

def dm_production_supplier_user_password()
  ENV['DM_PRODUCTION_SUPPLIER_USER_PASSWORD']
end

def dm_production_supplier_user_supplier_id()
  ENV['DM_PRODUCTION_SUPPLIER_USER_SUPPLIER_ID'].to_i
end

def dm_production_buyer_user_email()
  ENV['DM_PRODUCTION_BUYER_USER_EMAIL']
end

def dm_production_buyer_user_name()
  ENV['DM_PRODUCTION_BUYER_USER_NAME']
end

def dm_production_buyer_user_password()
  ENV['DM_PRODUCTION_BUYER_USER_PASSWORD']
end

def dm_production_admin_user_email()
  ENV['DM_PRODUCTION_ADMIN_USER_EMAIL']
end

def dm_production_admin_user_name()
  ENV['DM_PRODUCTION_ADMIN_USER_NAME']
end

def dm_production_admin_user_password()
  ENV['DM_PRODUCTION_ADMIN_USER_PASSWORD']
end

def dm_production_admin_ccs_category_user_email()
  ENV['DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_EMAIL']
end

def dm_production_admin_ccs_category_user_name()
  ENV['DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_NAME']
end

def dm_production_admin_ccs_category_user_password()
  ENV['DM_PRODUCTION_ADMIN_CCS_CATEGORY_USER_PASSWORD']
end

def dm_production_admin_ccs_sourcing_user_email()
  ENV['DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_EMAIL']
end

def dm_production_admin_ccs_sourcing_user_name()
  ENV['DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_NAME']
end

def dm_production_admin_ccs_sourcing_user_password()
  ENV['DM_PRODUCTION_ADMIN_CCS_SOURCING_USER_PASSWORD']
end

def dm_admin_email()
  ENV['DM_ADMIN_EMAIL']
end

def dm_admin_password()
  ENV['DM_ADMIN_PASSWORD']
end

def dm_buyer_email()
  ENV['DM_BUYER_EMAIL']
end

def dm_buyer_password()
  ENV['DM_BUYER_PASSWORD']
end

def dm_admin_ccs_sourcing_email()
  ENV['DM_ADMIN_CCS_SOURCING_EMAIL']
end

def dm_admin_ccs_category_email()
  ENV['DM_ADMIN_CCS_CATEGORY_EMAIL']
end

def dm_supplier_user_email()
  ENV['DM_SUPPLIEREMAIL'] || ENV['DM_SUPPLIER_EMAIL']
end

def dm_supplier_user2_email()
  ENV['DM_SUPPLIER2EMAIL'] || ENV['DM_SUPPLIER2_EMAIL']
end

def dm_supplier_user3_email()
  ENV['DM_SUPPLIER3EMAIL'] || ENV['DM_SUPPLIER3_EMAIL']
end

def dm_supplier_user_emails()
  [
    dm_supplier_user_email(),
    dm_supplier_user2_email(),
    dm_supplier_user3_email(),
  ]
end

def dm_supplier2_user_email()
  ENV['DM_SUPPLIER2_USER_EMAIL']
end

def dm_supplier_password()
  ENV['DM_SUPPLIERPASSWORD'] || ENV['DM_SUPPLIER_PASSWORD']
end

def dm_pagination_limit()
  (ENV['DM_PAGINATION_LIMIT'] || 100).to_i
end

Capybara.save_path = "reports/"
Capybara::Screenshot.prune_strategy = { keep: 100 }

require 'capybara/helpers'

LOTS = {
  all: 'All categories',
  SaaS: 'Software as a Service',
  PaaS: 'Platform as a Service',
  IaaS: 'Infrastructure as a Service',
  SCS: 'Specialist Cloud Services'
}

def full_lot(lot)
  LOTS[lot.to_sym]
end

def normalize_whitespace(text)
  Capybara::Helpers.normalize_whitespace(text)
end

require 'capybara/helpers'
require 'rspec/expectations'

require_relative 'form_helpers.rb'

World FormHelper

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

## selecting and checking invisible fields

def all_fields(locator, options={})
  all(:field, locator, options.merge({:visible => :all}))
end

def first_field(locator, options={})
  all_fields(locator, options)[0]
end

def urls_are_equal(url1, url2)
  # horrible hack, if it's a relative href stick a fake scheme and prefix on
  if url1.start_with? "/"
    if !url2.start_with? "/"
      return false
    end
    url1 = "http://localhost#{url1}"
    url2 = "http://localhost#{url2}"
  end
  url1 = URI::parse(url1)
  url2 = URI::parse(url2)
  [:scheme, :host, :path].each do |key|
    if url1.send(key) != url2.send(key)
      return false
    end
  end
  # query and fragment parameters can appear in any order
  [:query, :fragment].each do |key|
    if url1.send(key)
      if !url2.send(key)
        return false
      elsif CGI::parse(url1.send(key)) != CGI::parse(url2.send(key))
        return false
      end
    end
  end
  return true
end

RSpec::Matchers.define :match_url do |expected|
  match do |actual|
    urls_are_equal(expected, actual)
  end
end

RSpec::Matchers.define :include_url do |expected|
  match do |actual_list|
    actual_list.map {|actual| urls_are_equal(actual, expected)}.include?(true)
  end
end

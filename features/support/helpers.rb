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

## finding and selecting invisible fields

def all_fields(locator, options={})
  all(:field, locator, options.merge({:visible => :all}))
end

def first_field(locator, options={})
  all_fields(locator, options)[0]
end

def return_element(type, locator_or_element, options={})
  if locator_or_element.is_a? Capybara::Node::Element
    element = locator_or_element
  else
    # when passing in the value of the element we want to choose/check, we pass it in as {:option => "value"}
    # but when we're finding it, we need to pass it in as {:with => "value"}
    find_options = options[:option] ? {:with => options[:option]} : {}
    element = first_field(locator_or_element, find_options.merge({type: type}))
  end

  # If the label for this radio/checkbox is not visible, it is effectively hidden from the user
  element.find_xpath('parent::label')[0].visible?.should be(true), "Expected label for #{type} \"#{element.value}\" to be visible"

  return element
end

def choose_radio(locator_or_radio, options={})
  radio = return_element('radio', locator_or_radio, options)

  choose(radio[:id], options.merge({allow_label_click: true}))
  puts "Radio button value: #{radio.value}"
end

def check_checkbox(locator_or_checkbox, options={})
  checkbox = return_element('checkbox', locator_or_checkbox, options)

  check(checkbox[:id], options.merge({allow_label_click: true}))
  puts "Checkbox value: #{checkbox.value}"
end

def uncheck_checkbox(locator_or_checkbox, options={})
  checkbox = return_element('checkbox', locator_or_checkbox, options)

  check(checkbox[:id], options.merge({allow_label_click: true}))
  puts "Unselected: #{checkbox.value}"
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

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
}.freeze

META_DATA_XPATHS = {
  location: '//*[@class="search-result"]//*[@class="search-result-important-metadata"][1]//*[@class="search-result-metadata-item"][2]',
  lot: '//*[@class="search-result"]//*[@class="search-result-metadata"][1]//*[@class="search-result-metadata-item"][1]',
  role: '//*[@class="search-result"]//*[@class="search-result-metadata"][1]//*[@class="search-result-metadata-item"][2]',
  status: '//*[@class="search-result"]//*[@class="search-result-metadata"][2]//*[@class="search-result-metadata-item"][1]'
}.freeze

CLOSED_OUTCOMES = {
  Awarded: 'Closed: awarded',
  Cancelled: 'Closed: cancelled',
  Closed: 'Closed: awaiting outcome',
  Unsuccessful: 'Closed: no suitable suppliers'
}.freeze

def full_lot(lot)
  LOTS[lot.to_sym]
end

def search_result_metadata_items(type)
  all(:xpath, META_DATA_XPATHS[type])
end

def closed_outcome?(status)
  CLOSED_OUTCOMES.key?(status.to_sym)
end

def closed_outcome_status?(text)
  CLOSED_OUTCOMES.value?(text)
end

def normalize_whitespace(text)
  Capybara::Helpers.normalize_whitespace(text)
end

## finding and selecting invisible fields

def merge_fields_and_print_answers(answer)
  @fields.merge! answer
  puts answer
end

def is_js_hidden?(html_element)
  html_element["class"] && html_element["class"].include?("js-hidden")
end

def remove_js_hidden_fields_from_results(results)
  results.each do |result|
    ancestor_divs = result.find_xpath("ancestor::div")
    if ancestor_divs
      ancestor_divs.each do |ancestor|
        if is_js_hidden?(ancestor)
          results.delete(result)
          break
        end
      end
    end
  end
  results
end

def find_elements_by_xpath(xpath)
  page.document.find_xpath(xpath)
end

def all_fields(locator, options = {})
  results = all(:field, locator, options.merge(visible: :all)).to_a
  remove_js_hidden_fields_from_results(results)
end

def first_field(locator, options = {})
  all_fields(locator, options)[0]
end

def return_element(type, locator_or_element, options = {})
  if locator_or_element.is_a? Capybara::Node::Element
    element = locator_or_element
  else
    # when passing in the value of the element we want to choose/check, we pass it in as {:option => "value"}
    # but when we're finding it, we need to pass it in as {:with => "value"}
    find_options = options[:option] ? { with: options[:option] } : {}
    element = first_field(locator_or_element, find_options.merge(type: type))
    unless element
      broader_search_for_element = first_field(locator_or_element)
      if broader_search_for_element["type"] == type
        element = broader_search_for_element
      end
    end
  end
  # If the label for this radio/checkbox is not visible, it is effectively hidden from the user
  expect(find_elements_by_xpath(
    "//label[@for='#{element[:id]}']"
  )[0].visible?).to be(true), "Expected label for #{type} \"#{element.value}\" to be visible"

  element
end

def choose_radio(locator_or_radio, options = {})
  begin
    radio = return_element('radio', locator_or_radio, options)
    choose(radio[:id], options.merge(allow_label_click: true))
  rescue Capybara::ElementNotFound
    choose(radio[:id], allow_label_click: true)
  end
  puts "Radio button value: #{radio.value}"
end

def check_checkbox(locator_or_checkbox, options = {})
  checkbox = return_element('checkbox', locator_or_checkbox, options)

  check(checkbox[:id], options.merge(allow_label_click: true))
  puts "Checkbox value: #{checkbox.value}"
end

def uncheck_checkbox(locator_or_checkbox, options = {})
  checkbox = return_element('checkbox', locator_or_checkbox, options)

  uncheck(checkbox[:id], options.merge(allow_label_click: true))
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
  %i[scheme host path].each do |key|
    if url1.send(key) != url2.send(key)
      return false
    end
  end
  # query and fragment parameters can appear in any order
  %i[query fragment].each do |key|
    if url1.send(key)
      if !url2.send(key)
        return false
      elsif CGI::parse(url1.send(key)) != CGI::parse(url2.send(key))
        return false
      end
    end
  end
  true
end

RSpec::Matchers.define :match_url do |expected|
  match do |actual|
    urls_are_equal(expected, actual)
  end
end

RSpec::Matchers.define :include_url do |expected|
  match do |actual_list|
    actual_list.map { |actual| urls_are_equal(actual, expected) }.include?(true)
  end
end

# from https://github.com/ilyakatz/capybara/blob/c0844c8cf43801fa1d88e502b71b8e75ed6da017/lib/capybara/xpath.rb#L8
def escape_xpath(string)
  if string.include?("'")
    string = string.split("'", -1).map do |substr|
      "'#{substr}'"
    end.join(%q{,"'",})
    "concat(#{string})"
  else
    "'#{string}'"
  end
end

def get_table_rows_by_caption(caption)
  result_table_xpath = "//caption[@class='visually-hidden'][normalize-space(text())=\"#{caption}\"]/parent::table"
  rows_xpath = "/tbody/tr[@class='summary-item-row']"
  result_table_rows_xpath = result_table_xpath + rows_xpath
  page.all(:xpath, result_table_rows_xpath)
end

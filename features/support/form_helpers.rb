module FormHelper
  # Helper utilities for dealing with forms
  
  
  def field_type(el)
    # Returns the type of field for a Capybara::Node::Element
    
    if el[:type] == 'checkbox'
      :checkbox
    elsif el[:type] == 'radio'
      :radio
    elsif el[:type] == 'text' and  el.matches_css? 'div.input-list input'
      # TODO condition is expensive.... can we cache?
      :list
    else
      :text
    end
  end

  def random_string
    # Generate a random string
    
    (0..rand(3)).map{ |i| SecureRandom.base64.gsub(/[+=\/]/, '') }.join
  end

  def random_for(locator, options={})
    # Generate a suitable random value based on locator
    
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)
    result = all(:field, locator, options)

    if result.empty?
      query = Capybara::Queries::SelectorQuery.new(:field, locator, options)
      raise Capybara::ElementNotFound.new("Unable to find #{query.description}")
    end

    case field_type(result.first)
    when :radio
      result.sample.value
    when :checkbox
      (0..rand(result.length)).map { |i| result.sample.value }.uniq
    when :list
      (0..rand(10)).map { |i| random_string }
    else
      random_string
    end
  end

  def find_fields(locator=nil, options={})
    # Find all field names

    results = all(:field, locator, options).map { |v| v[:name] }

    results.uniq
  end

  def check_only(locator=nil, options={})
    # Ensure only the values provided in options[:with] are selected
    # takes either a single string or array of strings
    
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    with = [options.delete(:with)].flatten
    result = all(:field, locator, options)

    result.select { |v| not with.include?(v.value) }.each do |element|
      uncheck element[:id]
    end

    with.each do |value|
      checked = result.select { |v| v.value == value }
    
      if checked.empty? 
        query = Capybara::Queries::SelectorQuery.new(:field, locator, options)
        raise Capybara::ElementNotFound.new("Unable to find #{query.description} with value '#{value}'")
      end

      check checked.first[:id]
    end

    result
  end

  def input_list(locator=nil, options={})
    # Enter the values provided in options[:with] into an input list
    # takes either a single string or array of strings

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    with = [options.delete(:with)].flatten
    result = all(:field, locator, options)
    
    within result[0] do
      within(:xpath, '../..') do
        (3..with.length).each { click_on find('.list-entry-add').text } if with.length > 2
      end
    end
    
    result = all(:field, locator, options)
    
    with.zip(result).each do |value, element|
      fill_in element[:id], :with => value
    end

    result
  end

  def fill_field(locator=nil, options={})
    # Like fill_in but will work with checkboxes, radios, and input lists too.

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    with = options.delete(:with)
    result = all(:field, locator, options)

    if result.empty?
      query = Capybara::Queries::SelectorQuery.new(:field, locator, options)
      raise Capybara::ElementNotFound.new("Unable to find #{query.description}")
    end

    case field_type result.first
    when :radio
      choose locator, options.merge({ option: with })

      result.select { |v| v.value == with }
    when :checkbox
      check_only locator, options.merge({ :with => with })
    when :list
      input_list locator, options.merge({ :with => with })
    else
      result = fill_in locator, options.merge({ :with => with })
      
      [result]
    end
  end

  def fill_form(locator=nil, options={})
    # Fill in all form fields with provided values, using random values for
    # any not provided.

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)
    with = options.delete(:with) || {}
    
    values = {}
    
    if locator.nil?
      find_fields.each do |name|
        values[name] = (with[name] or random_for name)

        fill_field name, with: values[name]
      end
    else
      within locator, options do
        find_fields.each do |name|
          values[name] = random_for name

          fill_field name, with: values[name]
        end
      end
    end
    
    values
  end
end

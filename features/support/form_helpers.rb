module FormHelper
  # Helper utilities for dealing with forms

  def field_type(el)
    # Returns the type of field for a Capybara::Node::Element

    if el[:type] == 'checkbox'
      :checkbox
    elsif el[:type] == 'radio'
      :radio
    elsif (el[:type] == 'text') && el.matches_css?('div.input-list input')
      # TODO condition is expensive.... can we cache?
      :list
    else
      :text
    end
  end

  def random_string
    # Generate a random string

    (0..rand(3)).map { |i| SecureRandom.base64.gsub(/[+=\/]/, '') }.join
  end

  def random_for(locator, options = {})
    # Generate a suitable random value based on locator

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)

    result = all_fields(locator, options)

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

  def get_parent_label(el)
    el.find_xpath("//label[@for='#{el[:id]}']")[0]
  end

  def find_fields(locator = nil, options = {})
    # Find all field names
    # If the inputs themselves aren't visible (ie, radios and checkboxes), verify that the parent labels are
    results = all_fields(
      locator, options
    ).select { |el|
      el.visible? || get_parent_label(el).visible?
    }.map { |v|
      v[:name]
    }

    results.uniq
  end

  def check_only(locator = nil, options = {})
    # Ensure only the values provided in options[:with] are selected
    # takes either a single string or array of strings

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if (not options.is_a?(Hash)) || (not options.has_key?(:with))
    with = [options.delete(:with)].flatten
    result = all_fields(locator, options)

    result.select { |v| not with.include?(v.value) }.each do |element|
      uncheck_checkbox(element[:id])
    end

    with.each do |value|
      checked = result.select { |v| v.value == value }

      if checked.empty?
        query = Capybara::Queries::SelectorQuery.new(:field, locator, options)
        raise Capybara::ElementNotFound.new("Unable to find #{query.description} with value '#{value}'")
      end

      check_checkbox(checked.first[:id])
    end

    result
  end

  def input_list(locator = nil, options = {})
    # Enter the values provided in options[:with] into an input list
    # takes either a single string or array of strings

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if (not options.is_a?(Hash)) || (not options.has_key?(:with))
    with = [options.delete(:with)].flatten
    result = all(:field, locator, options)

    within result[0] do
      within(:xpath, '../..') do
        (3..with.length).each { click_on find('.list-entry-add').text } if with.length > 2
      end
    end

    result = all(:field, locator, options)

    with.zip(result).each do |value, element|
      fill_in element[:id], with: value
    end

    result
  end

  def fill_field(locator = nil, options = {})
    # Like fill_in but will work with checkboxes, radios, and input lists too.

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if (not options.is_a?(Hash)) || (not options.has_key?(:with))
    with = options.delete(:with)

    result = all_fields(locator, options)
    @result = result
    @argumenta = [locator, options]
    if result.empty?

      query = Capybara::Queries::SelectorQuery.new(:field, locator, options)
      raise Capybara::ElementNotFound.new("Unable to find #{query.description}")
    end

    case field_type result.first
    when :radio
      choose_radio(locator, options.merge(option: with))

      result.select { |v| v.value == with }
    when :checkbox
      check_only locator, options.merge(with: with)
    when :list
      input_list locator, options.merge(with: with)
    when :file
      [{}]
    else
      if result.first.tag_name == "select"
        [{}]
      else
        if result.first["name"] == "serviceDefinitionDocumentURL"
          require 'pry'; pry.binding
        end
        result = fill_in locator, options.merge(with: with)
        [result]
      end
    end
  end

  def maybe_within(locator = nil, options = {}, &block)
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)

    if locator.nil?
      block.call
    else
      within locator, options do
        block.call
      end
    end
  end

  def find_substitutions(locator = nil, options = {})
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)

    results = all_fields(locator, options)

    # hash that initialises empty keys to a hash
    values = Hash.new { |h, k| h[k] = {} }

    results.each do |result|
      if %i[checkbox radio].include? field_type(result)

        label = find("label[for='#{result[:id]}']").text

        begin
          description = all("label[for='#{result[:id]}'] p").map { |el| el.text }.join

          if not description.empty?
            label = label[0..(label.length - description.length - 2)]
          end

        rescue Capybara::ElementNotFound

        end

        values[result[:name]][result[:value]] = label
      end
    end

    values
  end

  def fill_form(locator = nil, options = {})
    # Fill in all form fields with provided values, using random values for
    # any not provided.

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)
    with = options.delete(:with) || {}

    values = {}
    maybe_within do
      find_fields.each do |name|
        if find_fields(locator=name).length > 0
          values[name] = (with[name] || random_for(name))
          fill_field name, with: values[name]
        end
      end
    end

    values
  end

  def get_answers_for_validated_questions
    document = page.document
    options = {}
    questions = document.find_xpath("//input[@class='text-box-with-error']")
    if questions.length > 0
      questions.each do |question|
        if question["name"] =~ /email/i
          options[question["name"]] = "lain@company.co.uk"
        else options[question["name"]] = "Some text"
        end
      end
    end
    pricing_questions = document.find_xpath("//input[@class='text-box pricing-input-with-unit']")
    if pricing_questions.length > 0
      pricing_questions.each do |question|
        options[question["name"]] = "500"
      end
    end
    document_questions = document.find_xpath("//input[@class='file-upload-input']")
    if document_questions.length > 0
      document_questions.each do |question|
        attach_file(question["name"], File.join(Dir.pwd, 'fixtures', 'test.pdf'))
      end
      options = :gotosave
    end
    checkboxes = document.find_xpath("//input[@type='checkbox']")
    if checkboxes.length > 0 && (document.text.include?("You can’t choose more than"))
      checkboxes.each do |checkbox|
        if checkbox.checked? then
          checkbox.click
        end
      end
      checkboxes[0].click
      options = :gotosave
    end
    options
  end

  def choose_options_for_select_fields
    selects = page.document.find_xpath("//select")
    selects.each do |element|
      field = all_fields(element["name"])[0]
      field_options = field.all('option')
      field_options[rand(field_options.count - 1)].select_option
    end
  end

  def answer_all_service_questions
    document = page.document
    while document.find_xpath("//a[text()='Answer question']").length > 0
      if document.find_xpath("//input[@value='Mark as complete']").length > 0
        return
      end
      next_answer_question_link = page.all(:xpath, "//a[text()='Answer question']")[0]
      next_answer_question_link.click
      # page.document.find_xpath("//span[text()='Backup and recovery']/following::a[text()='Answer question']")[0].click
      answer_service_section
    end
  end

  def answer_service_section
    is_end_of_section = false
    fail_counter = 0
    while is_end_of_section == false
      categories_headings = page.document.find_xpath("//h3[@class='categories-heading']")
      if is_there_validation_header?
        fail_counter += 1
        if fail_counter > 7
          require 'pry'; pry.binding
          abort("Too many failures")
        end
        options = get_answers_for_validated_questions
        unless options == :gotosave
          answer = fill_form :with => options
        end
      elsif categories_headings.length > 0
        categories_headings.each do |category_heading|
          category_heading.click
        end
        checkbox = page.document.find_xpath("//input[@type='checkbox']")[0]
        checkbox.click
        options == :gotosave
      else
        answer = fill_form
      end
      unless options && options == :gotosave
        if page.document.find_xpath("//select").length > 0
          choose_options_for_select_fields
        end
        @fields.merge! answer
        puts answer
      end
      submit_button = page.document.find_xpath("//input[@class='button-save']")[0].value
      page.save_screenshot("screenshot_#{Time.new}.png")
      if  submit_button == 'Save and continue'
        click_on 'Save and continue'
      else
        click_on submit_button
        unless is_there_validation_header?
          is_end_of_section = true
        end
      end
    end
  end

  def is_there_validation_header?
    page.document.find_xpath("//h1").length > 1
  end
end

module FormHelper
  # Helper utilities for dealing with forms

  def field_type(el)
    # Returns the type of field for a Capybara::Node::Element

    if el[:type] == 'checkbox'
      :checkbox
    elsif el[:type] == 'radio'
      :radio
    elsif (el[:type] == 'text') && el.matches_css?('div.input-list input, .dm-list-input__item-container input', wait: false)
      :list
    elsif el[:type] == 'file'
      :file
    else
      :text
    end
  end

  def random_string
    # Generate a random string

    (0..rand(3)).map { |i| SecureRandom.base64.gsub(/[+=\/]/, '') }.join
  end

  def random_for(locator, options = { wait: false })
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

  def is_parent_label_visible?(el)
    label = el.find_xpath("//label[@for='#{el[:id]}']")[0]
    label && label.visible?
  end

  def find_fields(locator = nil, options = { wait: false })
    # Find all field names
    # If the inputs themselves aren't visible (ie, radios and checkboxes), verify that the parent labels are
    results = all_fields(
      locator, options
    ).select { |el|
      el.visible? || is_parent_label_visible?(el)
    }.map { |v|
      v[:name]
    }

    results.uniq
  end

  def check_only(locator = nil, options = { wait: false })
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

  def input_list(locator = nil, options = { wait: false })
    # Enter the values provided in options[:with] into an input list
    # takes either a single string or array of strings

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if (not options.is_a?(Hash)) || (not options.has_key?(:with))

    with = [options.delete(:with)].flatten
    result = all(:field, locator, options)

    if result[0]["class"].include? "dm-list-input__item-input"
      parent_xpath = '../../../../..'
    else
      parent_xpath = '../..'
    end

    within result[0] do
      within(:xpath, parent_xpath) do
        (3..with.length).each { click_on find('.list-entry-add, .dm-list-input__item-add').text, wait: false } if with.length > 2
      end
    end

    result = all(:field, locator, options)

    with.zip(result).each do |value, element|
      fill_in element[:id], with: value
    end

    result
  end

  def fill_field(locator = nil, options = { wait: false })
    # Like fill_in but will work with checkboxes, radios, and input lists too.

    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if (not options.is_a?(Hash)) || (not options.has_key?(:with))

    with = options.delete(:with)

    result = all_fields(locator, options)

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
        result = fill_in locator, options.merge(with: with)
        [result]
      end
    end
  end

  def maybe_within(locator = nil, options = { wait: false }, &block)
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

  def find_substitutions(locator = nil, options = { wait: false })
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

  def fill_form(locator = nil, options = { wait: false })
    # Fill in all form fields with provided values, using random values for
    # any not provided.
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash" if not options.is_a?(Hash)

    with = options.delete(:with) || {}

    values = {}
    maybe_within do
      find_fields.each do |name|
        if find_fields(locator = name).length > 0
          values[name] = (with[name] || random_for(name))
          fill_field name, with: values[name], wait: false
        end
      end
    end

    values
  end

  def check_first_checkbox
    checkbox = find_elements_by_xpath("//input[@type='checkbox']")[0]
    checkbox.click
  end

  def uncheck_all_checkboxes
    checkboxes = find_elements_by_xpath("//input[@type='checkbox']")
    checkboxes.each do |checkbox|
      if checkbox.checked?
        checkbox.click
      end
    end
  end

  def pass_text_validation
    options = {}
    questions = find_elements_by_xpath("//input[@class='text-box-with-error']")
    questions.each do |question|
      if question["name"] =~ /email/i
        options[question["name"]] = "lain@company.co.uk"
      end
    end
    options
  end

  def pass_pricing_validation
    options = {}
    pricing_questions = find_elements_by_xpath(
      "//input[contains(@class, 'dmp-price-input__input') or contains(@class, 'pricing-input-with-unit')]"
    )
    pricing_questions.each do |question|
      options[question["name"]] = "500"
    end
    options
  end

  def pass_document_upload_validation
    document_questions = find_elements_by_xpath("//input[@class='file-upload-input']")

    random_pdf_or_odt = -> {
      true_half_the_time = Random.new.rand(n = 2) > 0
      file_format = true_half_the_time ? 'pdf' : 'odt'
      "test.#{file_format}"
    }

    if document_questions.length > 1
      # Hack for file upload followup questions that are only shown after answering the appropriate
      # Yes/No parent question
      # TODO: make this less awful?

      document_questions.first do |question|
        file_to_attach = random_pdf_or_odt.call
        puts "Attaching file #{file_to_attach}"
        attach_file(question["name"], File.join(Dir.pwd, 'fixtures', file_to_attach))
      end
      return true
    elsif document_questions.length == 1
      document_questions.each do |question|
        file_to_attach = random_pdf_or_odt.call
        puts "Attaching file #{file_to_attach}"
        attach_file(question["name"], File.join(Dir.pwd, 'fixtures', file_to_attach))
      end
      return true
    end
    false
  end

  def pass_checked_boxes_upper_limit
    checkboxes = find_elements_by_xpath("//input[@type='checkbox']")
    if checkboxes.length > 0 && page.document.text.include?("You can’t choose more than")
      uncheck_all_checkboxes
      check_first_checkbox
      return true
    end
    false
  end

  def pass_vat_number_validation
    options = {}
    if find_elements_by_xpath("//input[@name='vat_registered']").length > 0
      options["vat_registered"] = "No"
    end
    options
  end

  def pass_companies_house_number_validation
    options = {}
    if find_elements_by_xpath("//input[@name='has_companies_house_number']").length > 0
      options["has_companies_house_number"] = "No"
      options["other_company_registration_number"] = "1234PONY"
    end
    options
  end

  def pass_postcode_validation
    options = {}
    # Match fields for both 'postcode' and 'labAddressPostcode'
    postcode_elements = find_elements_by_xpath("//input[contains(@name, 'ostcode')]")
    if postcode_elements.length > 0
      element_name = postcode_elements[0]["name"]
      options[element_name] = "AB1 2CD"
    end
    options
  end

  def pass_dos_service_essentials
    options = {}
    # Match fields for the mandatory questions
    service_essentials_elements = find_elements_by_xpath("//input[contains(@name, 'helpGovernmentImproveServices')]")
    if service_essentials_elements.length > 0
      # TODO: figure out a way of avoiding hardcoding these
      options["helpGovernmentImproveServices"] = "Yes"
      options["bespokeSystemInformation"] = "Yes"
      options["dataProtocols"] = "Yes"
      options["openStandardsPrinciples"] = "Yes"
      options["accessibleApplicationsOutcomes"] = "Yes"
    end
    options
  end

  def get_answers_for_validated_questions
    if pass_document_upload_validation || pass_checked_boxes_upper_limit
      return :gotosave
    end

    [
      pass_text_validation,
      pass_pricing_validation,
      pass_vat_number_validation,
      pass_companies_house_number_validation,
      pass_postcode_validation,
      pass_dos_service_essentials
    ].inject(&:merge)
  end

  def choose_options_for_select_fields
    selects = find_elements_by_xpath("//select")
    selects.each do |element|
      field = all_fields(element["name"])[0]
      field_options = find_elements_by_xpath("//select[@name='#{element['name']}']/descendant::option")
      selected = field_options[rand(field_options.count - 1)]
      selected.select_option
      puts "#{element['name']} => #{selected['value']}"
    end
  end

  def open_categories(categories_headings)
    categories_headings.each do |category_heading|
      category_heading.click
    end
  end

  def find_and_click_submit_button
    # Get the submit buttons on the page, and categorise by whether we expect to redirect to the summary or not
    save_and_return_button = find_elements_by_xpath("//button[contains(normalize-space(text()), 'Save and return')] | //button[contains(normalize-space(text()), 'Save and return to service summary')]")[0]
    save_and_continue_button = find_elements_by_xpath("//button[contains(normalize-space(text()), 'Save and continue')]")[0]

    if save_and_return_button
      save_and_return_button.click
      # Section finished - return to summary
      true
    elsif save_and_continue_button
      save_and_continue_button.click
      # Go to next page in the section
      false
    end
  end

  def is_service_complete
    find_elements_by_xpath("//button[contains(normalize-space(text()), 'Mark as complete')]").length > 0
  end

  def answer_all_service_questions(prompt_text)
    while find_elements_by_xpath("//a[contains(text(), '#{prompt_text}')]").length > 0
      if is_service_complete
        return
      end

      find_and_answer_next_question(prompt_text)
    end
  end

  def answer_all_dos_lot_questions(prompt_text)
    i = 0
    find_elements_by_xpath("//a[text()='#{prompt_text}']").length.times do
      if is_service_complete
        return
      end

      find_and_answer_next_question(prompt_text, i)
      i += 1
    end
  end

  def answer_service_section
    is_end_of_section = false
    fail_counter = 0
    until is_end_of_section
      categories_headings = find_elements_by_xpath("//h3[@class='categories-heading']")
      if is_there_validation_header?
        fail_counter += 1
        abort("Too many failures") if fail_counter > 7
        options = get_answers_for_validated_questions
        answer = fill_form(with: options) unless options == :gotosave
      elsif categories_headings.length > 0
        open_categories(categories_headings)
        check_first_checkbox
        options = :gotosave
      else
        answer = fill_form
      end
      unless options && options == :gotosave
        choose_options_for_select_fields
        merge_fields_and_print_answers(answer)
      end
      # turn on when debugging to take a screenshot of each step:
      # page.save_screenshot("screenshot_#{Time.new}.png", full: true)
      is_end_of_section = find_and_click_submit_button && !is_there_validation_header?
    end
  end

  def find_and_answer_next_question(prompt_text, index = 0)
    next_answer_question_link = find_elements_by_xpath("//a[contains(text(),'#{prompt_text}')]")[index]
    next_answer_question_link.click

    # To debug particular section, use below line instead of above lines:
    # find_elements_by_xpath("//span[text()='Section title here']/following::a[text()='Answer question']")[0].click

    answer_service_section
  end

  def is_there_validation_header?
    # TODO: this can be simplified once all frontends are using govuk-frontend error summary component
    # (not gonna put a date on that)
    find_elements_by_xpath("//h2[@class='validation-masthead-heading'] | //div[contains(@class, 'govuk-error-summary')]").length > 0
  end
end

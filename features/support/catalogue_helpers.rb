module CatalogueHelpers
  def self.get_service_count(page)
    page.find(:xpath, "//*[@class='search-summary-count']").text.to_i
  end

  def self.get_page_count(page)
    begin
      /\s*(\d+)\s*of\s*(\d+)\s*/.match(page.find(:xpath, "//*[@class='next']//*[@class='page-numbers']").text)[2]
    rescue Capybara::ElementNotFound
      begin
        /\s*(\d+)\s*of\s*(\d+)\s*/.match(page.find(:xpath, "//*[@class='previous']//*[@class='page-numbers']").text)[2]
      rescue Capybara::ElementNotFound
        nil
      end
    end
  end

  def self.get_category_links(page)
    page.all(:css, ".lot-filters ul ul :link")
  end

  def self.get_service_search_results(page, service)
    page.all(:xpath, "//*[@class='search-result'][.//h2//a[contains(@href, '#{service['id']}')]]").find_all { |sr_element|
      # now refine with a much more precise test
      sr_element.all(:css, "h2 a").any? { |a_element|
        (
          a_element[:href] =~ Regexp.new('^(.*\D)?' + "#{service['id']}" + '(\D.*)?$')
        ) && (
          a_element.text == normalize_whitespace(service['serviceName'])
        )
      } && sr_element.all(:css, "p.search-result-supplier").any? { |p_element|
        p_element.text == normalize_whitespace(service['supplierName'])
      } && sr_element.all(:css, "li.search-result-metadata-item,li.search-result-metadata-item-inline").any? { |li_element|
        li_element.text == normalize_whitespace(service['lotName'])
      } && sr_element.all(:css, "li.search-result-metadata-item,li.search-result-metadata-item-inline").any? { |li_element|
        li_element.text == normalize_whitespace(service['frameworkName'])
      }
    }
  end

end

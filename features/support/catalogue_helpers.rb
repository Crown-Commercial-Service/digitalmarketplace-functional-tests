module CatalogueHelpers
  def self.get_service_count(page)
    page.find(:css, ".app-search-summary__count, .search-summary-count").text.to_i
  end

  def self.get_page_count(page)
    begin
      /\s*(\d+)\s*of\s*(\d+)\s*/.match(page.find(:xpath, "//*[@class='dm-pagination__link-label']").text)[2]
    rescue Capybara::ElementNotFound
      nil
    end
  end

  def self.get_category_links(page)
    page.all(:css, ".lot-filters ul ul :link, .app-lot-filter ul ul :link")
  end

  def self.get_service_search_results(page, service)
    page.all(:xpath, "//*[@class='app-search-result' or @class='search-result'][.//h2//a[contains(@href, '#{service['id']}')]]").find_all { |sr_element|
      # now refine with a much more precise test
      sr_element.all(:css, "h2 a").any? { |a_element|
        (
          a_element[:href] =~ Regexp.new('^(.*\D)?' + "#{service['id']}" + '(\D.*)?$')
        ) && (
          a_element.text == normalize_whitespace(service['serviceName'])
        )
      } && sr_element.all(:css, "p:nth-of-type(1), p.search-result-supplier").any? { |p_element|
        p_element.text == normalize_whitespace(service['supplierName'])
      } && sr_element.all(:css, "ul[aria-label='tags'] li, li.search-result-metadata-item, li.search-result-metadata-item-inline").any? { |li_element|
        li_element.text == normalize_whitespace(service['lotName'])
      } && sr_element.all(:css, "ul[aria-label='tags'] li, li.search-result-metadata-item, li.search-result-metadata-item-inline").any? { |li_element|
        li_element.text == normalize_whitespace(service['frameworkName'])
      }
    }
  end

end

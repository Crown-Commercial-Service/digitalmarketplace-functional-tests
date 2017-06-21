module CatalogueHelpers
  def self.get_service_count(page)
    page.find(:xpath, "//*[@class='search-summary-count']").text.to_i
  end

  def self.get_category_links(page)
    page.all(:css, ".lot-filters ul ul :link")
  end

end

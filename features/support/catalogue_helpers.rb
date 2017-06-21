module CatalogueHelpers
  def self.get_service_count(page)
    page.find(:xpath, "//*[@class='search-summary-count']").text.to_i
  end

end
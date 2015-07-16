module Capybara::Poltergeist
  class Driver
    def current_url
      browser.current_url.gsub('%25', '%')
    end
  end
end

Then(/^I (see|do not see) a '_ga' tracking ID query parameter on the URL$/) do |can_see_ga|
  current_url_uri = URI(current_url)
  query_hash = Hash[URI::decode_www_form(current_url_uri.query || "")]
  if can_see_ga == 'see'
    expect(query_hash).to have_key('_ga')
  elsif can_see_ga == 'do not see'
    expect(query_hash).not_to have_key('_ga')
  end
end

# Based on http://jbusser.github.io/2014/11/01/integration-testing-google-analytics-with-capybara-and-rspec.html

def google_analytics_requests
  if is_chrome
    inline_http_requests.select { |l| l.dig(":authority") == 'www.google-analytics.com' }
  else
    inline_http_requests.select do |request|
    # Return all requests matching this host
      request.host == 'www.google-analytics.com'
    end
  end
end

def google_analytics_request_with_param(param)
  if is_chrome
    collect_requests = google_analytics_requests { |r|  r[':path'].include? '/collect' }
    collect_requests.find { |cq| cq[':path'].match param }
  else
    google_analytics_requests.detect do |request|
    # We're only interested in analytics requests with `/collect/` in the path
      if request.path.match 'collect'
        request.query.match param unless request.query.nil?
      end
    end
  end
end

And(/^a tracking pageview (has been|has not been) fired(?: with (.+@.+) redacted)?$/) do |has_tracking, email|
  if has_tracking == 'has been'
    if email
      expect(google_analytics_request_with_param('[email]')).not_to be_nil
      expect(google_analytics_request_with_param(email)).to be_nil
    else
      expect(google_analytics_request_with_param('t=pageview')).not_to be_nil
    end
  else
    # Should be no track pageview requests sent to the GA domain
    expect(google_analytics_request_with_param('t=pageview')).to be_nil
  end
end

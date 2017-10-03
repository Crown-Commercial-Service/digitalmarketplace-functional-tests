require 'digest'
require 'base64'
require 'uri'

require 'notifications/client'

module DMNotify
  def self.get_email(message_type, email_address)
    email_hash = Base64.urlsafe_encode64(Digest::SHA256.digest(email_address))
    client = Notifications::Client.new(dm_notify_api_key)
    client.get_notifications({
      'template_type' => 'email',
      'reference' => "#{message_type}-#{email_hash}"
    })
  end
end

Then /^I receive a '([a-z-]+)' email for #{MAYBE_VAR}/ do |message_type, email_address|
  messages = DMNotify.get_email(message_type, email_address)
  @email_text = messages.collection[0].body
end

Then /^I click the link in that email$/ do
  page.visit(URI.extract(@email_text).select { |i| i.start_with?('http') } [0])
end

Given /^I have an email address with an accepted buyer domain$/ do
  randomString = SecureRandom.hex
  @email_address = randomString + '@example.gov.uk'
  puts "Email address: #{@email_address}"
end

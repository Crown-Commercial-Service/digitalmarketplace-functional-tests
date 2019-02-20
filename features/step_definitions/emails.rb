require 'digest'
require 'base64'
require 'uri'

require 'notifications/client'

module DMNotify
  def self.get_email_raw(reference)
    client = Notifications::Client.new(dm_notify_api_key)
    client.get_notifications(
      'template_type' => 'email',
      'reference' => reference,
    )
  end

  def self.hash_string(string_in)
    # equivalent of function in digitalmarketplace-utils
    Base64.urlsafe_encode64(Digest::SHA256.digest(string_in))
  end

  def self.get_email(message_type, email_address)
    email_hash = self.hash_string(email_address)
    self.get_email_raw("#{message_type}-#{email_hash}")
  end
end

Then /^I( don't)? receive a(?:n)? '([a-z-]+)' email for #{MAYBE_VAR}/ do |negate, message_type, email_address|
  messages = DMNotify.get_email(message_type, email_address)
  if negate
    expect(messages.collection.length).to be(0)
  else
    @email = messages.collection[0]
    puts "Notify id: #{@email.id}"
  end
end

Then /^I click the link in that email$/ do
  page.visit(URI.extract(@email.body).select { |i| i.start_with?('http') } [0])
end

Given /^I have an email address with an accepted buyer domain$/ do
  randomString = SecureRandom.hex
  @email_address = randomString + '@example.gov.uk'
  puts "Email address: #{@email_address}"
end

Given /^I have a random email address$/ do
  randomString = SecureRandom.hex
  @email_address = randomString + '@example.com'
  puts "Email address: #{@email_address}"
end

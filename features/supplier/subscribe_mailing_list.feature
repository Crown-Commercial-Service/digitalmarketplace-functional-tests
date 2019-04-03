@supplier @supplier-subscribe-mailing-list
Feature: Subscribe to the open framework notification mailing list without an account

Background:
  # This initial check only makes sense while we only have two frameworks - i.e. G-Cloud and Digital Outcomes and Specialists
  Given There is at most one framework that can be applied to
  # Navigate to the mailing list page from the home page
  And I visit the homepage
  And I click 'Become a supplier'
  Then I am on the 'Become a supplier' page
  And I click 'Get notifications when applications are opening'
  Then I am on the 'Sign up for Digital Marketplace email alerts' page
  And I don't see a banner message

@requires-credentials @mailchimp
Scenario: Successful mailing-list subscription from the home page
  When I enter 'functional-test-email@user.marketplace.team' in the 'email_address' field
  And I click 'Subscribe'
  Then I am on the 'Digital Marketplace' page
  And I see a success banner message containing 'You will receive email notifications to functional-test-email@user.marketplace.team when applications are opening.'

@requires-credentials @mailchimp
Scenario: Initially-rejected mailing-list subscription
  # example@example.com should be rejected by mailchimp as an obvious fake address
  When I enter 'example@example.com' in the 'email_address' field
  And I click 'Subscribe'
  Then I am on the 'Sign up for Digital Marketplace email alerts' page
  And I see a destructive banner message containing 'This email address cannot be used to sign up for Digital Marketplace alerts. Please use a different email address or contact enquiries@digitalmarketplace.service.gov.uk'
  # but this page should still be a valid, working form
  And I see 'example@example.com' as the value of the 'email_address' field
  When I enter 'functional-test-email@user.marketplace.team' in the 'email_address' field
  And I click 'Subscribe'
  Then I am on the 'Digital Marketplace' page

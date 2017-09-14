@supplier-subscribe-mailing-list
Feature: suppliers can subscribe to the open framework notification mailing list without an account

Scenario: Successful mailing-list subscription
    Given I am on the /suppliers/mailing-list page
    Then I am on the 'Sign up for Digital Marketplace email alerts' page
    And I don't see a banner message
    When I enter 'functional-test-example-email@gov.uk' in the 'email_address' field
    And I click 'Subscribe'
    Then I am on the 'Digital Marketplace' page
    And I see a success banner message containing 'You will receive email notifications to functional-test-example-email@gov.uk when applications are opening.'

Scenario: Initially-rejected mailing-list subscription
    Given I am on the /suppliers/mailing-list page
    Then I am on the 'Sign up for Digital Marketplace email alerts' page
    And I don't see a banner message
    # example@example.com should be rejected by mailchimp as an obvious fake address
    When I enter 'example@example.com' in the 'email_address' field
    And I click 'Subscribe'
    Then I am on the 'Sign up for Digital Marketplace email alerts' page
    And I see a destructive banner message containing 'The service is unavailable at the moment. If the problem continues please contact enquiries@digitalmarketplace.service.gov.uk.'
    # but this page should still be a valid, working form
    And I see 'example@example.com' as the value of the 'email_address' field
    When I enter 'functional-test-example-email@gov.uk' in the 'email_address' field
    And I click 'Subscribe'
    Then I am on the 'Digital Marketplace' page

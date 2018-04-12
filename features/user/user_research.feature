@user-research
Feature: User Research
Background:

Scenario Outline: New buyer user should see user research banner
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  Then I see 'Help us improve the Digital Marketplace' text on the page

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be able to dismiss user research banner
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  # Test Javascript dismiss
  When I click the 'Close' link
  Then I don't see 'Help us improve the Digital Marketplace' text on the page
  # Test cookie prevents display after dismiss
  When I am on the /buyers page
  Then I don't see 'Help us improve the Digital Marketplace' text on the page

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be not see banner after visiting user research page directly
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  Then I see 'Help us improve the Digital Marketplace' text on the page
  When I am on the /user/notifications/user-research page
  And I am on the homepage
  And I click the 'View your account' link
  Then I don't see 'Help us improve the Digital Marketplace' text on the page

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be not see banner after visiting user research page from banner link
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  When I click the 'Sign up to be a potential user research participant' link
  And I am on the homepage
  And I click the 'View your account' link
  Then I don't see 'Help us improve the Digital Marketplace' text on the page

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be not see banner after visiting user research page from account settings link
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  When I click the 'Join the user research mailing list' link
  And I am on the homepage
  And I click the 'View your account' link
  Then I don't see 'Help us improve the Digital Marketplace' text on the page

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be able to sign up for the user research mailing list
  Given I am logged in as a <role> user
  And I am on the homepage
  And I click the 'View your account' link
  And I click the 'Join the user research mailing list' link
  When I check 'Send me emails about opportunities to get involved in user research' checkbox
  And I click the 'Save changes' button
  Then I see a success banner message containing 'Your preference has been saved'
  And I see the 'Unsubscribe from the user research mailing list' link
  When I click the 'Unsubscribe from the user research mailing list' link
  Then I am on the 'Unsubscribe from the user research mailing list' page
  And I see the 'Send me emails about opportunities to get involved in user research' checkbox is checked

  Examples:
    | role     |
    | buyer    |
    | supplier |

Scenario Outline: User should be able to opt out of the user research mailing list
  Given I am logged in as a <role> user
  And that user is on the user research mailing list
  And I am on the homepage
  And I click the 'View your account' link
  And I click the 'Unsubscribe from the user research mailing list' link
  When I uncheck 'Send me emails about opportunities to get involved in user research' checkbox
  And I click the 'Save changes' button
  Then I see a success banner message containing 'Your preference has been saved'
  And I see the 'Join the user research mailing list' link
  When I click the 'Join the user research mailing list' link
  Then I see the 'Send me emails about opportunities to get involved in user research' checkbox is not checked

  Examples:
    | role     |
    | buyer    |
    | supplier |

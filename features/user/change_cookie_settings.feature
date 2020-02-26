@user @cookie-settings
Feature: Change cookie settings

Scenario Outline: New user can set their cookie preferences
  Given I visit the /user/cookie-settings page
  Then I am on the 'Change your cookie settings' page
  And I see 'Your cookie settings have not yet been saved' text on the page
  When I choose the '<new_preference>' radio button
  And I click the 'Save cookie settings' button
  Then I see 'Your cookie settings were saved' text on the page

  Examples:
    | new_preference |
    | Yes            |
    | No             |

Scenario Outline: Returning user can set their cookie preferences and change them again
  Given I visit the /user/login page
  Then I see the 'How Digital Marketplace uses cookies' link
  And I click the '<banner_preference>' button
  Then I click the 'change your cookie settings' link
  Then I am on the 'Change your cookie settings' page
  And I don't see 'Your cookie settings have not yet been saved' text on the page
  When I choose the '<new_preference>' radio button
  And I click the 'Save cookie settings' button
  Then I see 'Your cookie settings were saved' text on the page

  Examples:
    | banner_preference | new_preference |
    | Yes               | Yes            |
    | No                | No             |
    | Yes               | No             |
    | No                | Yes            |

Scenario: User sees an error message if they submit an empty form
  Given I visit the /user/cookie-settings page
  Then I am on the 'Change your cookie settings' page
  And I click the 'Save cookie settings' button
  Then I see 'There was a problem saving your settings' text on the page
  And I don't see 'Your cookie settings were saved' text on the page

Scenario: User accepts analytics and navigates between DMP and Gov.uk
  Given I visit the homepage
  Then I see 'Can we store analytics cookies on your device?' text on the page
  And I click 'Yes' button
  When I click the 'About Government Digital Services' link
  Then I see a '_ga' tracking ID query parameter on the URL
  And a tracking pageview has been fired

Scenario: User does a search and PII is redacted from analytics
  Given I visit the homepage
  Then I see 'Can we store analytics cookies on your device?' text on the page
  And I click 'Yes' button
  When I visit the /g-cloud/search?q=joe@example.com page
  Then a tracking pageview has been fired with a redacted email

Scenario: User rejects analytics and navigates between DMP and Gov.uk
  Given I visit the homepage
  Then I see 'Can we store analytics cookies on your device?' text on the page
  And I click 'No' button
  When I visit the homepage
  And I click the 'About Government Digital Services' link
  Then I do not see a '_ga' tracking ID query parameter on the URL
  And a tracking pageview has not been fired

Scenario: User does not set analytics and navigates between DMP and Gov.uk
  Given I visit the homepage
  When I click the 'About Government Digital Services' link
  Then I do not see a '_ga' tracking ID query parameter on the URL
  And a tracking pageview has not been fired

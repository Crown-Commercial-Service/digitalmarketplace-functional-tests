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

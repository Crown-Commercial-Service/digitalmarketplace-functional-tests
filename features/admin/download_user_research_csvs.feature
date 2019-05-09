@admin @download-user-research-participants @skip-staging
Feature: Download user research participants

Scenario Outline: Correct users can view the link to download buyer user research participants
  Given I am logged in as the existing <role> user
  Then I see the 'Download potential user research participants (buyers)' link

  Examples:
    | role                    |
    | admin-framework-manager |

Scenario Outline: Correct users cannot view the link to download buyer user research participants
  Given I am logged in as the existing <role> user
  Then I don't see the 'Download list of potential user research participants' link

  Examples:
    | role                      |
    | admin                     |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-category        |
    | admin-ccs-data-controller |

@file-download
Scenario Outline: Correct users can access the page to download supplier user research participants
  Given I am logged in as the existing <role> user
  And I click the 'Download potential user research participants (suppliers)' link
  Then I am on the 'Download lists of potential user research participants' page
  When I click a link with text containing 'User research participants on'
  Then I should get a download file with filename ending '.csv' and content-type 'text/csv'

  Examples:
    | role                    |
    | admin-framework-manager |

Scenario Outline: Correct users cannot access the page to download supplier user research participants
  Given I am logged in as the existing <role> user
  Then I don't see the 'Download lists of potential user research participants' link

  Examples:
    | role                      |
    | admin                     |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-category        |
    | admin-ccs-data-controller |

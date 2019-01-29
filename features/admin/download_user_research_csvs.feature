@admin @download-user-research-participants
Feature: Download user research participants

Scenario Outline: Correct users can view the link to download buyer user research participants
  Given I am logged in as the existing <role> user
  Then I see the 'Download list of potential user research participants' link

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Correct users cannot view the link to download buyer user research participants
  Given I am logged in as the existing <role> user
  Then I don't see the 'Download list of potential user research participants' link

  Examples:
    | role                      |
    | admin-framework-manager   |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-category        |
    | admin-ccs-data-controller |

Scenario Outline: Correct users can access the page to download supplier user research participants
  Given I am logged in as the existing <role> user
  And I click the 'Download lists of potential user research participants' link
  Then I am on the 'Download lists of potential user research participants' page

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Correct users cannot access the page to download supplier user research participants
  Given I am logged in as the existing <role> user
  Then I don't see the 'Download lists of potential user research participants' link

  Examples:
    | role                      |
    | admin-framework-manager   |
    | admin-ccs-sourcing        |
    | admin-manager             |
    | admin-ccs-category        |
    | admin-ccs-data-controller |

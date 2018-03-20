@download-user-research-participants
Feature: Download user research participants

Scenario Outline: Correct users can view the link to download buyer user reseach participants
  Given I am logged in as the production <role> user
  Then I see the 'Download list of potential user research participants' link

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Correct users cannot view the link to download buyer user reseach participants
  Given I am logged in as the production <role> user
  Then I don't see the 'Download list of potential user research participants' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin-ccs-category      |

Scenario Outline: Correct users can access the page to download supplier user reseach participants
  Given I am logged in as the production <role> user
  And I click the 'Download lists of potential user research participants' link
  Then I am on the 'Download lists of potential user research participants' page

  Examples:
    | role                    |
    | admin                   |

Scenario Outline: Correct users cannot access the page to download supplier user reseach participants
  Given I am logged in as the production <role> user
  Then I don't see the 'Download lists of potential user research participants' link

  Examples:
    | role                    |
    | admin-framework-manager |
    | admin-ccs-sourcing      |
    | admin-manager           |
    | admin-ccs-category      |

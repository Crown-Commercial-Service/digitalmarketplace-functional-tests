@view_and_edit_services
Feature: Supplier being able to view their DOS services

Background:
  Given I have a live digital outcomes and specialists framework
  And I have a supplier
  And that supplier is logged in
  And that supplier is on that framework

Scenario Outline: Supplier coming from dashboard to view the detail page for one of their services
  Given that supplier has a service on the <lot_slug> lot
  And I am on the /suppliers page
  When I click 'View'
  Then I am on the 'Current services' page
  When I click '<service_name>'
  Then I am on the '<service_name>' page
  And I don't see the 'Edit' link
  And I don't see 'Remove this service' text on the page
  And I see '<expected_content>' in the '<summary_table_name>' summary table

  Examples:
    | lot_slug                   | service_name               | summary_table_name          | expected_content |
    | digital-specialists        | Digital specialists        | Individual specialist roles | Agile coach      |
    | digital-outcomes           | Digital outcomes           | Team capabilities           | Agile coaching   |
    | user-research-participants | User research participants | Recruitment approach        | Entirely offline |
    | user-research-studios      | GDSvieux Innovation Lab    | Lab address                 | GDSbury          |

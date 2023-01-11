# As DOS5 is closed, suppliers can no longer edit their services
# @supplier @view_and_edit_dos_services
# Feature: Supplier being able to view their DOS services

# Background:
#   Given I have the latest live digital-outcomes-and-specialists framework
#   And I have a supplier user
#   And that supplier is logged in
#   And that supplier has applied to be on that framework
#   And we accepted that suppliers application to the framework
#   And that supplier has returned a signed framework agreement for the framework

# Scenario Outline: Supplier coming from dashboard to view the detail page for one of their services
#   Given that supplier has a service on the <lot_slug> lot
#   And I visit the /suppliers page
# # The following step only works by virtue of there only being a single service for this supplier - multiple services on
# # multiple frameworks will cause multiple "View services" links to be present
#   When I click 'View services'
#   Then I see the page's h1 ends in 'services'
#   When I click '<service_name>'
#   Then I am on the '<service_name>' page
#   And I don't see the 'Edit' link
#   And I don't see 'Remove this service' text on the page
#   And I see '<expected_content>' in the '<summary_table_name>' summary table

#   Examples:
#     | lot_slug                   | service_name               | summary_table_name          | expected_content |
#     | digital-specialists        | Digital specialists        | Individual specialist roles | Developer        |
#     | digital-outcomes           | Digital outcomes           | Team capabilities           | Agile coaching   |
#     | user-research-participants | User research participants | Recruitment approach        | Entirely offline |
#     | user-research-studios      | GDSvieux Innovation Lab    | Research studio address     | GDSbury          |

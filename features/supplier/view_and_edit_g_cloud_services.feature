# Now that G-Cloud 12 has expired, we cannot have G-Cloud 12 services
#
# @supplier @view_and_edit_g_cloud_services
# Feature: G-Cloud supplier can view and edit their G-Cloud services

# Background:
#   # Given I have the latest live g-cloud framework with the cloud-support lot
#   And I have a supplier user
#   And that supplier is logged in
#   And that supplier has applied to be on that framework
#   And we accepted that suppliers application to the framework
#   And that supplier has returned a signed framework agreement for the framework
#   And that supplier has a service on the cloud-support lot
#   And I ensure that all update audit events for that service are acknowledged
#   When I visit the /suppliers page
#   # The following step only works by virtue of there only being a single service for this supplier - multiple services on
#   # multiple frameworks will cause multiple "View services" links to be present
#   And I click 'View services'
#   # Two steps below so we can assert the page title for either G9 or G10
#   Then I am on the 'Your G-Cloud' page
#   And I see the page's h1 ends in 'services'
#   When I click that service.serviceName
#   Then I am on that service.serviceName page

# Scenario: Supplier user can edit the name of a service
#   When I click the top-level summary table 'Edit' link for the section 'Service name'
#   Then I am on the 'Service name' page
#   And I enter 'Changed cloud support service' in the 'serviceName' field
#   And I click 'Save and return'
#   Then I am on the 'Changed cloud support service' page
#   And I see a success flash message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
#   And that service has unacknowledged update audit events
#   # tidy up
#   Then I ensure that all update audit events for that service are acknowledged

# Scenario: Supplier user can edit the description of a service
#   Given I see the 'About your service' summary table filled with:
#     | field                        | value                                             |
#     | Service description          | Deliver digital transformation by the bucketload! |
#   When I click the top-level summary table 'Edit' link for the section 'About your service'
#   Then I am on the 'About your service' page
#   And I enter 'This is an updated description' in the 'serviceDescription' field
#   And I click 'Save and return'
#   Then I am on that service.serviceName page
#   And I see a success flash message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
#   And I see the 'About your service' summary table filled with:
#     | field                        | value                          |
#     | Service description          | This is an updated description |
#   And that service has unacknowledged update audit events
#   # tidy up
#   Then I ensure that all update audit events for that service are acknowledged

# Scenario: Supplier user can edit the features and benefits of a service
#   Given I see the 'Service features and benefits' summary table filled with:
#     | field                         | value                                                           |
#     | Service features and benefits | Service features Feature 1 Service benefits Benefit 1 Benefit 2 |
#   When I click the top-level summary table 'Edit' link for the section 'Service features and benefits'
#   Then I am on the 'Service features and benefits' page
#   And I enter 'New Feature 2' in the 'input-serviceFeatures-2' field
#   And I enter 'Updated Benefit 2' in the 'input-serviceBenefits-2' field
#   And I click 'Save and return'
#   Then I am on that service.serviceName page
#   And I see a success flash message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
#   And I see the 'Service features and benefits' summary table filled with:
#     | field                         | value                                                                                  |
#     | Service features and benefits | Service features Feature 1 New Feature 2 Service benefits Benefit 1 Updated Benefit 2  |
#   And that service has unacknowledged update audit events
#   # tidy up
#   Then I ensure that all update audit events for that service are acknowledged

# @requires-credentials @file-upload
# Scenario: Supplier user can replace the service definition document
#   When I click the top-level summary table 'Edit' link for the section 'Documents'
#   Then I am on the 'Documents' page
#   And I choose file 'test.pdf' for the field 'serviceDefinitionDocumentURL'
#   And I click 'Save and return'
#   Then I am on that service.serviceName page
#   And I see a success flash message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
#   And that service has unacknowledged update audit events
#   # tidy up
#   Then I ensure that all update audit events for that service are acknowledged

# @requires-credentials @file-upload
# Scenario: Supplier user can not replace the service definition document with a non-pdf file
#   When I click the top-level summary table 'Edit' link for the section 'Documents'
#   Then I am on the 'Documents' page
#   And I choose file 'word.docx' for the field 'serviceDefinitionDocumentURL'
#   And I click 'Save and return'
#   Then I am on the 'Documents' page
#   And I see a validation message containing 'an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).'
#   And that service has no unacknowledged update audit events

# @requires-credentials @file-upload
# Scenario: Supplier user can not replace the service definition document with a file over 5MB
#   When I click the top-level summary table 'Edit' link for the section 'Documents'
#   Then I am on the 'Documents' page
#   And I choose file '6mb.pdf' for the field 'serviceDefinitionDocumentURL'
#   And I click 'Save and return'
#   Then I am on the 'Documents' page
#   And I see a validation message containing '5MB'
#   And that service has no unacknowledged update audit events

# Scenario: Supplier can remove their G-Cloud service from the marketplace
#   When I click 'Remove service'
#   Then I see a destructive banner message containing 'Are you sure you want to remove your service?'

#   When I click 'Remove service'
#   Then I see a success flash message containing 'Test cloud support service has been removed.'

#   When I click that service.serviceName
#   Then I see a temporary-message banner message containing 'This service was removed'
#   And that service has no unacknowledged update audit events

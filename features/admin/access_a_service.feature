# Now that G-Cloud 12 has expired, we cannot edit G-Cloud services
#
# @admin @admin-service-access
# Feature: Admins viewing, editing, removing and publishing supplier services

# Background:
#   Given I have a published service on a live G-Cloud framework

# Scenario: Admin with Service Manager role can edit, remove and publish a service
#   Given I ensure that all update audit events for that service are acknowledged
#   And I am logged in as the existing admin-ccs-category user
#   And I am on the 'Admin' page
#   When I click 'Edit suppliers and services'
#   Then I am on the 'Edit suppliers and services' page
#   And I click the 'Service ID' link
#   When I enter that service id in the 'service_id' field and click its associated 'Search' button
#   Then I am on that service's page

#   When I click the top-level summary table 'Edit' link for the section 'About your service'
#   Then I am on the 'About your service' page
#   When I enter 'Plant-based cloud hosting' in the 'serviceName' field and click its associated 'Save and return to summary' button
#   Then I am on the 'Plant-based cloud hosting' page
#   # edits by admins shouldn't result in update audit events that need acknowledgement
#   And that service has no unacknowledged update audit events

#   When I click the 'Remove service' link
#   Then I see a destructive banner message containing 'Are you sure you want to remove ‘Plant-based cloud hosting’?'
#   When I click 'Remove'
#   Then I see a temporary-message banner message containing 'Removed by '
#   And I see a temporary-message banner message containing that user.emailAddress
#   When I click 'Publish service'
#   Then I see a destructive banner message containing 'Are you sure you want to publish ‘Plant-based cloud hosting’?'
#   When I click 'Publish'
#   Then I see a success banner message containing 'You published ‘Plant-based cloud hosting’.'

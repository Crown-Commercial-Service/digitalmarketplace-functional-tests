@edit-a-service
Feature: Edit a service

Background:
  Given I have a published service on a live G-Cloud framework

Scenario: Admin with Service Manager role can edit services
  Given I am logged in as the production admin-ccs-category user
  And I am on the 'Admin' page
  When I click 'Edit suppliers and services'
  Then I am on 'Edit suppliers and services' page
  When I enter that service id in the 'service_id' field and click its associated 'Search' button
  Then I am on that service's editable page

  When I click the top-level summary table 'Edit' link for the section 'About your service'
  Then I am on 'About your service' page
  When I enter 'Plant-based cloud hosting' in the 'serviceName' field # TODO: find a right step or this

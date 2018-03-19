@view_and_edit_g_cloud_services
Feature: G-Cloud supplier can view and edit their G-Cloud services

Background:
  Given I have a live g-cloud framework with the cloud-support lot
  And I have a supplier user
  And that supplier is logged in
  And that supplier has applied to be on that framework
  And we accept that suppliers application to the framework
  And that supplier returns a signed framework agreement for the framework
  And that supplier has a service on the cloud-support lot
  When I am on the /suppliers page
  # The following step only works by virtue of there only being a single service for this supplier - multiple services on
  # multiple frameworks will cause multiple "View services" links to be present
  And I click 'View services'
  Then I am on the 'G-Cloud 9 services' page
  When I click 'Test cloud support service'
  Then I am on the 'Test cloud support service' page

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the name of a service
  When I click the top-level summary table 'Edit' link for the section 'Service name'
  Then I am on the 'Service name' page
  And I enter 'Changed cloud support service' in the 'serviceName' field
  And I click 'Save and return'
  Then I am on the 'Changed cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the name of a service
  When I click the top-level summary table 'Edit' link for the section 'Service name'
  Then I am on the 'Service name' page
  And I enter 'Changed cloud support service' in the 'serviceName' field
  And I click 'Save and return to service'
  Then I am on the 'Changed cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the description of a service
  Given I see the 'About your service' summary table filled with:
    | field                        | value                                             |
    | Service description          | Deliver digital transformation by the bucketload! |
  When I click the top-level summary table 'Edit' link for the section 'About your service'
  Then I am on the 'About your service' page
  And I enter 'This is an updated description' in the 'serviceDescription' field
  And I click 'Save and return'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
  And I see the 'About your service' summary table filled with:
    | field                        | value                          |
    | Service description          | This is an updated description |

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the description of a service
  Given I see the 'About your service' summary table filled with:
    | field                        | value                                             |
    | Service description          | Deliver digital transformation by the bucketload! |
  When I click the top-level summary table 'Edit' link for the section 'About your service'
  Then I am on the 'About your service' page
  And I enter 'This is an updated description' in the 'serviceDescription' field
  And I click 'Save and return to service'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
  And I see the 'About your service' summary table filled with:
    | field                        | value                          |
    | Service description          | This is an updated description |

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the features and benefits of a service
  Given I see the 'Service features and benefits' summary table filled with:
    | field                         | value                                                                                  |
    | Service features and benefits | Service features Feature 1 Service benefits Benefit 1 Benefit 2  |
  When I click the top-level summary table 'Edit' link for the section 'Service features and benefits'
  Then I am on the 'Service features and benefits' page
  And I enter 'New Feature 2' in the 'input-serviceFeatures-2' field
  And I enter 'Updated Benefit 2' in the 'input-serviceBenefits-2' field
  And I click 'Save and return'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
  And I see the 'Service features and benefits' summary table filled with:
    | field                         | value                                                                                  |
    | Service features and benefits | Service features Feature 1 New Feature 2 Service benefits Benefit 1 Updated Benefit 2  |

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can edit the features and benefits of a service
  Given I see the 'Service features and benefits' summary table filled with:
    | field                         | value                                                                                  |
    | Service features and benefits | Service features Feature 1 Service benefits Benefit 1 Benefit 2  |
  When I click the top-level summary table 'Edit' link for the section 'Service features and benefits'
  Then I am on the 'Service features and benefits' page
  And I enter 'New Feature 2' in the 'input-serviceFeatures-2' field
  And I enter 'Updated Benefit 2' in the 'input-serviceBenefits-2' field
  And I click 'Save and return to service'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'
  And I see the 'Service features and benefits' summary table filled with:
    | field                         | value                                                                                  |
    | Service features and benefits | Service features Feature 1 New Feature 2 Service benefits Benefit 1 Updated Benefit 2  |

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can replace the service definition document
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file 'test.pdf' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can replace the service definition document
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file 'test.pdf' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return to service'
  Then I am on the 'Test cloud support service' page
  And I see a success banner message containing 'You’ve edited your service. The changes are now live on the Digital Marketplace.'

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can not replace the service definition document with a non-pdf file
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file 'word.docx' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return'
  Then I am on the 'Documents' page
  And I see a validation message containing 'Your document is not in an open format. Please save as an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).'

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can not replace the service definition document with a non-pdf file
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file 'word.docx' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return to service'
  Then I am on the 'Documents' page
  And I see a validation message containing 'Your document is not in an open format. Please save as an Open Document Format (ODF) or PDF/A (eg .pdf, .odt).'

@skip-staging # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can not replace the service definition document with a file over 5MB
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file '6mb.pdf' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return'
  Then I am on the 'Documents' page
  And I see a validation message containing 'Your document exceeds the 5MB limit. Please reduce file size.'

@skip-preview # Temporary duplicate scenario to be removed after new button content is release to staging.
Scenario: Supplier user can not replace the service definition document with a file over 5MB
  When I click the top-level summary table 'Edit' link for the section 'Documents'
  Then I am on the 'Documents' page
  And I choose file '6mb.pdf' for the field 'serviceDefinitionDocumentURL'
  And I click 'Save and return to service'
  Then I am on the 'Documents' page
  And I see a validation message containing 'Your document exceeds the 5MB limit. Please reduce file size.'

Scenario: Supplier can remove their G-Cloud service from the marketplace
  When I click 'Remove service'
  Then I see a destructive banner message containing 'Are you sure you want to remove your service?'

  When I click 'Remove service'
  Then I see a success banner message containing 'Test cloud support service has been removed.'

  When I click 'Test cloud support service'
  Then I see a temporary-message banner message containing 'This service was removed'

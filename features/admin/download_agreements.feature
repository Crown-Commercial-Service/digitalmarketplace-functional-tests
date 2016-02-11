@not-production @functional-test
Feature: Admin users can download signed framework agreements

Scenario: Setup for tests
  Given I have test suppliers
  And no 'g-cloud-7' framework agreements exist
  And no 'digital-outcomes-and-specialists' framework agreements exist

Scenario: When there are no framework agreements the list is empty: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  And I click 'G-Cloud 7 agreements'
  Then the framework agreement list is empty

Scenario: When there are no framework agreements the list is empty: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  And I click 'Digital Outcomes and Specialists agreements'
  Then the framework agreement list is empty

Scenario: Most recently uploaded agreements should be shown first: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11112'
  When I click 'G-Cloud 7 agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier 2'
  When I click the first download agreement link
  Then I should get redirected to the correct 'g-cloud-7' S3 URL for supplier '11112'

Scenario: Most recently uploaded agreements should be shown first: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11112'
  When I click 'Digital Outcomes and Specialists agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier 2'
  When I click the first download agreement link
  Then I should get redirected to the correct 'digital-outcomes-and-specialists' S3 URL for supplier '11112'

Scenario: Re-uploading an agreement brings it to the top of the list: G-Cloud 7
  Given I have logged in to Digital Marketplace as a 'Administrator' user
  When a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11112'
  And a 'g-cloud-7' signed agreement is uploaded for supplier '11111'
  When I click 'G-Cloud 7 agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier'
  When I click the first download agreement link
  Then I should get redirected to the correct 'g-cloud-7' S3 URL for supplier '11111'

Scenario: Re-uploading an agreement brings it to the top of the list: Digital Outcomes and Specialists
  Given I have logged in to Digital Marketplace as a 'CCS Sourcing' user
  When a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11112'
  And a 'digital-outcomes-and-specialists' signed agreement is uploaded for supplier '11111'
  When I click 'Digital Outcomes and Specialists agreements'
  Then the first signed agreement should be for supplier 'DM Functional Test Supplier'
  When I click the first download agreement link
  Then I should get redirected to the correct 'digital-outcomes-and-specialists' S3 URL for supplier '11111'

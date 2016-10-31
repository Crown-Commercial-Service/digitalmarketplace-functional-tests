@not-production @functional-test @ssp-dos
Feature: Submitting a new DOS service for User research studios
  In order to submit my services as a supplier user
  I want to answer questions about my service

  Background: Log in as a supplier
    Given I am on the 'Digital Marketplace' login page
    When I login as a 'Supplier' user
    Then I should be on the supplier home page

  Scenario: Select User research studios as a service to add
    Given I am at '/suppliers'
    When I click 'Continue your Digital Outcomes and Specialists 2 application'
    Then I am taken to the 'Apply to Digital Outcomes and Specialists' page

    When I click 'Add, edit and complete services'
    Then I am taken to the 'Your Digital Outcomes and Specialists 2 services' page

    When I click 'Apply to provide user research studios'
    Then I should be on the 'User research studios services' page

  Scenario: Provide a lab name
    Given I am at the 'User research studios services' page
    When I click 'Add a service'
    Then I am taken to the 'Lab name' page

    When I fill in 'serviceName' with 'My user research studio'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio' page

  @listing_page
  Scenario: Go to listing page and the service that is not complete
    Given I am at the 'User research studios services' page
    Then My service should be in the list

    When I click the link for 'my service'
    Then I should be on the 'My user research studio' page
    And The string 'Answer required' should be on the page
    And The 'Mark as complete' button should not be on the page

  Scenario: Edit lab name
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Lab name'
    Then I should be on the 'Lab name' page

    When I fill in 'serviceName' with 'My user research studio service'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Lab address
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Lab address'
    Then I should be on the 'Lab address' page

    When I fill in 'labAddressBuilding' with 'No 1 Test Street'
    And I fill in 'labAddressTown' with 'Test Town'
    And I fill in 'labAddressPostcode' with 'TE57ME'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Transport
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Transport'
    Then I should be on the 'Transport' page

    When I fill in 'labPublicTransport' with 'Take bus 786 towards the radio tower and get off at the Testlington Street'
    And I fill in 'labCarPark' with 'Customer parking available underground'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: A draft service has been created
    Given I am at the 'User research studios services' page
    Then There 'is a' draft 'My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'is a' draft 'user research studios' service(s)

  Scenario: Provide Lab size
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Lab size'
    Then I should be on the 'Lab size' page

    When I fill in 'labSize' with 'Thirty 2'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Viewing info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Viewing'
    Then I should be on the 'Viewing' page

    When I choose 'Yes – included as standard' for 'labViewingArea'
    And I choose 'Yes – for an additional cost' for 'labStreaming'
    And I choose 'No' for 'labDesktopStreaming'
    And I choose 'Yes – for an additional cost' for 'labDeviceStreaming'
    And I choose 'No' for 'labEyeTracking'
    And I choose 'No' for 'labWiFi'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Technical assistance info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Technical assistance'
    Then I should be on the 'Technical assistance' page

    When I choose 'Yes – included as standard' for 'labTechAssistance'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Hospitality info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Hospitality'
    Then I should be on the 'Hospitality' page

    When I choose 'Yes – for an additional cost' for 'labHosting'
    And I choose 'Yes – included as standard' for 'labWaitingArea'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Facilities info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Facilities'
    Then I should be on the 'Facilities' page

    When I choose 'Yes' for 'labToilets'
    And I choose 'No' for 'labBabyChanging'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Accessibility info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Accessibility'
    Then I should be on the 'Accessibility' page

    When I fill in 'labAccessibility' with 'Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Provide Price info
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Edit' link for 'Price'
    Then I should be on the 'Price' page

    When I fill in 'labPriceMin' with '158'
    And I select '2 hours' from 'labTimeMin'
    And I click 'Save and continue'
    Then I should be on the 'My user research studio service' page

  Scenario: Verify text on summary page
    Given I am on the summary page
    Then Summary table row 'What is the name of the lab?' under the heading 'Lab name' should contain 'My user research studio service'
    And Summary table row 'Building and street' under the heading 'Lab address' should contain 'No 1 Test Street'
    And Summary table row 'Town or city' under the heading 'Lab address' should contain 'Test Town'
    And Summary table row 'Postcode' under the heading 'Lab address' should contain 'TE57ME'
    And Summary table row 'How do visitors get to your studio using public transport?' under the heading 'Transport' should contain 'Take bus 786 towards the radio tower and get off at the Testlington Street'
    And Summary table row 'Where can visitors to your studio park?' under the heading 'Transport' should contain 'Customer parking available underground'
    And Summary table row 'How many people can the lab accommodate?' under the heading 'Lab size' should contain 'Thirty 2'
    And Summary table row 'Do you have a viewing area?' under the heading 'Viewing' should contain 'Yes – included as standard'
    And Summary table row 'Do you provide remote streaming from the lab?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you stream a view of the desktop or laptop screen?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you stream a view of a mobile or tablet device?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide eye-tracking?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide Wi-Fi?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide help with studio equipment and streaming?' under the heading 'Technical assistance' should contain 'Yes – included as standard'
    And Summary table row 'Do you welcome and host participants?' under the heading 'Hospitality' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide a waiting area?' under the heading 'Hospitality' should contain 'Yes – included as standard'
    And Summary table row 'Do you provide toilets?' under the heading 'Facilities' should contain 'Yes'
    And Summary table row 'Do you provide baby-changing facilities?' under the heading 'Facilities' should contain 'No'
    And Summary table row 'How accessible is your studio?' under the heading 'Accessibility' should contain 'Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And Summary table row 'What is the minimum amount of time your lab can be booked for and how much does it cost (excluding VAT)?' under the heading 'Price' should contain '2 hours for £158'

  Scenario: Make a copy of a draft service
    Given I am at the 'User research studios services' page
    When I click the 'Make a copy' button for the 'draft' service 'My user research studio service'
    Then I am taken to the 'Lab name' page

    When I fill in 'serviceName' with 'COPY OF DRAFT-My user research studio service'
    And I click 'Save and continue'
    Then I am taken to the 'COPY OF DRAFT-My user research studio service' page

  Scenario:Verify that the draft has the same data as the original draft service apart from the service name
    Given I am on the summary page for the copy of the 'draft' service
    Then Summary table row 'What is the name of the lab?' under the heading 'Lab name' should contain 'COPY OF DRAFT-My user research studio service'
    And Summary table row 'Building and street' under the heading 'Lab address' should contain 'No 1 Test Street'
    And Summary table row 'Town or city' under the heading 'Lab address' should contain 'Test Town'
    And Summary table row 'Postcode' under the heading 'Lab address' should contain 'TE57ME'
    And Summary table row 'How do visitors get to your studio using public transport?' under the heading 'Transport' should contain 'Take bus 786 towards the radio tower and get off at the Testlington Street'
    And Summary table row 'Where can visitors to your studio park?' under the heading 'Transport' should contain 'Customer parking available underground'
    And Summary table row 'How many people can the lab accommodate?' under the heading 'Lab size' should contain 'Thirty 2'
    And Summary table row 'Do you have a viewing area?' under the heading 'Viewing' should contain 'Yes – included as standard'
    And Summary table row 'Do you provide remote streaming from the lab?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you stream a view of the desktop or laptop screen?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you stream a view of a mobile or tablet device?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide eye-tracking?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide Wi-Fi?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide help with studio equipment and streaming?' under the heading 'Technical assistance' should contain 'Yes – included as standard'
    And Summary table row 'Do you welcome and host participants?' under the heading 'Hospitality' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide a waiting area?' under the heading 'Hospitality' should contain 'Yes – included as standard'
    And Summary table row 'Do you provide toilets?' under the heading 'Facilities' should contain 'Yes'
    And Summary table row 'Do you provide baby-changing facilities?' under the heading 'Facilities' should contain 'No'
    And Summary table row 'How accessible is your studio?' under the heading 'Accessibility' should contain 'Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And Summary table row 'What is the minimum amount of time your lab can be booked for and how much does it cost (excluding VAT)?' under the heading 'Price' should contain '2 hours for £158'

  Scenario:Check navigation via "Back to user research studios" link
    Given I am on the summary page for the copy of the 'draft' service
    When I click 'Back to user research studios'
    Then I am at the 'User research studios services' page

  Scenario:Verify copy of draft service is presented on page
    Given I am at the 'User research studios services' page
    Then There 'is a' draft 'My user research studio service' service(s)
    Then There 'is a' draft 'COPY OF DRAFT-My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'are' draft 'user research studios' service(s)

  @mark_as_complete
  Scenario: Mark service as complete
    Given I am on the ssp page for the 'user-research-studios' service
    When I click the 'Mark as complete' button at the 'top' of the page
    Then I am taken to the 'User research studios services' page
    And I am presented with the message 'My user research studio service was marked as complete'
    And There 'is a' completed 'My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'is a' completed 'user research studios' service(s)

  Scenario: Edit service that has been completed
    Given I am at the 'User research studios services' page
    When I click the link for 'my completed service'
    And I click the 'Edit' link for 'Lab name'
    And I fill in 'serviceName' with 'NEW-My user research studio service'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Lab address'
    And I fill in 'labAddressBuilding' with 'NEW-No 1 Test Street'
    And I fill in 'labAddressTown' with 'NEW-Test Town'
    And I fill in 'labAddressPostcode' with 'NEW-TE57ME'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Transport'
    And I fill in 'labPublicTransport' with 'NEW-Take bus 786 towards the radio tower and get off at the Testlington Street'
    And I fill in 'labCarPark' with 'NEW-Customer parking available underground'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Lab size'
    And I fill in 'labSize' with 'NEW-Thirty 2'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Viewing'
    And I choose 'No' for 'labViewingArea'
    And I choose 'No' for 'labStreaming'
    And I choose 'Yes – for an additional cost' for 'labDesktopStreaming'
    And I choose 'No' for 'labDeviceStreaming'
    And I choose 'Yes – for an additional cost' for 'labEyeTracking'
    And I choose 'Yes' for 'labWiFi'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Technical assistance'
    And I choose 'Yes – for an additional cost' for 'labTechAssistance'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Hospitality'
    And I choose 'No' for 'labHosting'
    And I choose 'No' for 'labWaitingArea'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Facilities'
    And I choose 'No' for 'labToilets'
    And I choose 'Yes' for 'labBabyChanging'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Accessibility'
    And I fill in 'labAccessibility' with 'NEW-Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And I click 'Save and continue'

    When I click the 'Edit' link for 'Price'
    And I fill in 'labPriceMin' with '4321'
    And I select '8 hours' from 'labTimeMin'
    And I click 'Save and continue'

  Scenario: Verify text of edit made on service that is marked as completed
    Given I am on the summary page of the completed service
    Then Summary table row 'What is the name of the lab?' under the heading 'Lab name' should contain 'NEW-My user research studio service'
    And Summary table row 'Building and street' under the heading 'Lab address' should contain 'NEW-No 1 Test Street'
    And Summary table row 'Town or city' under the heading 'Lab address' should contain 'NEW-Test Town'
    And Summary table row 'Postcode' under the heading 'Lab address' should contain 'NEW-TE57ME'
    And Summary table row 'How do visitors get to your studio using public transport?' under the heading 'Transport' should contain 'NEW-Take bus 786 towards the radio tower and get off at the Testlington Street'
    And Summary table row 'Where can visitors to your studio park?' under the heading 'Transport' should contain 'NEW-Customer parking available underground'
    And Summary table row 'How many people can the lab accommodate?' under the heading 'Lab size' should contain 'NEW-Thirty 2'
    And Summary table row 'Do you have a viewing area?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide remote streaming from the lab?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you stream a view of the desktop or laptop screen?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you stream a view of a mobile or tablet device?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide eye-tracking?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide Wi-Fi?' under the heading 'Viewing' should contain 'Yes'
    And Summary table row 'Do you provide help with studio equipment and streaming?' under the heading 'Technical assistance' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you welcome and host participants?' under the heading 'Hospitality' should contain 'No'
    And Summary table row 'Do you provide a waiting area?' under the heading 'Hospitality' should contain 'No'
    And Summary table row 'Do you provide toilets?' under the heading 'Facilities' should contain 'No'
    And Summary table row 'Do you provide baby-changing facilities?' under the heading 'Facilities' should contain 'Yes'
    And Summary table row 'How accessible is your studio?' under the heading 'Accessibility' should contain 'NEW-Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And Summary table row 'What is the minimum amount of time your lab can be booked for and how much does it cost (excluding VAT)?' under the heading 'Price' should contain '8 hours for £4321'

  Scenario: Make a copy of a completed service
    Given I am at the 'User research studios services' page
    When I click the 'Make a copy' button for the 'completed' service 'NEW-My user research studio service'
    Then I am taken to the 'Lab name' page

    When I fill in 'serviceName' with 'COPY OF COMPLETED-My user research studio service'
    And I click 'Save and continue'
    Then I should be on the 'COPY OF COMPLETED-My user research studio service' page

  Scenario:Verify that the draft has the same data as the original completed service apart from the service name
    Given I am on the summary page for the copy of the 'completed' service
    Then Summary table row 'What is the name of the lab?' under the heading 'Lab name' should contain 'COPY OF COMPLETED-My user research studio service'
    And Summary table row 'Building and street' under the heading 'Lab address' should contain 'NEW-No 1 Test Street'
    And Summary table row 'Town or city' under the heading 'Lab address' should contain 'NEW-Test Town'
    And Summary table row 'Postcode' under the heading 'Lab address' should contain 'NEW-TE57ME'
    And Summary table row 'How do visitors get to your studio using public transport?' under the heading 'Transport' should contain 'NEW-Take bus 786 towards the radio tower and get off at the Testlington Street'
    And Summary table row 'Where can visitors to your studio park?' under the heading 'Transport' should contain 'NEW-Customer parking available underground'
    And Summary table row 'How many people can the lab accommodate?' under the heading 'Lab size' should contain 'NEW-Thirty 2'
    And Summary table row 'Do you have a viewing area?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide remote streaming from the lab?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you stream a view of the desktop or laptop screen?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you stream a view of a mobile or tablet device?' under the heading 'Viewing' should contain 'No'
    And Summary table row 'Do you provide eye-tracking?' under the heading 'Viewing' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you provide Wi-Fi?' under the heading 'Viewing' should contain 'Yes'
    And Summary table row 'Do you provide help with studio equipment and streaming?' under the heading 'Technical assistance' should contain 'Yes – for an additional cost'
    And Summary table row 'Do you welcome and host participants?' under the heading 'Hospitality' should contain 'No'
    And Summary table row 'Do you provide a waiting area?' under the heading 'Hospitality' should contain 'No'
    And Summary table row 'Do you provide toilets?' under the heading 'Facilities' should contain 'No'
    And Summary table row 'Do you provide baby-changing facilities?' under the heading 'Facilities' should contain 'Yes'
    And Summary table row 'How accessible is your studio?' under the heading 'Accessibility' should contain 'NEW-Wheelchair accessible, lifts and toilets accommodate wheelchairs.'
    And Summary table row 'What is the minimum amount of time your lab can be booked for and how much does it cost (excluding VAT)?' under the heading 'Price' should contain '8 hours for £4321'

  Scenario:Verify copy of completed service is presented on page
    Given I am at the 'User research studios services' page
    Then There 'is a' draft 'My user research studio service' service(s)
    Then There 'is a' draft 'COPY OF COMPLETED-My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'are' draft 'user research studios' service(s)

  Scenario: Add another user research studio service
    Given I am at the 'User research studios services' page
    When I click 'Add a service'
    Then I am taken to the 'Lab name' page

    When I fill in 'serviceName' with 'My second user research studio service'
    And I click 'Save and continue'
    Then I should be on the 'My second user research studio service' page

  @listing_page
  Scenario: The listing page should show draft services and complete services
    Given I am at the 'User research studios services' page
    Then There 'is a' draft 'My second user research studio service' service(s)
    And There 'is a' completed 'NEW-My user research studio service' service(s)

  @delete_service
  Scenario: Delete a draft service
    Given I am at the 'User research studios services' page
    When I click the link for 'my service'
    Then I should be on the 'My second user research studio service' page

    When I click 'Delete'
    Then I am presented with the message 'Are you sure you want to delete this lab?'

    When I click 'Yes, delete'
    Then I am taken to the 'User research studios services' page
    And I am presented with the message 'My second user research studio service was deleted'
    And There 'is no' draft 'My second user research studio service' service(s)
    And There 'is a' draft 'COPY OF COMPLETED-My user research studio service' service(s)
    And There 'is a' draft 'COPY OF DRAFT-My user research studio service' service(s)
    And There 'is a' completed 'NEW-My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    Then There 'are' draft 'user research studios' service(s)
    And There 'is a' completed 'user research studios' service(s)

  @delete_service
  Scenario: Delete a completed service
    Given I am at the 'User research studios services' page
    When I click the link for 'my completed service'
    Then I should be on the 'NEW-My user research studio service' page

    When I click 'Delete'
    Then I am presented with the message 'Are you sure you want to delete this lab?'

    When I click 'Yes, delete'
    Then I am taken to the 'User research studios services' page
    And I am presented with the message 'NEW-My user research studio service was deleted'
    And There 'is no' draft 'NEW-My user research studio service' service(s)
    And There 'is no' completed 'NEW-My user research studio service' service(s)

    When I am at the 'Your Digital Outcomes and Specialists 2 services' page
    And There 'are' draft 'user research studios' service(s)
    And There 'are no' completed 'user research studios' service(s)

  @delete_service
  Scenario: Delete other draft services
    Given I am at the 'User research studios services' page
    When I delete the 'COPY OF COMPLETED-My user research studio service' service
    And I delete the 'COPY OF DRAFT-My user research studio service' service
    Then There 'are no' draft 'user research studios' service(s)

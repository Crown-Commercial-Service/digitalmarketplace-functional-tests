@supplier @supplier_account @gideon_test
Feature: Supplier can sign an agreement electronically

  Background:
    Given I have the latest live or standstill framework
    And I have a supplier user
    And that supplier has applied to be on that framework
    And we accepted that suppliers application to the framework
    And that supplier is logged in
    And that supplier has set company name as Acme Company

  Scenario: Supplier can electronically sign a framework agreement
    Given I visit the start sign framework agreement page for that framework
    Then I am on 'Do you have the legal authority to sign on behalf of your company?' page
    And I choose 'Yes' radio button
    When I click 'Continue' button
    Then I am on 'Supplier appointment terms' page
    And I see 'company: Acme Company' within the page's text
    When I enter 'Jane Doe' in the 'Your full name' field
    And I enter 'Director' in the 'Your role in the company' field
    And I check 'I accept the terms and conditions of the Framework Agreement' checkbox
    When I click 'Sign agreement' button
    Then I see the sign agreement confirmation page


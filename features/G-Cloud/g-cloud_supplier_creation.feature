@not-production @functional-test @ssp
Feature: Create new G-Cloud supplier account

Scenario: User steps through supplier account creation process
  Given I am on the 'Digital Marketplace' landing page
  When I click 'Create supplier account'
  Then I am on the 'Create supplier account' page

  When I click the 'Start' button
  Then I am on the 'DUNS number' page

  When I enter '000000001' in the 'duns_number' field
  And I click 'Continue'
  Then I am on the 'Companies House number (optional)' page

  When I enter 'A0000001' in the 'companies_house_number' field
  And I click 'Continue'
  Then I am on the 'Company name' page

  When I enter 'This is a test company name' in the 'company_name' field
  And I click 'Continue'
  Then I am on the 'Company contact details' page

  When I enter 'Company contact name' in the 'contact_name' field
  Then I enter 'test.company.email@test.com' in the 'email_address' field
  Then I enter '0123456789' in the 'phone_number' field
  And I click 'Continue'
  Then I am on the 'Create login' page

  When I enter 'test.supplier.email@test.com' in the 'email_address' field
  And I click 'Continue'
  Then I am on the 'Check your information' page
  And All the information that was submitted is presented correctly on the page
  And There is an Edit link for each of the company information

  When I change the 'duns_number' to '000000002'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'companies_house_number' to 'A0000002'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'company_name' to 'Changed the test company name'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'contact_name' to 'Changed the company contact name'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'contact_email_address' to 'changed.test.company.email@test.com'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'phone_number' to '9876543210'
  Then The change made is reflected on the 'Check your information' page

  When I change the 'your_email_address' to 'changed.test.supplier.email@test.com'
  Then The change made is reflected on the 'Check your information' page

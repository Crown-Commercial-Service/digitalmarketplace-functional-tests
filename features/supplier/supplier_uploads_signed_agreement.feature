@supplier @file-upload @file-download @requires-credentials
Feature: Supplier uploads a signed agreement for a framework

Background:
  Given I have the latest live g-cloud framework
  And I have a supplier user
  And that supplier has applied to be on that framework
  And we accepted that suppliers application to the framework
  And that supplier has a service on the 'cloud-support' lot
  And that supplier is logged in

Scenario: Supplier successfully uploads a signed agreement for a framework
  Given I visit the /suppliers page
  Then I don't see a 'View documents and ask a question' link
  And I don't see a 'View services' link
  When I click the 'You must sign the framework agreement to sell these services' link
  Then I see the page's h1 ends in 'framework agreement'
  And I see that framework.name in the page's h1
  # TODO set up this supplier's draft services so the lot table on this page can be asserted - however this
  # is tricky to set up as it currently requires switching framework states to achieve
  When I click the 'Return your signed signature page' button
  Then I see 'Details of the person' in the page's h1
  And I see the page's h1 ends in that declaration.supplierRegisteredName
  When I enter 'Mr Cornelius Kelleher' in the 'Full name' field
  And I enter 'Manager' in the 'Role at the company' field
  And I click the 'Save and continue' button
  Then I am on the 'Upload your signed signature' page
  When I choose file 'test.pdf' for the field 'signature_page'
  And I click the 'Save and continue' button
  Then I see 'Check the details' in the page's h1
  And I see the page's h1 ends in that declaration.supplierRegisteredName
  And I see the 'Supplier information' summary table filled with:
    |field            |value                        |
    |Person who signed|Mr Cornelius Kelleher Manager|
    |Signature page   |test.pdf                     |
  And I see the 'I have the authority to return' checkbox is not checked
  When I check the 'I have the authority to return' checkbox
  And I click the 'Return signed signature page' button
  Then I receive a 'contract-review-agreement' email for that declaration.primaryContactEmail
  And I receive a 'contract-review-agreement' email for that supplier_user.emailAddress
  And I see that framework.name in the page's h1
  And I see the page's h1 ends in 'documents'
  And I see a success banner message containing 'Your framework agreement has been returned to the Crown Commercial Service to be countersigned'
  And I see an entry in the 'Agreement details' table with:
    |field            |value                        |
    |Person who signed|Mr Cornelius Kelleher Manager|
  And I see an entry in the 'Agreement details' table with:
    |field           |value                         |
    |Countersignature|Waiting for CCS to countersign|
  And I see that supplier_user.name in the 'Agreement details' summary table
  And I see that supplier_user.emailAddress in the 'Agreement details' summary table
  When I click 'Download your ‘original’ framework agreement signature page'
  Then I should get an inline file with filename ending '.pdf' and content type 'application/pdf' in a new window

  When I re-visit the /suppliers page
  Then I see a 'View documents and ask a question' link
  And I see a 'View services' link
  And I don't see a 'You must sign the framework agreement to sell these services' link


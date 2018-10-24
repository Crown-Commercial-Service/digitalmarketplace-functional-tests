Feature: Antivirus scanning

@notify @file-upload @requires-aws-credentials @skip-local
Scenario: Uploading an infected file to a bucket should generate a warning email
  Given I have a randomized file containing the eicar test signature
  When I upload that file to the documents bucket under the key 'functional_tests/bad.pdf'
  Then I receive a notification regarding that file within 4 minutes

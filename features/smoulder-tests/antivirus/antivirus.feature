@skip-preview @skip-staging @skip-production
Feature: Antivirus scanning

@smoulder-tests @antivirus @notify @file-upload @requires-aws-credentials @skip-local
Scenario: Uploading an infected file to a bucket should generate a warning email
  Given I have a randomized file containing the eicar test signature
  When I upload that file to the documents bucket under the key 'functional_tests/we?rd d%r+name❡/bad.csv'
  Then I receive a notification regarding that file within 4 minutes

# Now that G-Cloud 12 has expired, we cannot procure G-Cloud 12 services
#
# @skip-production
# @smoke-tests
# @direct-award-passive
# Feature: Direct Award passive assurance

# Scenario: User is required to login to save a search
#   Given I visit the /g-cloud/search page
#   Then I see the 'Save your search' button
#   And I click 'Save your search'
#   Then I am on the 'Log in to the Digital Marketplace' page

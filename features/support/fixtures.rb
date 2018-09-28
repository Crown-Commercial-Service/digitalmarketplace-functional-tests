module Fixtures

  def self.digital_specialists_service
    {
      # `nil` values should be updated within the step when this fixture is used
      id: nil,
      supplierId: nil,
      frameworkSlug: nil,
      lot: 'digital-specialists',
      developerLocations: %w[London Scotland],
      developerPriceMax: "200",
      developerPriceMin: "100",
      bespokeSystemInformation: true,
      dataProtocols: true,
      helpGovernmentImproveServices: true,
      openStandardsPrinciples: true
    }
  end

  def self.digital_outcomes_service
    {
      # `nil` values should be updated within the step when this fixture is used
      id: nil,
      supplierId: nil,
      frameworkSlug: nil,
      lot: 'digital-outcomes',
      bespokeSystemInformation: true,
      dataProtocols: true,
      deliveryTypes: [
        "Agile coaching"
      ],
      helpGovernmentImproveServices: true,
      locations: %w[London Scotland],
      openStandardsPrinciples: true,
    }
  end

  def self.user_research_participants_service
    {
      # `nil` values should be updated within the step when this fixture is used
      id: nil,
      supplierId: nil,
      frameworkSlug: nil,
      lot: 'user-research-participants',
      anonymousRecruitment: true,
      locations: %w[London Scotland],
      manageIncentives: true,
      recruitFromList: true,
      recruitMethods: [
        "Entirely offline"
      ]
    }
  end

  def self.user_research_studios_service
    {
      # `nil` values should be updated within the step when this fixture is used
      frameworkSlug: nil,
      id: nil,
      labAccessibility: "Access is via steps and no hearing loops are present",
      labAddressBuilding: "The Great Briefs by Whitechapel, Marketplace Street",
      labAddressPostcode: "GDS20 5DM",
      labAddressTown: "GDSbury",
      labBabyChanging: false,
      labCarPark: "Local public parking provided",
      labDesktopStreaming: "Yes \u2013 for an additional cost",
      labDeviceStreaming: "Yes \u2013 for an additional cost",
      labEyeTracking: "Yes \u2013 for an additional cost",
      labHosting: "Yes \u2013 included as standard",
      labPriceMin: "949",
      labPublicTransport: "Regular bus services provided to local populations such as Gloucester and Cheltenham in addition to train stations",
      labSize: "25",
      labStreaming: "Yes \u2013 for an additional cost",
      labTechAssistance: "Yes \u2013 for an additional cost",
      labTimeMin: "8 hours",
      labToilets: true,
      labViewingArea: "No",
      labWaitingArea: "Yes \u2013 included as standard",
      labWiFi: true,
      lot: 'user-research-studios',
      serviceName: "GDSvieux Innovation Lab",
      supplierId: nil
    }
  end

  def self.digital_specialists_brief
    {
      # `nil` values should be updated within the step when this fixture is used
      frameworkSlug: nil,
      userId: nil,
      lot: 'digital-specialists',
      culturalFitCriteria: [
        "Just a great guy gal",
        "blah blah"
      ],
      culturalWeighting: 5,
      essentialRequirements: [
        "Boil kettle",
        "Taste tea",
        "Wash mug",
        "Dry mug"
      ],
      existingTeam: "Lots of us",
      location: "London",
      niceToHaveRequirements: [
        "Talk snobbishly about water quality",
        "Sip quietly",
        "Provide biscuits"
      ],
      numberOfSuppliers: 3,
      organisation: "NAO",
      priceWeighting: 20,
      requirementsLength: "2 weeks",
      specialistRole: "developer",
      specialistWork: "Drink tea",
      startDate: "2016-12-31",
      summary: "Drink lots of tea. Brew kettle.",
      technicalWeighting: 75,
      title: "Tea drinker",
      workingArrangements: "Hard work",
      workplaceAddress: "London",
      questionAndAnswerSessionDetails: "Here be Q&A details"
    }
  end

  def self.digital_outcomes_brief
    {
      # `nil` values should be updated within the step when this fixture is used
      frameworkSlug: nil,
      userId: nil,
      lot: "digital-outcomes",
      backgroundInformation: "Some background information.",
      budgetRange: "The range of the budget",
      culturalFitCriteria: [
        "Must be up in work at the crack of dawn every day.",
        "Must love a good game of hide and seek."
      ],
      culturalWeighting: 5,
      endUsers: "Tout le monde",
      essentialRequirements: [
        "Understand the rules.",
        "Hide dead good.",
      ],
      existingTeam: "Lots of us",
      location: "London",
      niceToHaveRequirements: [
        "Be invisible.",
        "Be able to count to 100 really really quickly.",
        "Have a nice smile"
      ],
      numberOfSuppliers: 3,
      organisation: "The Big Hide And Seek Company",
      outcome: "A thingy to do a thingy",
      phase: "beta",
      priceCriteria: "Fixed price",
      priceWeighting: 20,
      startDate: "2017-09-28",
      successCriteria: [
        "The thingy works"
      ],
      summary: "A team of exceptional hide and seek players.",
      technicalWeighting: 75,
      title: "Hide and seek ninjas",
      workingArrangements: "You work.",
      workplaceAddress: "Wherever we send you",
      questionAndAnswerSessionDetails: "Here be Q&A details"
    }
  end

  def self.user_research_participants_brief
    {
      # `nil` values should be updated within the step when this fixture is used
      frameworkSlug: nil,
      userId: nil,
      lot: "user-research-participants",
      culturalWeighting: 20,
      essentialRequirements: [
        "The horses must have four hooves",
        "The horses must have lovely coats",
        "The horses must be many hands tall"
      ],
      location: "London",
      niceToHaveRequirements: [
        "Liking sugar lumps",
        "Being good at jumping over fences",
        "Saying \"Neigh\""
      ],
      numberOfSuppliers: 3,
      organisation: "The Horse Force",
      participantSpecification: "Loads of horses",
      participantsPerRound: "At least 100",
      priceWeighting: 20,
      researchAddress: "64 Horse Road, Horseville.",
      researchDates: "January to April",
      researchFrequency: "At least 60 Hz",
      researchRounds: "Seven",
      successCriteria: [
        "One criterion",
        "Another criterion"
      ],
      summary: "Horses are really good.",
      technicalWeighting: 60,
      title: "I need horses.",
      questionAndAnswerSessionDetails: "Here be Q&A details"
    }
  end

  def self.digital_specialists_brief_response
    {
      # `nil` values should be updated within the step when this fixture is used
      frameworkSlug: nil,
      userId: nil,
      briefId: nil,
      supplierId: nil,
      availability: "27/12/17",
      dayRate: "200",
      essentialRequirements: [
        { "evidence": "first evidence" },
        { "evidence": "second evidence" },
        { "evidence": "third evidence" },
        { "evidence": "fourth evidence" },
      ],
      essentialRequirementsMet: true,
      niceToHaveRequirements: [
        { "yesNo": true, "evidence": "First nice to have evidence" },
        { "yesNo": true, "evidence": "Second nice to have evidence" },
        { "yesNo": false },
      ],
      respondToEmailAddress: "some-user@example.com",
    }
  end

  def self.cloud_support_service
    {
      # `nil` values should be updated within the step when this fixture is used
      id: nil,
      supplierId: nil,
      frameworkSlug: nil,
      lot: 'cloud-support',
      educationPricing: true,
      emailOrTicketingSupport: "no",
      governmentSecurityClearances: "dv",
      ongoingSupport: false,
      phoneSupport: false,
      planningService: true,
      planningServiceCompatibility: false,
      planningServiceDescription: "Value-for-money Digital Strategy for all!",
      priceInterval: "Day",
      priceMax: "700",
      priceMin: "200",
      priceUnit: "Person",
      pricingDocumentURL: "https://assets.digitalmarketplace.service.gov.uk/g-cloud-9/documents/test.pdf",
      QAAndTesting: false,
      resellingType: "not_reseller",
      securityTesting: false,
      serviceBenefits: [
          "Benefit 1",
          "Benefit 2"
      ],
      serviceConstraints: "None",
      serviceDefinitionDocumentURL: "https://assets.digitalmarketplace.service.gov.uk/g-cloud-9/documents/test.pdf",
      serviceDescription: "Deliver digital transformation by the bucketload!",
      serviceFeatures: [
          "Feature 1"
      ],
      serviceName: "Test cloud support service",
      setupAndMigrationService: false,
      sfiaRateDocumentURL: "https://assets.digitalmarketplace.service.gov.uk/g-cloud-9/documents/test.pdf",
      staffSecurityClearanceChecks: "staff_screening_not_bs7858_2012",
      supportLevels: "None",
      termsAndConditionsDocumentURL: "https://assets.digitalmarketplace.service.gov.uk/g-cloud-9/documents/test.pdf",
      training: false,
      webChatSupport: "no",
    }
  end

  def self.eicar_test_signature
    # the eicar test signature should never be stored in plaintext in a repository as its presence will likely trigger
    # all sorts of warnings from automatic scanners. instead it is stored as two parts that must be xor'ed together
    # to produce the final string.
    part_a = File.open(File.join(Dir.pwd, 'fixtures/eicar.part-a'), "rb") { |file| file.gets(nil).unpack("C*") }
    part_b = File.open(File.join(Dir.pwd, 'fixtures/eicar.part-b'), "rb") { |file| file.gets(nil).unpack("C*") }
    part_a.zip(part_b).map { |a, b| a ^ b }.pack("C*")
  end
end

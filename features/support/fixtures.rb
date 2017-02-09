module Fixtures
  DIGITAL_SPECIALISTS_SERVICE = {
    # ID's should be updated within the step this fixture is used in.
    id: nil,
    supplierId: nil,
    frameworkSlug: 'digital-outcomes-and-specialists',
    lot: 'digital-specialists',
    developerLocations: [
        "London",
        "Scotland"
      ],
    developerPriceMax: "200",
    developerPriceMin: "100",
    bespokeSystemInformation: true,
    dataProtocols: true,
    helpGovernmentImproveServices: true,
    openStandardsPrinciples: true
  }

  DIGITAL_OUTCOMES_SERVICE = {
    # ID's should be updated within the step this fixture is used in.
    id: nil,
    supplierId: nil,
    frameworkSlug: 'digital-outcomes-and-specialists',
    lot: 'digital-outcomes',
    bespokeSystemInformation: true,
    dataProtocols: true,
    deliveryTypes: [
      "Agile coaching"
    ],
    helpGovernmentImproveServices: true,
    locations: [
      "London",
      "Scotland"
    ],
    openStandardsPrinciples: true,
  }

  USER_RESEARCH_PARTICIPANTS_SERVICE = {
    # ID's should be updated within the step this fixture is used in.
    id: nil,
    supplierId: nil,
    frameworkSlug: 'digital-outcomes-and-specialists',
    lot: 'user-research-participants',
    anonymousRecruitment: true,
    locations: [
      "London",
      "Scotland"
    ],
    manageIncentives: true,
    recruitFromList: true,
    recruitMethods: [
      "Entirely offline"
    ]
  }

  DIGITAL_SPECIALISTS_BRIEF = {
    frameworkSlug: 'digital-outcomes-and-specialists',
    lot: 'digital-specialists',
    # ID's should be updated within the step this fixture is used in.
    userId: nil,
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
    startDate: "31\/12\/2016",
    summary: "Drink lots of tea. Brew kettle.",
    technicalWeighting: 75,
    title: "Tea drinker",
    workingArrangements: "Hard work",
    workplaceAddress: "London",
  }

  DIGITAL_OUTCOMES_BRIEF = {
    frameworkSlug: "digital-outcomes-and-specialists",
    lot: "digital-outcomes",
    # ID's should be updated within the step this fixture is used in.
    userId: nil,
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
    startDate: "28\/09\/2017",
    successCriteria: [
      "The thingy works"
    ],
    summary: "A team of exceptional hide and seek players.",
    technicalWeighting: 75,
    title: "Hide and seek ninjas",
    workingArrangements: "You work.",
    workplaceAddress: "Wherever we send you",
  }

  USER_RESEARCH_PARTICIPANTS_BRIEF = {
    frameworkSlug: "digital-outcomes-and-specialists",
    lot: "user-research-participants",
    # ID's should be updated within the step this fixture is used in.
    userId: nil,
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
    title: "I need horses."
  }

  DIGITAL_SPECIALISTS_BRIEF_RESPONSE = {
    # ID's should be updated within the step this fixture is used in.
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
    respondToEmailAddress: "example-email@gov.uk",
  }
end

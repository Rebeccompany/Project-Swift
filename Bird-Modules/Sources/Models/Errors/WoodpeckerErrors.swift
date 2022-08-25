//
//  WoodpeckerErrors.swift
//  
//
//  Created by Marcos Chevis on 18/08/22.
//

import Foundation

/// Woodpecker stepper Errors
public enum WoodpeckerStepperErrors: Error {
    case negativeStep, notEnoughSteps
}

/// Woodpecker sm2 Errors
public enum WoodpeckerSm2Errors: Error {
    case isNotGraduated, stepNot0
}

/// Woodpecker scheduler Errors
public enum WoodpeckerSchedulerErrors: Error {
    case maxLearningNotGreaterThan0, maxReviewingNotGreaterThan0, timezoneError
}

/// Woodpecker organizer Errors
public enum WoodpeckerOrganizerErrors: Error {
    case numberOfLearningAndReviewingCardsEqualTo0, numberOfReviewingCardsLessThan0, numberOfLearningCardsLessThan0
}

public enum WoodpeckerSortErrors: Error {
    case lastUserGradeIsNil
}

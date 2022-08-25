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

public enum WoodpeckerSchedulerErrors: Error {
    case maxLearningNotGreaterThan0, maxReviewingNotGreaterThan0, timezoneError
}

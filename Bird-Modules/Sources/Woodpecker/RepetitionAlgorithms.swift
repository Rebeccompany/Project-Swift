//
//  File.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import Foundation

///Woodpecker contains the algorithms used for Spaced Repetition
public struct Woodpecker {
    
    /**
     The stepper static method is the algorithm based on the Leitner system used for the learning phase
      - Parameters:
          - step: The step where the card currently is. From 0 to maximumStep.
          - userGrade: The grade user gives to the difficulty of the card.
          - numberOfSteps: The total number of steps. Must be greater than 1.
      - Throws: 'WoodpeckerStepperErrors.negativeStep' if step is negative.
     'WoodpeckerStepperErrors.notEnoughSteps' if maximumStep is lower than 1.
      - Returns: The case that determines the cards destiny.
     */
    public static func stepper(step: Int, userGrade: UserGrade, numberOfSteps: Int) throws -> CardDestiny {
        
        let maximumStep = numberOfSteps - 1
        
        if step < 0 {
            throw WoodpeckerStepperErrors.negativeStep
        } else if maximumStep < 1 {
            throw WoodpeckerStepperErrors.notEnoughSteps
        }
        
        if step == 0 {
            return getCardDestinyForFirstStep(userGrade)
        } else if step >= 1 && step < maximumStep {
            return getCardDestinyForMiddleSteps(userGrade)
        } else {
            return getCardDestinyForLastStep(userGrade)
        }
    }
    
    static func wpSm2(_ card: WoodpeckerCardInfo, userGrade: UserGrade) throws -> WoodpeckerCardInfo {
        let streak: Int = card.streak
        let easeFactor: Float = card.easeFactor
        let interval: Int = card.interval
        let userGradeValue: Float = Float(userGrade.rawValue)
        
        var result = card
        
        if !card.isGraduated {
            throw NSError()
        }
        
        if userGradeValue >= 2 {
            if streak == 0 {
                result.interval = 1
            } else if streak == 1 {
                result.interval = 6
            } else {
                result.interval = Int(round((Float(interval) * easeFactor)))
            }
            result.streak += 1
        } else if userGradeValue == 1 {
            result.streak = 0
            result.interval = 1
        } else {
            result.isGraduated = false
            result.interval = 1
            result.streak = 0
        }
        result.easeFactor = easeFactor + (0.36 * userGradeValue) - (0.02 * pow(userGradeValue, 2)) - 0.8
        return result
    }
}

extension Woodpecker {
    private static func getCardDestinyForFirstStep(_ userGrade: UserGrade) -> CardDestiny {
        switch userGrade {
        case .wrongHard:
            return .stay
        case .wrong:
            return .stay
        case .correct:
            return .foward
        case .correctEasy:
            return .graduate
        }
    }
    
    private static func getCardDestinyForMiddleSteps(_ userGrade: UserGrade) -> CardDestiny {
        switch userGrade {
        case .wrongHard:
            return .back
        case .wrong:
            return .stay
        case .correct:
            return .foward
        case .correctEasy:
            return .graduate
        }
    }
    
    private static func getCardDestinyForLastStep(_ userGrade: UserGrade) -> CardDestiny {
        switch userGrade {
        case .wrongHard:
            return .back
        case .wrong:
            return .stay
        case .correct:
            return .stay
        case .correctEasy:
            return .graduate
        }
    }
}

public struct WoodpeckerCardInfo {
    var step: Int
    var isGraduated: Bool
    var easeFactor: Float
    var streak: Int
    var interval: Int
}


public enum CardDestiny {
    case back, stay, foward, graduate
}

public enum UserGrade: Int {
    case wrongHard, wrong, correct, correctEasy
}

public enum WoodpeckerStepperErrors: Error {
    case negativeStep, notEnoughSteps
}

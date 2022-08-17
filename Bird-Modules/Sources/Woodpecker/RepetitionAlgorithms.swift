//
//  File.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import Foundation

///Woodpecker contains the algorithms used for Spaced Repetition
struct Woodpecker {
    
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
    static func stepper(step: Int, userGrade: UserGrade, numberOfSteps: Int) throws -> CardDestiny {
        
        let maximumStep = numberOfSteps - 1
        
        if step < 0 {
            throw WoodpeckerStepperErrors.negativeStep
        } else if maximumStep < 1 {
            throw WoodpeckerStepperErrors.notEnoughSteps
        }
        
        if step == 0 {
            
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
            
        } else if step >= 1 && step < maximumStep {
            
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
            
        } else {
            
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
    
    static func newSM2(_ card: WoodpeckerCardInfo, userGrade: UserGrade) throws -> WoodpeckerCardInfo {
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

struct WoodpeckerCardInfo {
    var step: Int
    var isGraduated: Bool
    var easeFactor: Float
    var streak: Int
    var interval: Int
}


enum CardDestiny {
    case back, stay, foward, graduate
}

enum UserGrade: Int {
    case wrongHard, wrong, correct, correctEasy
}

enum WoodpeckerStepperErrors: Error {
    case negativeStep, notEnoughSteps
}


var maximumStep: Int = 2


struct SM2CardInfo {
    var userGrade: Int
    var streak: Int
    var easeFactor: Float
    var interval: Int
    
    static func SM2(_ cardInfo: SM2CardInfo) -> SM2CardInfo {
        
        let userGrade: Int = cardInfo.userGrade
        var streak: Int = cardInfo.streak
        var easeFactor: Float = cardInfo.easeFactor
        var interval: Int = cardInfo.interval
        
        if userGrade >= 3 {
            if streak == 0 {
                interval = 1
            } else if streak == 1 {
                interval = 6
            } else {
                interval = Int(round((Float(interval) * easeFactor)))
            }
            streak += 1
        } else {
            streak = 0
            interval = 1
        }
        
        easeFactor += (0.1 - (5 - Float(userGrade)) * (0.08 + (5 - Float(userGrade)) * 0.02))
        
        if easeFactor < 1.3 {
            easeFactor = 1.3
        }
        
        return SM2CardInfo(userGrade: userGrade, streak: streak, easeFactor: easeFactor, interval: interval)
    }
}

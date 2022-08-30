//
//  RepetitionAlgorithms.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import Foundation
import Models


///Woodpecker contains the algorithms used for Spaced Repetition
public struct Woodpecker {
    
    /**
     The wpScheduler static method is responsible for getting the cards to be displayed today, and the cards that have to have their dueDates modified.
     - Parameters:
     - cardsInfo: The information needed from the cards.
     - config: Spaced repetition configuration.
     - currentDate: Defaults to today's date.
     - Throws: 'WoodpeckerStepperErrors.maxReviewingNotGreaterThan0' if the number of maxReviewingCards in config is not greater than 0.
     'WoodpeckerStepperErrors.maxLearningNotGreaterThan0' if the number of maxLearningCards in config is not greater than 0.
     'WoodpeckerSchedulerErrors.timezoneError' if a timezone error occurs.
     - Returns: A tuple containing an array of the UUIDs of the cards to be displayed today, and an array of the UUIDs of the cards to be modified.
     */
    public static func wpScheduler(cardsInfo: [SchedulerCardInfo], config: SpacedRepetitionConfig, currentDate: Date = Date()) throws -> (todayCards: [UUID], toModify: [UUID]) {
        
        if config.maxReviewingCards <= 0 {
            throw WoodpeckerSchedulerErrors.maxReviewingNotGreaterThan0
        } else if config.maxLearningCards <= 0 {
            throw WoodpeckerSchedulerErrors.maxLearningNotGreaterThan0
        }
        
        var learningCards: [SchedulerCardInfo] = cardsInfo
            .filter { !$0.woodpeckerCardInfo.isGraduated }
            .shuffled()
        
        let learningHasBeenPresented = learningCards
            .filter { $0.woodpeckerCardInfo.hasBeenPresented }
        
        let learningHasntBeenPresented = learningCards
            .filter { !$0.woodpeckerCardInfo.hasBeenPresented }
        
        learningCards = Array((learningHasBeenPresented + learningHasntBeenPresented)
            .prefix(config.maxLearningCards))
        
        var cal = Calendar(identifier: .gregorian)
        guard let timezone = TimeZone(identifier: "UTC") else {
            throw WoodpeckerSchedulerErrors.timezoneError
        }
        cal.timeZone = timezone
        
        let reviewingDueTodayCards: [SchedulerCardInfo] = cardsInfo
            .filter { card in
                guard let dueDate = card.dueDate else {
                    return false
                }
                let isDLessOrEqual = cal.dateComponents([.day], from: dueDate) == cal.dateComponents([.day], from: currentDate) || dueDate < currentDate
                let isMLessOrEqual = cal.dateComponents([.month], from: dueDate) == cal.dateComponents([.month], from: currentDate) || dueDate < currentDate
                let isYLessOrEqual = cal.dateComponents([.year], from: dueDate) == cal.dateComponents([.year], from: currentDate) || dueDate < currentDate
                return card.woodpeckerCardInfo.isGraduated && isDLessOrEqual && isMLessOrEqual && isYLessOrEqual
            }
        
        let todayReviewingCards = Array(reviewingDueTodayCards
            .prefix(config.maxReviewingCards))
        
        let toModify: [SchedulerCardInfo]
        if reviewingDueTodayCards.count > config.maxReviewingCards {
            toModify = Array(reviewingDueTodayCards[config.maxReviewingCards...reviewingDueTodayCards.count - 1])
        } else {
            toModify = []
        }
        
        let todayCards = (todayReviewingCards + learningCards)
            .shuffled()
        
        return (todayCards.map { $0.cardId }, toModify.map { $0.cardId })
        
    }
    
    
    /**
     The stepper static method is the algorithm based on the Leitner system used for the learning stage
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
    
    /**
     The wpSm2 static method contains the algorithm based on Super Memo 2 algorithm used for scheduling cards in the reviewing stage.
     - Parameters:
     - card: The card that is going to be scheduled.
     - userGrade: The grade user gives to the difficulty of the card.
     - Throws: 'WoodpeckerSm2Errors.isNotGraduated' if the card is not graduated.
     'WoodpeckerSm2Errors.stepNot0' if the card has a step different from 0.
     - Returns: The modified card. It might modify its Interval, isGraduated, streak, and easeFactor.
     */
    static func wpSm2(_ card: WoodpeckerCardInfo, userGrade: UserGrade) throws -> WoodpeckerCardInfo {
        let streak: Int = card.streak
        let easeFactor: Double = card.easeFactor
        let interval: Int = card.interval
        let userGradeValue = Double(userGrade.rawValue)
        
        var result = card
        
        if !card.isGraduated {
            throw WoodpeckerSm2Errors.isNotGraduated
        } else if card.step != 0 {
            throw WoodpeckerSm2Errors.stepNot0
        }
        
        if userGradeValue >= 2 {
            if streak == 0 {
                result.interval = 1
            } else if streak == 1 {
                result.interval = 6
            } else {
                result.interval = Int(round((Double(interval) * easeFactor)))
            }
            result.streak += 1
        } else if userGradeValue == 1 {
            result.streak = 0
            result.interval = 1
        } else {
            result.isGraduated = false
            result.interval = 0
            result.streak = 0
        }
        result.easeFactor = easeFactor + calculateEaseFactor(userGrade)
        
        if result.easeFactor < 1.3 {
            result.easeFactor = 1.3
        }
        
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
    
    private static func calculateEaseFactor(_ userGrade: UserGrade) -> Double {
        switch userGrade {
        case .wrongHard:
            return -0.8
        case .wrong:
            return -0.5
        case .correct:
            return 0
        case .correctEasy:
            return 0.1
        }
    }
}

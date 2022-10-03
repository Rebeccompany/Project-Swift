//
//  RepetitionAlgorithms.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import Foundation
import Models
import Utils


///Woodpecker contains the algorithms used for Spaced Repetition
public struct Woodpecker {

    /**
     The scheduler static method is responsible for getting the cards to be displayed today, and the cards that have to have their dueDates modified.
     - Parameters:
     - cardsInfo: The information needed from the cards.
     - config: Spaced repetition configuration.
     - currentDate: Defaults to today's date.
     - Throws: 'WoodpeckerStepperErrors.maxReviewingNotGreaterThan0' if the number of maxReviewingCards in config is not greater than 0.
     'WoodpeckerStepperErrors.maxLearningNotGreaterThan0' if the number of maxLearningCards in config is not greater than 0.
     'WoodpeckerSchedulerErrors.timezoneError' if a timezone error occurs.
     - Returns: A tuple containing an array of the UUIDs of the Reviewing cards to be displayed today, an array of the UUIDs of the Learning cards to be displayed today, and an array of the UUIDs of the cards to be modified.
     */
    public static func scheduler(cardsInfo: [OrganizerCardInfo], config: SpacedRepetitionConfig, currentDate: Date = Date()) throws -> (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) {

        
        if config.maxReviewingCards <= 0 {
            throw WoodpeckerSchedulerErrors.maxReviewingNotGreaterThan0
        } else if config.maxLearningCards <= 0 {
            throw WoodpeckerSchedulerErrors.maxLearningNotGreaterThan0
        }
        
        var todayLearningCards: [OrganizerCardInfo] = cardsInfo
            .filter { !$0.woodpeckerCardInfo.isGraduated }
            .shuffled()
        
        let learningHasBeenPresented = todayLearningCards
            .filter { $0.woodpeckerCardInfo.hasBeenPresented }
        
        let learningHasntBeenPresented = todayLearningCards
            .filter { !$0.woodpeckerCardInfo.hasBeenPresented }
        
        todayLearningCards = Array((learningHasBeenPresented + learningHasntBeenPresented)
            .prefix(config.maxLearningCards))
        
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.gmt
        
        let reviewingDueTodayCards: [OrganizerCardInfo] = cardsInfo
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
        
        let toModify: [OrganizerCardInfo]
        if reviewingDueTodayCards.count > config.maxReviewingCards {
            toModify = Array(reviewingDueTodayCards[config.maxReviewingCards...reviewingDueTodayCards.count - 1])
        } else {
            toModify = []
        }
        return (todayReviewingCards.map { $0.id }, todayLearningCards.map { $0.id }, toModify.map { $0.id })
    }
    
    /**
     The dealWithLearningCard is the function that calls the stepper and modifies de card depending of the cards destiny.
     - Parameters:
     - card: the card to be ran by the stepper and modified.
     - userGrade: The grade user gives to the difficulty of the card.
     - numberOfSteps: The total number of steps. Must be greater than 1.
     - timefromLastCard: The time that the last card was dismissed.
     - dateHandler: the DateHandler to get a date.
     - Returns: The modified card.
     */
    public static func dealWithLearningCard(card: Card, userGrade: UserGrade, numberOfSteps: Int, timefromLastCard: Date, dateHandler: DateHandlerProtocol) throws -> Card {
        let cardDestiny = try Self.stepper(cardInfo: card.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: numberOfSteps)
        
        var modifiedCard = card
        modifiedCard.woodpeckerCardInfo.hasBeenPresented = true
        
        switch cardDestiny {
        case .back:
            //update card and bumps to last position of the vector.
            modifiedCard.woodpeckerCardInfo.step -= 1
            modifiedCard.woodpeckerCardInfo.streak = 0
        case .stay:
            //update card and bumps to last position of the vector.
            modifiedCard.woodpeckerCardInfo.streak = 0
        case .foward:
            //update card and bumps to last position of the vector.
            modifiedCard.woodpeckerCardInfo.step += 1
            modifiedCard.woodpeckerCardInfo.streak += 1
        case .graduate:
            //update card. Save it to toEdit. Remove from cards.
            modifiedCard.history.append(CardSnapshot(
                                            woodpeckerCardInfo: modifiedCard.woodpeckerCardInfo,
                                            userGrade: userGrade,
                                            timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970,
                                            date: dateHandler.today)
                                        )
            modifiedCard.woodpeckerCardInfo.streak += 1
            modifiedCard.woodpeckerCardInfo.step = 0
            modifiedCard.woodpeckerCardInfo.isGraduated = true
            modifiedCard.woodpeckerCardInfo.interval = 1
        }
        
        return modifiedCard
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
    public static func stepper(cardInfo: WoodpeckerCardInfo, userGrade: UserGrade, numberOfSteps: Int) throws -> CardDestiny {
        
        let maximumStep = numberOfSteps - 1
        
        if cardInfo.step < 0 {
            throw WoodpeckerStepperErrors.negativeStep
        } else if maximumStep < 1 {
            throw WoodpeckerStepperErrors.notEnoughSteps
        } else if cardInfo.isGraduated {
            throw WoodpeckerStepperErrors.isGraduated
        }
        
        if cardInfo.step == 0 {
            return getCardDestinyForFirstStep(userGrade)
        } else if cardInfo.step >= 1 && cardInfo.step < maximumStep {
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
    public static func wpSm2(_ card: WoodpeckerCardInfo, userGrade: UserGrade) throws -> WoodpeckerCardInfo {
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
    
    public static func cardSorter(card0: Card, card1: Card) -> Bool {
        if card0.woodpeckerCardInfo.step == card1.woodpeckerCardInfo.step
            || card0.woodpeckerCardInfo.isGraduated
            || card1.woodpeckerCardInfo.isGraduated {
            return Int.random(in: 0...1) == 0
        } else {
            return card0.woodpeckerCardInfo.step < card1.woodpeckerCardInfo.step
        }
    }
}

// MARK: PrepareStudySession Helpers
extension Woodpecker {
    // Decides if the card that is displayed next is a Learning card or a Reviewing card.
    private static func shouldGetLearningCard(numberOfLearningCards: Int, numberOfReviewingCards: Int) throws -> Bool {
        if numberOfLearningCards == 0 && numberOfReviewingCards == 0 {
            throw WoodpeckerOrganizerErrors.numberOfLearningAndReviewingCardsEqualTo0
        } else if numberOfLearningCards < 0 {
            throw WoodpeckerOrganizerErrors.numberOfLearningCardsLessThan0
        } else if numberOfReviewingCards < 0 {
            throw WoodpeckerOrganizerErrors.numberOfReviewingCardsLessThan0
        }
        
        return Int.random(in: -numberOfLearningCards...numberOfReviewingCards - 1) < 0
    }
    
    // Organizes the Learning Cards of a session by step and userGrade.
    private static func organizeLearningSession(cards: [OrganizerCardInfo]) throws -> [UUID] {
        var cards = cards.sorted(by: sortCardByStep)
        var auxMatrix: [[OrganizerCardInfo]] = []
        var auxList: [OrganizerCardInfo] = []
        var lastStep: Int = 0
        
        for card in cards {
            if lastStep == card.woodpeckerCardInfo.step {
                auxList.append(card)
            } else {
                auxMatrix.append(auxList)
                auxList = [card]
                lastStep += 1
            }
        }
        
        cards = []
        for list in auxMatrix {
            cards += try list.sorted(by: sortCardByUserGrade)
        }
        
        return cards.map { $0.id }
    }
    
    // Sorts cards by step.
    private static func sortCardByStep(card0: OrganizerCardInfo, card1: OrganizerCardInfo) -> Bool {
        card0.woodpeckerCardInfo.step < card1.woodpeckerCardInfo.step
    }
    
    // Sorts cards by user grade.
    private static func sortCardByUserGrade(card0: OrganizerCardInfo, card1: OrganizerCardInfo) throws -> Bool {
        guard let lastUserGrade0 = card0.lastUserGrade?.rawValue, let lastUserGrade1 = card1.lastUserGrade?.rawValue else {
            throw WoodpeckerSortErrors.lastUserGradeIsNil
        }
        return lastUserGrade0 < lastUserGrade1
    }
    
    // Organizes the Reviewing Cards of a session by shuffling.
    private static func organizeReviewingSession(reviewingCards: [UUID]) -> [UUID] {
        reviewingCards.shuffled()
    }

}

// MARK: Stepper Helpers
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

// MARK: NewSM Helpers
extension Woodpecker {
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

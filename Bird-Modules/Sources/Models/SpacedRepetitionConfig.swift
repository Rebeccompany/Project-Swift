//
//  SpacedRepetitionConfig.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// Configuration of Spaced Repetition.
public struct SpacedRepetitionConfig: Equatable, Hashable {
    
    /// The maximum number of cards for the learning stage.
    public var maxLearningCards: Int
    /// The maximum number of cards for the reviewing stage.
    public var maxReviewingCards: Int
    /// The number os steps
    public var numberOfSteps: Int
    
    public init(maxLearningCards: Int = 20, maxReviewingCards: Int = 200, numberOfSteps: Int = 4) {
        self.maxLearningCards = maxLearningCards
        self.maxReviewingCards = maxReviewingCards
        self.numberOfSteps = numberOfSteps
    }
}

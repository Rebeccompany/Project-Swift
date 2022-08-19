//
//  File.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// Configuration of Spaced Repetition.
public struct SpacedRepetitionConfig {
    
    /// The maximum number of cards for the learning stage.
    public var maxLearningCards: Int
    /// The maximum number of cards for the reviewing stage.
    public var maxReviewingCards: Int
    
    public init(maxLearningCards: Int, maxReviewingCards: Int) {
        self.maxLearningCards = maxLearningCards
        self.maxReviewingCards = maxReviewingCards
    }
}

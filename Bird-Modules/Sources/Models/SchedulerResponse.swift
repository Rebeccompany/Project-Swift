//
//  SchedulerResponse.swift
//  
//
//  Created by Caroline Taus on 31/10/22.
//

import Foundation

public struct SchedulerResponse {
    public var todayReviewingCards: [UUID]
    public var todayLearningCards: [UUID]
    public var toModify: [UUID]
    
    public init(todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) {
        self.todayReviewingCards = todayReviewingCards
        self.todayLearningCards = todayLearningCards
        self.toModify = toModify
    }
}

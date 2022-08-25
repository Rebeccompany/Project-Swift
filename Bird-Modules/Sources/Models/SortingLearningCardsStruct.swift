//
//  SortingLearningCardsStruct.swift
//  
//
//  Created by Caroline Taus on 25/08/22.
//

import Foundation


public struct SortingLearningCardsStruct {
    public let id: UUID
    public let lastUserGrade: UserGrade
    public let step: Int
    
    public init(id: UUID, lastUserGrade: UserGrade, step: Int) {
        self.id = id
        self.lastUserGrade = lastUserGrade
        self.step = step
    }
}

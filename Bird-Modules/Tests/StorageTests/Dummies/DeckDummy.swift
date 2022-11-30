//
//  DeckDummy.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Models

enum DeckDummy {
    static var dummy: Deck {
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        
        return Deck(id: UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!,
                    name: "Progamação Swift",
                    icon: "chevron.down",
                    color: .red,
                    datesLogs: dateLog,
                    collectionId: nil,
                    cardsIds: [],
                    spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                  maxReviewingCards: 200),
                                                  category: DeckCategory.arts,
                                                  storeId: nil, description: "", ownerId: nil)
    }
    
    static func newDummy(with id: UUID) -> Deck {
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        
        return Deck(id: id,
                    name: ["Programação Kotlin", "Programação JS", "Programação Go", "Programação Rust"].randomElement()!,
                    icon: "chevron.down",
                    color: .red,
                    datesLogs: dateLog,
                    collectionId: nil,
                    cardsIds: [],
                    spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                  maxReviewingCards: 200),
                                                  category: DeckCategory.arts,
                                                  storeId: nil, description: "", ownerId: nil)
    }
}

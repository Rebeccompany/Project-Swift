//
//  DeckCollectionDummy.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//
import Foundation
import Models

enum DeckCollectionDummy {
    static var dummy: DeckCollection {
        DeckCollection(id: UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!,
                       name: "Coding",
                       icon: .atom,
                       datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                           lastEdit: Date(timeIntervalSince1970: 0),
                                           createdAt: Date(timeIntervalSince1970: 0)),
                       decksIds: [])
    }
    
    static func newDummyDeck(with id: UUID = UUID()) -> DeckCollection {
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        
        return DeckCollection(id: id,
                              name: ["Programação Kotlin", "Programação JS", "Programação Go", "Programação Rust"].randomElement()!,
                              icon: .atom,
                              datesLogs: dateLog,
                              decksIds: [])
    }
    
}

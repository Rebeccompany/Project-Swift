//
//  DeckCollection.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A collection of decks of flashcards
public struct DeckCollection: Identifiable, Equatable {
    public let id: UUID
    /// The name of the collection.
    public var name: String
    /// The icon of the collection
    public var icon: IconNames
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// A list of the decks ids that belongs to the collection
    public var decksIds: [UUID]
    
    public init(id: UUID, name: String, icon: IconNames, datesLogs: DateLogs, decksIds: [UUID]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.datesLogs = datesLogs
        self.decksIds = decksIds
    }
}

//
//  DeckCollection.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A collection of decks of flashcards
public struct DeckCollection {
    public let id: UUID
    /// The name of the collection.
    public var name: String
    /// The url of the icon of the collection
    public var iconPath: URL
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// A list of the decks ids that belongs to the collection
    public var decksIds: [UUID]
    
    internal init(id: UUID, name: String, iconPath: URL, datesLogs: DateLogs, decksIds: [UUID]) {
        self.id = id
        self.name = name
        self.iconPath = iconPath
        self.datesLogs = datesLogs
        self.decksIds = decksIds
    }
}

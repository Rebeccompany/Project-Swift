//
//  Card.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A flashcard.
public struct Card {
    public let id: UUID
    /// Information displayed on the front of the card.
    public var front: AttributedString
    /// Information displayed on the back of the card.
    public var back: AttributedString
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// The id of the deck the card belongs to.
    public var deckID: UUID
    /// The woodpeckerCardInfo of the card.
    public var woodpeckerCardInfo: WoodpeckerCardInfo
    /// List of the CardSnapshots of the card.
    public var history: [CardSnapshot]
    
    public init(id: UUID, front: AttributedString, back: AttributedString, datesLogs: DateLogs, deckID: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, history: [CardSnapshot]) {
        self.id = id
        self.front = front
        self.back = back
        self.datesLogs = datesLogs
        self.deckID = deckID
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.history = history
    }
}

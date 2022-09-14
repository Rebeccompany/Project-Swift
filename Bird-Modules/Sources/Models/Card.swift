//
//  Card.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A flashcard.
public struct Card: Identifiable, Equatable, Hashable {
    public let id: UUID
    /// Information displayed on the front of the card.
    public var front: AttributedString
    /// Information displayed on the back of the card.
    public var back: AttributedString
    /// the color of the card
    public var color: CollectionColor
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// The id of the deck the card belongs to.
    public var deckID: UUID
    /// The due date for the card to appear to the user
    public var dueDate: Date? {
        guard let newestItem = history.max(by: { card0, card1 in
            card0.date > card1.date
        }) else { return nil }
        
        return newestItem.date.advanced(by: TimeInterval(86400 * woodpeckerCardInfo.interval))
    }
    /// The woodpeckerCardInfo of the card.
    public var woodpeckerCardInfo: WoodpeckerCardInfo
    /// List of the CardSnapshots of the card.
    public var history: [CardSnapshot]
    
    public init(id: UUID, front: AttributedString, back: AttributedString, color: CollectionColor, datesLogs: DateLogs, deckID: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, history: [CardSnapshot]) {
        self.id = id
        self.front = front
        self.back = back
        self.color = color
        self.datesLogs = datesLogs
        self.deckID = deckID
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.history = history
    }
}

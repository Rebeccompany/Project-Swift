//
//  CardSnapshot.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// Snapshot of a card's info for statistics.
public struct CardSnapshot: Equatable, Hashable, Codable {
    /// The woodpeckerCardInfo of the card.
    public let woodpeckerCardInfo: WoodpeckerCardInfo
    /// The userGrade the user has given the card.
    public let userGrade: UserGrade
    /// The time the user spent looking at the card.
    public let timeSpend: TimeInterval
    /// Card snapshot's date.
    public let date: Date
    
    public init(woodpeckerCardInfo: WoodpeckerCardInfo, userGrade: UserGrade, timeSpend: TimeInterval, date: Date) {
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.userGrade = userGrade
        self.timeSpend = timeSpend
        self.date = date
    }
}

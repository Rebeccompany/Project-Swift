//
//  OrganizerCardInfo.swift
//  
//
//  Created by Marcos Chevis on 22/08/22.
//

import Foundation

/// Card information used in woodpecker's scheduler
public struct OrganizerCardInfo {
    public let id: UUID
    /// The woodpeckerCardInfo of the card.
    public let woodpeckerCardInfo: WoodpeckerCardInfo
    /// The due date for the card to appear to the user
    public let dueDate: Date?
    /// The grade the user has given the card on the last time they studied it
    public let lastUserGrade: UserGrade?
    
    public init(id: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, dueDate: Date?, lastUserGrade: UserGrade?) {
        self.id = id
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.dueDate = dueDate
        self.lastUserGrade = lastUserGrade
    }
}

//
//  StudyWindowData.swift
//  
//
//  Created by Nathalia do Valle Papst on 08/11/22.
//

import Foundation

public struct StudyWindowData: Equatable, Hashable, Codable {
    public var deck: Deck
    public var mode: StudyMode
    
    public init(deck: Deck, mode: StudyMode) {
        self.deck = deck
        self.mode = mode
    }
}

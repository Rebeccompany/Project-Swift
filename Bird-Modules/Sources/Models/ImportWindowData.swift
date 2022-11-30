//
//  ImportWindowData.swift
//  
//
//  Created by Nathalia do Valle Papst on 21/11/22.
//

import Foundation
import SwiftUI

#if os(macOS)
public struct ImportWindowData: Equatable, Hashable, Codable {
    public var deck: Deck
    
    public init(deck: Deck) {
        self.deck = deck
    }
}
#endif

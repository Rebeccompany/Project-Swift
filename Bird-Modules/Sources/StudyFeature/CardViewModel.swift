//
//  File.swift
//  
//
//  Created by Marcos Chevis on 08/09/22.
//

import Foundation
import Models

struct CardViewModel: Equatable {
    var card: Card
    var isFlipped: Bool
    
    init(card: Card, isFlipped: Bool = false) {
        self.card = card
        self.isFlipped = isFlipped
    }
    
    init(card: Card) {
        self.card = card
        self.isFlipped = false
    }
    
    static func ==(lhs: CardViewModel, rhs: CardViewModel) -> Bool {
        return lhs.card == rhs.card
    }
}

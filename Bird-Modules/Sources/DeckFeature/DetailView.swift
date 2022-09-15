//
//  DetailView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models

public struct DetailView: View {
    var detailType: DetailDisplayType
    var decks: [Deck]
    
    public init(detailType: DetailDisplayType, decks: [Deck]) {
        self.detailType = detailType
        self.decks = decks
    }
    
    public var body: some View {
        if detailType == .grid {
            Text("oi")
        }
        
        Text("tchau")
    }
}

public enum DetailDisplayType {
    case grid
    case table
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailType: .grid, decks: [])
    }
}

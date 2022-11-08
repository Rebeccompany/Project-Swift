//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation

public final class ShopStore: ObservableObject {
    @Published public var feedState: FeedState
    @Published public var deckState: PublicDeckState
    
    public init(feedState: FeedState = .init(), deckState: PublicDeckState = .init()) {
        self.feedState = feedState
        self.deckState = deckState
    }
}

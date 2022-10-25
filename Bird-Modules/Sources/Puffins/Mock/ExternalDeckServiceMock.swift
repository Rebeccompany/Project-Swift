//
//  ExternalDeckServiceMock.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Models
import Combine

public final class ExternalDeckServiceMock: ExternalDeckServiceProtocol {
    
    public var feed: [ExternalSection] = [
        ExternalSection(title: "Stem", decks: [ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem), ExternalDeck(id: "2", name: "Stem 2", description: "Stem Desc 2", icon: .abc, color: .darkBlue, category: .stem), ExternalDeck(id: "3", name: "Stem 3", description: "Stem Desc 3", icon: .atom, color: .gray, category: .stem)]),
        
        ExternalSection(title: "Humanities", decks:  [ExternalDeck(id: "4", name: "Humanities 1", description: "Humanities Desc", icon: .gamecontroller, color: .green, category: .humanities)]),
        
        ExternalSection(title: "Languages", decks:  [ExternalDeck(id: "5", name: "Languages 1", description: "Languages Desc", icon: .books, color: .lightBlue, category: .languages), ExternalDeck(id: "6", name: "Languages 2", description: "Languages Desc 2", icon: .cloudSun, color: .darkPurple, category: .languages), ExternalDeck(id: "7", name: "Languages 3", description: "Languages Desc 3", icon: .books, color: .pink, category: .languages), ExternalDeck(id: "8", name: "Languages 4", description: "Languages Desc 4", icon: .books, color: .beigeBrown, category: .languages),]),
                        
        ExternalSection(title: "Arts", decks:  [ExternalDeck(id: "9", name: "Arts 3", description: "Arts Desc 3", icon: .books, color: .orange, category: .arts), ExternalDeck(id: "10", name: "Arts 3", description: "Arts Desc 3", icon: .cpu, color: .lightBlue, category: .arts),]),
                        
        ExternalSection(title: "Others", decks:  [ExternalDeck(id: "11", name: "Others", description: "Others Desc", icon: .books, color: .darkPurple, category: .others),])
    ]
    
    public init() {
        
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        Just(feed).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
}

/**
 
 [ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem), ExternalDeck(id: "2", name: "Stem 2", description: "Stem Desc 2", icon: .abc, color: .darkBlue, category: .stem), ExternalDeck(id: "3", name: "Stem 3", description: "Stem Desc 3", icon: .atom, color: .gray, category: .stem)]
 
 [ExternalDeck(id: "4", name: "Humanities 1", description: "Humanities Desc", icon: .gamecontroller, color: .green, category: .humanities)]
 
 [ExternalDeck(id: "5", name: "Languages 1", description: "Languages Desc", icon: .books, color: .lightBlue, category: .languages), ExternalDeck(id: "6", name: "Languages 2", description: "Languages Desc 2", icon: .cloudSun, color: .darkPurple, category: .languages), ExternalDeck(id: "7", name: "Languages 3", description: "Languages Desc 3", icon: .books, color: .pink, category: .languages), ExternalDeck(id: "8", name: "Languages 4", description: "Languages Desc 4", icon: .books, color: .beigeBrown, category: .languages),]
 
 [ExternalDeck(id: "9", name: "Arts 3", description: "Arts Desc 3", icon: .books, color: .orange, category: .arts), ExternalDeck(id: "10", name: "Arts 3", description: "Arts Desc 3", icon: .cpu, color: .lightBlue, category: .arts),]
 
 [ExternalDeck(id: "11", name: "Others", description: "Others Desc", icon: .books, color: .darkPurple, category: .others),]
 */

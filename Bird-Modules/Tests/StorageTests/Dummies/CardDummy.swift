//
//  CardDummy.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Models

enum CardDummy {
    static var dummy: Card {
        let id = UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!
        let deckId = UUID(uuidString: "25804f37-a401-4211-b8d1-ac2d3de53775")!
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData =  ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1,
                                    hasBeenPresented: true)
        
        return Card(id: id, front: AttributedString(frontNSAttributedString), back: AttributedString(backNSAttributedString), color: .red, datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
    }
    
    static func newDummyCard(_ id: UUID, into deck: Deck) -> Card {
        let id = id
        let deckId = deck.id
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData =  ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1,
                                    hasBeenPresented: true)
        
        return Card(id: id, front: AttributedString(frontNSAttributedString), back: AttributedString(backNSAttributedString), color: .red, datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
    }
}

//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import Foundation
import HummingBird
import SwiftUI
import Models
import Utils

enum ImportedCardInfoTransformer {
    
    static func transformToCard(
        _ importedInfo: ImportedCardInfo,
        deckID: UUID,
        cardColor: CollectionColor,
        dateHandler: DateHandlerProtocol = DateHandler(),
        uuidHandler: UUIDGeneratorProtocol = UUIDGenerator()
    ) -> Card? {
        
        guard
            let frontData = importedInfo.front.data(using: .utf8),
            let front = try? NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
            let backData = importedInfo.back.data(using: .utf8),
            let back = try? NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        else {
            return nil
        }
        
        let dateLog = DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today)
        
        return Card(
            id: uuidHandler.newId(),
            front: front,
            back: back,
            color: cardColor,
            datesLogs: dateLog,
            deckID: deckID,
            woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
            history: []
        )
    }
}

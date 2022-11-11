//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 10/11/22.
//

import SwiftUI

enum CardAdapter {
    static func adapt(_ card: Card) -> CardDTO? {
        guard let htmlFront = try? card.front.data(from: NSRange(location: 0, length: card.front.length), documentAttributes: [.documentType : NSAttributedString.DocumentType.rtf]),
              let htmlBack = try? card.back.data(from: NSRange(location: 0, length: card.back.length), documentAttributes: [.documentType : NSAttributedString.DocumentType.rtf]),
              let frontString = String(data: htmlFront, encoding: .utf8),
              let backString = String(data: htmlBack, encoding: .utf8)
        else { return nil }
        
        return CardDTO(front: frontString, back: backString, color: .red)
    }
}


//
//  DeckConverter.swift
//  
//
//  Created by Rebecca Mello on 18/08/22.
//

import Foundation
import Owl

final class DeckConverter {
    func convert(_ data: Data) throws -> [ImportedCardInfo] {
        let result: [ImportedCardInfo]
        let semiCollonDecoder = CSVDecoder(separator: .semicollon)
        let commaDecoder = CSVDecoder(separator: .comma)
        
        if let commaSeparatedCards = try? commaDecoder.decode([ImportedCardInfo].self, from: data) {
            result = commaSeparatedCards
        } else if let semiCollonSeparatedCards = try? semiCollonDecoder.decode([ImportedCardInfo].self, from: data) {
            result = semiCollonSeparatedCards
        } else {
            throw ImportingError.fileCouldNotBeConverted
        }
        
        return result
    }
}

public struct ImportedCardInfo: Decodable, Hashable {
    public var front: String
    public var back: String
    public var tags: String
    public var deck: String
    
    enum CodingKeys: String, CodingKey {
        case front = "Front"
        case back = "Back"
        case tags
        case deck
    }
}

public enum ImportingError: Error {
    case fileCouldNotBeConverted
}

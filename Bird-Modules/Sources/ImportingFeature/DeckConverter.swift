//
//  File.swift
//  
//
//  Created by Rebecca Mello on 18/08/22.
//

import Foundation
import Owl

public final class DeckConverter {
    public func convert(_ data: Data) throws -> [Card]{
        let decoder = CSVDecoder(separator: .semicollon)
        let result = try decoder.decode([Card].self, from: data)
        
        return result
    }
}

public struct Card: Decodable {
    public var front: String
    public var back: String
    public var tags: [String]
    public var deck: String
}

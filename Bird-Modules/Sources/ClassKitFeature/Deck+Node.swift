//
//  File.swift
//  
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit
import Models

extension Deck: Node {
    var parent: Node? {
        nil
    }
    
    var children: [Node] {
        []
    }
    
    var title: String {
        self.name
    }
    
    var identifier: String {
        self.storeId!
    }
    
    var contextType: CLSContextType {
        .exercise
    }
}

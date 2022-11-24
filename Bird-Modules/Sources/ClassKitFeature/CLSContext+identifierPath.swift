//
//  File.swift
//  
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit

// An extension to provide a complete identifier path for a given ClassKit context.
extension CLSContext {
    var identifierPath: [String] {
        var pathComponents: [String] = [identifier]
        
        if let parent = self.parent {
            pathComponents = parent.identifierPath + pathComponents
        }
        
        return pathComponents
    }
}

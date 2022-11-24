//
//  File.swift
//  
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit

protocol Node {
    var parent: Node? { get }
    var children: [Node] { get }
    var title: String { get }
    var identifier: String { get }
    var contextType: CLSContextType { get }
}

extension Node {
    var identifierPath: [String] {
        var pathComponents: [String] = [identifier]
        
        if let parent = self.parent {
            pathComponents = parent.identifierPath + pathComponents
        }
        
        return pathComponents
    }
    
    /// Finds a node in the play list hierarchy by its identifier path.
    func descendant(matching identifierPath: [String]) -> Node? {
        if let identifier = identifierPath.first {
            if let child = children.first(where: { $0.identifier == identifier }) {
                return child.descendant(matching: Array(identifierPath.suffix(identifierPath.count - 1)))
            } else {
                return nil
            }
        } else {
            return self
        }
    }
}

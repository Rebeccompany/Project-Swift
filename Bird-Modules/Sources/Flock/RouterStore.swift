//
//  RouterStore.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import Foundation

public final class RouterStore<Route>: ObservableObject where Route: Hashable {
    
    @Published public var path: [Route]
    
    public init() {
        self.path = []
    }
    
    public func push(route: Route) {
        path.append(route)
    }
    
    public func popLast() {
        guard !path.isEmpty else {
            return
        }
        
        path.removeLast()
    }
}

//
//  RouterStore.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//
import SwiftUI
import Foundation

public final class RouterStore<Route>: ObservableObject where Route: Hashable {
    
    @Published var path: NavigationPath
    
    public init() {
        self.path = NavigationPath()
    }
    
    public func push(route: Route) {
        path.append(route)
    }
    
    public func popLast(_ k: Int = 1) {
        guard !path.isEmpty, k <= path.count else {
            return
        }
        
        path.removeLast(k)
    }
}

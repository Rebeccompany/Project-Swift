//
//  Router.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import SwiftUI

public struct Router<Root, Destination, Route>: View where Root: View, Destination: View, Route: Hashable {
    private let root: () -> Root
    private let destination: (Route) -> Destination
    
    @StateObject private var store = RouterStore<Route>()
    public init(
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.root = root
        self.destination = destination
    }
    
    public var body: some View {
        NavigationStack(path: $store.path) {
            root()
                .navigationDestination(
                    for: Route.self,
                    destination: destination
                )
        }
        .environmentObject(store)
    }
}

//
//  IconColorGridView.swift
//  
//
//  Created by Rebecca Mello on 05/09/22.
//

import SwiftUI

public struct IconColorGridView<Content: View>: View {
    public var elements: () -> Content
    
    public init(elements: @escaping () -> Content) {
        self.elements = elements
    }
    
    let columns = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    public var body: some View {
        LazyVGrid(columns: columns) {
            elements()
        }
        .padding()
        .background(HBColor.secondaryBackground)
        .cornerRadius(16)
    }
}

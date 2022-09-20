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
        GridItem(.adaptive(minimum: 45), spacing: 24)
    ]
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            elements()
                .frame(width: 45, height: 45)
        }
        .padding()
        .background(HBColor.secondaryBackground)
        .cornerRadius(16)
    }
}

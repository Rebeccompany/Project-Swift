//
//  IconColorGridView.swift
//  
//
//  Created by Rebecca Mello on 05/09/22.
//

import SwiftUI

struct IconColorGridView<Content: View> : View {
    var elements: () -> Content
    let columns = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            elements()
        }
    }
}

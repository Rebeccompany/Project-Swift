//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 05/09/22.
//

import SwiftUI

public struct CollectionDeckTextFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(8)
            .background(HBColor.secondaryBackground)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(HBColor.secondaryBackground, lineWidth: 8)
            )
    }
}

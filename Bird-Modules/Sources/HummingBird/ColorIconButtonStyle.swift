//
//  ColorIconButtonStyle.swift
//  
//
//  Created by Caroline Taus on 05/09/22.
//

import SwiftUI

struct ColorIconButtonStyle: ButtonStyle {
    var isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .foregroundColor(HBColor.collectionTextColor)
            .font(.headline)
            .background(configuration.isPressed ? .red: .red)
            .clipShape(Circle())
            .padding(5)
            .overlay(
            Circle()
                .stroke(HBColor.actionColor, lineWidth: isSelected ? 4 : 0)
        )
    }
}

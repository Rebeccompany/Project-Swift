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
            .background(configuration.isPressed ? HBColor.selectIconGridColor.opacity(0.5) : HBColor.selectIconBackground)
            .clipShape(Circle())
            .padding(5)
            .overlay(
            Circle()
                .stroke(HBColor.actionColor, lineWidth: isSelected ? 3 : 0)
        )
    }
}

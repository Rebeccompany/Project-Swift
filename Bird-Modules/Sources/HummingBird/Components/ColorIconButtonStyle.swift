//
//  ColorIconButtonStyle.swift
//  
//
//  Created by Caroline Taus on 05/09/22.
//

import SwiftUI

public struct ColorIconButtonStyle: ButtonStyle {
    public var isSelected: Bool
    
    public init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(HBColor.collectionTextColor)
            .font(.headline)
            .background(configuration.isPressed ? HBColor.selectIconGridColor.opacity(0.5) : HBColor.selectIconBackground)
            .clipShape(Circle())
            .padding(5)
            .overlay(
            Circle()
                .stroke(isSelected ? HBColor.actionColor : .secondary, lineWidth: isSelected ? 3 : 1)
        )
    }
}

//
//  LargeButtonStyle.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/09/22.
//

import SwiftUI

public struct LargeButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.headline)
            Spacer()
        }
        .frame(minHeight: 48)
        .foregroundColor(HBColor.actionColor.opacity(configuration.isPressed ? 0.5 : 1))
        .background(HBColor.secondaryBackground.opacity(configuration.isPressed ? 0.5 : 1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(HBColor.actionColor.opacity(configuration.isPressed ? 0.5 : 1), lineWidth: 1.5)
        )
        .shadow(color: HBColor.actionColor.opacity(configuration.isPressed ? 0 : 0.2), radius: 6, x: 2, y: 2)
    }
}

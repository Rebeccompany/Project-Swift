//
//  LargeButtonStyle.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/09/22.
//

import SwiftUI

public struct LargeButtonStyle: ButtonStyle {
    var isDisabled: Bool
    var isFilled: Bool
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    
    public init(isDisabled: Bool, isFilled: Bool = false) {
        self.isDisabled = isDisabled
        self.isFilled = isFilled
        
        if isFilled {
            backgroundColor = HBColor.secondaryBackground
            foregroundColor = HBColor.actionColor
        } else {
            backgroundColor = HBColor.actionColor
            foregroundColor = HBColor.primaryBackground
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        if !isDisabled {
            HStack {
                Spacer()
                configuration.label
                    .font(.headline)
                Spacer()
            }
            .frame(minHeight: 48)
            .foregroundColor(backgroundColor.opacity(configuration.isPressed ? 0.5 : 1))
            .background(foregroundColor.opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(backgroundColor.opacity(configuration.isPressed ? 0.5 : 1), lineWidth: 1.5)
            )
            .shadow(color: foregroundColor.opacity(configuration.isPressed ? 0 : 0.2), radius: 6, x: 2, y: 2)
        } else {
            HStack {
                Spacer()
                configuration.label
                    .font(.headline)
                Spacer()
            }
            .frame(minHeight: 48)
            .foregroundColor(HBColor.collectionGray.opacity(configuration.isPressed ? 0.5 : 1))
            .background(foregroundColor.opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(HBColor.collectionGray.opacity(configuration.isPressed ? 0.5 : 1), lineWidth: 1.5)
            )
            .shadow(color: HBColor.collectionGray.opacity(configuration.isPressed ? 0 : 0.2), radius: 6, x: 2, y: 2)
        }
    }
}

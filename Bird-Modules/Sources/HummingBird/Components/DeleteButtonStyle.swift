//
//  DeleteButtonStyle.swift
//  
//
//  Created by Caroline Taus on 05/09/22.
//

import SwiftUI

public struct DeleteButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .foregroundColor(configuration.isPressed ? .red.opacity(0.5) : .red)
        .padding()
        .font(.headline)
        .background(configuration.isPressed ? HBColor.secondaryBackground.opacity(0.5) : HBColor.secondaryBackground)
        .cornerRadius(8)
    }
}

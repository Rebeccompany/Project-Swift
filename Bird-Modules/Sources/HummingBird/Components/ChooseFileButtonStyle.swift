//
//  ChooseFileButtonStyle.swift
//  
//
//  Created by Rebecca Mello on 05/09/22.
//

import SwiftUI

public struct ChooseFileButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .padding(.leading, 8)
            Spacer()
        }
        .padding(11)
        .font(.headline)
        .background(configuration.isPressed ? HBColor.secondaryBackground.opacity(0.5) : HBColor.secondaryBackground)
        .cornerRadius(8)
    }
}

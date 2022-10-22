//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 22/10/22.
//

import SwiftUI

public struct DownloadDeckButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .frame(maxWidth: 130, maxHeight: 50)
        .padding(5)
        .font(.headline)
        .background(HBColor.actionColor.opacity(0.15))
        .cornerRadius(8)
        .foregroundColor(HBColor.actionColor)
    }
}

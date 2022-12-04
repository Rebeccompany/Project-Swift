//
//  LoadingView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import SwiftUI
import HummingBird

struct LoadingView: View {
    @State private var isFlipped: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(HBColor.actionColor)
                    .brightness(0.1)
                SpixiiShapeFront()
                    .fill(HBColor.actionColor)
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .rotationEffect(
                isFlipped ? Angle(degrees: 0) : Angle(degrees: 360),
                anchor: .center)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).delay(0.5).repeatForever(autoreverses: true)) {
                    isFlipped.toggle()
                }
            }
            .onDisappear {
                isFlipped = false
            }
            Text("loading".localized(.module))
        }
    }
}

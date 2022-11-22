//
//  SwiftUIView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 07/11/22.
//

import SwiftUI
import HummingBird

struct LoadingFlashcard: View {
    @State private var startPoint = UnitPoint.topLeading
    @State private var endPoint = UnitPoint.bottomTrailing
    
    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [HBColor.actionColor.opacity(0.7), HBColor.actionColor.opacity(0.5)], startPoint: startPoint, endPoint: UnitPoint(x: 1, y: 1)))
            .cornerRadius(16)
            .task {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        startPoint = UnitPoint(x: 0.7, y: 0.7)
                    }
                }
            }
    }
}

struct LoadingFlashcardGrid: View {
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
            LoadingFlashcard()
                .frame(height: 240)
            LoadingFlashcard()
                .frame(height: 240)
            LoadingFlashcard()
                .frame(height: 240)
            LoadingFlashcard()
                .frame(height: 240)
        }
    }
}

struct LoadingFlashcard_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFlashcardGrid()
    }
}

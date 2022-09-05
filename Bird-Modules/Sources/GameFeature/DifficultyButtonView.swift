//
//  DifficultyButtonView.swift
//  
//
//  Created by Marcos Chevis on 30/08/22.
//

import Foundation
import SwiftUI
import HummingBird

struct DifficultyButtonView: View {
    @Binding var isDisabled: Bool
    private let content: DifficultyButtonContent
    private let step: DifficultyStep
    private let action: (DifficultyStep) -> Void
    
    init(step: DifficultyStep, isDisabled: Binding<Bool>, action: @escaping (DifficultyStep) -> Void) {
        self.step = step
        self.content = step.buttonContent
        self._isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button {
                if !isDisabled {
                    action(step)
                }
            } label: {
                Image(systemName: content.image)
                    .font(.title)
                    .foregroundColor(isDisabled ? .gray : content.color)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .background(
                        Capsule()
                            .fill(HBColor.secondaryBackground)
                            .shadow(color: isDisabled ? .gray : content.color, radius: 1, x: 0, y: 2)
                    )
            }
            .disabled(isDisabled)
            Text(content.label)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(isDisabled ? .gray : .primary)
                .padding(.top, 4)
        }
    }
}

private struct DifficultyButtonView_Preview: PreviewProvider {
    private static var content: DifficultyButtonContent {
        .init(image: "xmark", label: "Difícil", color: HBColor.hardColor)
    }
    
    static var previews: some View {
        
        HStack {
            ForEach(DifficultyStep.allCases) { step in
                Spacer()
                DifficultyButtonView(step: step, isDisabled: .constant(false)) {_ in }
                Spacer()
            }
        }
        .padding()
        .preferredColorScheme(.light)
        .background(HBColor.primaryBackground)
        .previewLayout(.sizeThatFits)
        
        HStack {
            ForEach(DifficultyStep.allCases) { step in
                Spacer()
                DifficultyButtonView(step: step, isDisabled: .constant(false)) {_ in }
                Spacer()
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .background(HBColor.primaryBackground)
        .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(step: .hard, isDisabled: .constant(false)) {_ in }
            .padding()
            .preferredColorScheme(.light)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(step: .veryHard, isDisabled: .constant(false)) {_ in }
            .padding()
            .preferredColorScheme(.dark)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(step: .veryHard, isDisabled: .constant(true)) {_ in }
            .padding()
            .preferredColorScheme(.light)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(step: .veryHard, isDisabled: .constant(true)) { _ in }
            .padding()
            .preferredColorScheme(.dark)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
    }
}

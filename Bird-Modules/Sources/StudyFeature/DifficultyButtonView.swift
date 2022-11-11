//
//  DifficultyButtonView.swift
//  
//
//  Created by Marcos Chevis on 30/08/22.
//

import Foundation
import SwiftUI
import HummingBird
import Models
import Utils

struct GrowingButton: ButtonStyle {
    var color: Color
    @Binding var disabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .symbolVariant(configuration.isPressed ? .fill : .none)
            .font(.system(size: configuration.isPressed ? 35 : 30))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .tint(configuration.isPressed ? color : HBColor.actionColor)
            .foregroundColor(buttonColor(isPressed: configuration.isPressed))
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 70, height: 70)
            .background(
                Capsule()
                    .fill(HBColor.secondaryBackground)
                    .shadow(color: buttonColor(isPressed: configuration.isPressed), radius: 1, x: 0, y: 2)
            )
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    withAnimation(.easeIn(duration: 0.01)) {
                        
                    }
                }
            }
    }
    
    private func buttonColor(isPressed: Bool) -> Color {
        guard !disabled else {
            return .gray
        }
        
        if isPressed {
            return color
        } else {
            return HBColor.actionColor
        }
    }
}

struct DifficultyButtonView: View {
    @Binding var isDisabled: Bool
    private var content: DifficultyButtonContent
    private let userGrade: UserGrade
    private let action: (UserGrade) -> Void
    @State var show: Bool = false
    @GestureState var press: Bool = false
    @Binding var isVOOn: Bool
    
    init(userGrade: UserGrade, isDisabled: Binding<Bool>, isVOOn: Binding<Bool>, action: @escaping (UserGrade) -> Void) {
        self.userGrade = userGrade
        self.content = DifficultyButtonContent.getbuttonContent(for: userGrade)
        self._isDisabled = isDisabled
        self.action = action
        self._isVOOn = isVOOn
    }
    
    func shortcutValue() -> KeyboardShortcut {
        switch userGrade {
        case .wrongHard:
            return .init("1")
        case .wrong:
            return .init("2")
        case .correct:
            return .init("3")
        case .correctEasy:
            return .init("4")
        }
    }
    
    var body: some View {
        VStack {
            Button {
                if !isDisabled {
                    action(userGrade)
                }
            } label: {
                Image(systemName: !isVOOn ? content.image : "circle")
            }
            .keyboardShortcut(shortcutValue())
            .disabled(isDisabled)
            .buttonStyle(GrowingButton(color: content.color, disabled: $isDisabled))
            Text(content.label)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(isDisabled ? .gray : .primary)
                .padding(.top, 4)
                .accessibilityHidden(true)
            
        }
        .accessibilityLabel(NSLocalizedString("clicar_em", bundle: .module, comment: "") + content.label.finilized)
    }
    
}

struct DifficultyButtonView_Preview: PreviewProvider {
    private static var content: DifficultyButtonContent {
        .init(image: "xmark", label: "Difícil", color: HBColor.hardColor)
    }
    
    static var previews: some View {
        
        HStack {
            ForEach(UserGrade.allCases) { step in
                Spacer()
                DifficultyButtonView(userGrade: step, isDisabled: .constant(false), isVOOn: .constant(false)) { _ in }
                Spacer()
            }
        }
        .preferredColorScheme(.light)
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        .background(HBColor.primaryBackground)
        .previewLayout(.sizeThatFits)
        
        HStack {
            ForEach(UserGrade.allCases) { step in
                Spacer()
                DifficultyButtonView(userGrade: step, isDisabled: .constant(false), isVOOn: .constant(false)) { _ in }
                Spacer()
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .background(HBColor.primaryBackground)
        .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(userGrade: .wrong, isDisabled: .constant(false), isVOOn: .constant(false)) { _ in }
            .padding()
            .preferredColorScheme(.light)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(userGrade: .wrongHard, isDisabled: .constant(false), isVOOn: .constant(false)) { _ in }
            .padding()
            .preferredColorScheme(.dark)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(userGrade: .wrongHard, isDisabled: .constant(true), isVOOn: .constant(false)) { _ in }
            .padding()
            .preferredColorScheme(.light)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        DifficultyButtonView(userGrade: .wrongHard, isDisabled: .constant(true), isVOOn: .constant(false)) { _ in }
            .padding()
            .preferredColorScheme(.dark)
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
    }
}

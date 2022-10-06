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

struct DifficultyButtonView: View {
    @Binding var isDisabled: Bool
    private var content: DifficultyButtonContent
    private let userGrade: UserGrade
    private let action: (UserGrade) -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var isVOOn: Bool

    init(userGrade: UserGrade, isDisabled: Binding<Bool>, isVOOn: Binding<Bool>, action: @escaping (UserGrade) -> Void) {
        self.userGrade = userGrade
        self.content = DifficultyButtonContent.getbuttonContent(for: userGrade)
        self._isDisabled = isDisabled
        self.action = action
        self._isVOOn = isVOOn
    }
    
    var body: some View {
        if horizontalSizeClass == .compact {
            compactView
        } else {
            regularView
        }
    }
    
    @ViewBuilder
    var compactView: some View {
        VStack {
            Button {
                if !isDisabled {
                    action(userGrade)
                }
            } label: {
                Image(systemName: !isVOOn ? content.image : "circle")
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
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(isDisabled ? .gray : .primary)
                .padding(.top, 4)
                .accessibilityHidden(true)
        }
        .accessibilityLabel(NSLocalizedString("clicar_em", bundle: .module, comment: "") + content.label.finilized)
    }
    
    @ViewBuilder
    var regularView: some View {
        VStack {
            
            Button {
                if !isDisabled {
                    action(userGrade)
                }
            } label: {
                Image(systemName: !isVOOn ? content.image : "circle")
                    .font(.system(size: 40))
                    .foregroundColor(isDisabled ? .gray : content.color)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .background(
                        Capsule()
                            .fill(HBColor.secondaryBackground)
                            .shadow(color: isDisabled ? .gray : content.color, radius: 1, x: 0, y: 3)
                    )
            }
            .disabled(isDisabled)
            
            Text(content.label)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(isDisabled ? .gray : .primary)
                .padding(.top, 4)
                .accessibilityHidden(true)
//                .padding()
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

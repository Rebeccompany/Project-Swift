//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 05/10/22.
//

import SwiftUI
import HummingBird
import Models

public struct FlashcardsOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    public init() {
        
    }
    public var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("1")
                        .font(.custom("SF Pro Text", size: 84, relativeTo: .largeTitle))
                        .fontWeight(.bold)
                        .foregroundColor(HBColor.actionColor)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("frente", bundle: .module, comment: ""))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.collectionTextColor)
                            .padding(.bottom, 2)
                        
                        Text(NSLocalizedString("instrucao_um", bundle: .module, comment: ""))
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(HBColor.collectionTextColor)
                    }
                }
                .padding(.bottom, 16)
                .padding(.trailing, 12)
                
                HStack {
                    Text("2")
                        .font(.custom("SF Pro Text", size: 84, relativeTo: .largeTitle))
                        .fontWeight(.bold)
                        .foregroundColor(HBColor.actionColor)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("verso", bundle: .module, comment: ""))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.collectionTextColor)
                            .padding(.bottom, 2)
                        
                        Text(NSLocalizedString("instrucao_dois", bundle: .module, comment: ""))
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(HBColor.collectionTextColor)
                    }
                }
                .padding(.trailing, 12)
            }
            .padding()
            .navigationTitle(NSLocalizedString("como_estudar", bundle: .module, comment: ""))
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text(NSLocalizedString("voltar", bundle: .module, comment: ""))
                        .foregroundColor(HBColor.actionColor)
                }
            }
            #if os(iOS)
            .toolbarBackground(.hidden, for: .navigationBar)
            #endif
            .viewBackgroundColor(HBColor.primaryBackground)
        }
        Spacer()
    }
}

struct FlashcardsOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardsOnboardingView()
    }
}

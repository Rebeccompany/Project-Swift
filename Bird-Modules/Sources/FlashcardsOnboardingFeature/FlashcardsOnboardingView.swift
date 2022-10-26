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
        NavigationView {
            HStack {
                VStack {
                    HStack {
                        Text("1")
                            .font(.custom("SF Pro Text", size: 84, relativeTo: .largeTitle))
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.actionColor)
                            .padding(.leading)
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("frente", bundle: .module, comment: ""))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                            Text(NSLocalizedString("instrucao_um", bundle: .module, comment: ""))
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                        }
                    }
                    HStack {
                        Text("2")
                            .font(.custom("SF Pro Text", size: 84, relativeTo: .largeTitle))
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.actionColor)
                            .padding(.leading)
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("verso", bundle: .module, comment: ""))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                            Text(NSLocalizedString("instrucao_dois", bundle: .module, comment: ""))
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("como_estudar", bundle: .module, comment: ""))
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text(NSLocalizedString("voltar", bundle: .module, comment: ""))
                        .foregroundColor(HBColor.actionColor)
                }
            }
        }
        Spacer()
    }
}

struct FlashcardsOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardsOnboardingView()
    }
}

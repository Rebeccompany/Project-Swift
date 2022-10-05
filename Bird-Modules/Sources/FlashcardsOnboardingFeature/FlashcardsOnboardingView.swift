//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 05/10/22.
//

import SwiftUI
import HummingBird

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
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.actionColor)
                            .padding(.leading)
                        VStack(alignment: .leading) {
                            Text("Frente")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                            Text("Ao iniciar o estudo, pense na resposta da pergunta do seu cartão e, em seguida, toque nele ou aperte barra de espaço para ver o verso")
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                        }
                    }
                    HStack {
                        Text("2")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.actionColor)
                            .padding(.leading)
                        VStack(alignment: .leading) {
                            Text("Verso")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                            Text("Ao ver a resposta, classifique o nível de dificuldade do cartão através dos botões, tocando neles ou apertando os números 1, 2, 3 e 4 no teclado, para avançar para os próximos cartões")
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(HBColor.collectionTextColor)
                                .padding(.all)
                        }
                    }
                    
                }
            }
            .navigationTitle("Como estudar")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Voltar")
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

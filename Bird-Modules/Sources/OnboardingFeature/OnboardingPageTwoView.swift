//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird

struct OnboardingPageTwoView: View {
    var body: some View {
        VStack {
            HBImages.BirdOneOnboarding
                .resizable()
                .frame(width: 200, height: 200)
            HStack {
                VStack(alignment: .leading) {
                    Text("Flashcards")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text("São feitos para testar a memória! Eles guardam uma pergunta ou termo na frente, e em seu verso, a resposta ou definição.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text("Exemplo: um flashcard tem ”Gato” na frente e ”Cat” no verso.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                }
                Spacer()
            }
            HBImages.cardsOnboarding
        }
        .padding()
    }
}

struct OnboardingPageTwoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageTwoView()
    }
}

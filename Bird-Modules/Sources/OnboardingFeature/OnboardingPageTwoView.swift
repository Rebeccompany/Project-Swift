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
            HStack {
                Text("Flashcards")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(HBColor.actionColor)
                Spacer()
            }
            Text("""
            São feitos para testar a memória! Eles guardam uma pergunta ou termo na frente, e em seu verso, a resposta ou definição. \
                \
            Exemplo: um flashcard tem ”Gato” na frente e ”Cat” no verso.
            """)
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(.black)
            HBImages.cardsOnboarding
            
        }
    }
}

struct OnboardingPageTwoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageTwoView()
    }
}

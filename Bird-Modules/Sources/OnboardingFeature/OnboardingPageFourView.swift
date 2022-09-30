//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird

struct OnboardingPageFourView: View {
    var body: some View {
        VStack {
            HBImages.BirdOneOnboarding
            HStack {
                Text("Modo Spixii")
                            .font(.title)
                            .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                Spacer()
            }
                    Text("""
            Modo de estudo para aprendizado a longo prazo baseado no método de repetição espaçada.  \
            \
            Nele, o app cria as sessões de estudo e controla quantos e quais cartões você deve estudar no dia.
            """)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
            
            HStack {
                Text("Modo Intenso")
                            .font(.title)
                            .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                Spacer()
            }
                    Text("""
            Modo de estudo para memorização a curto prazo de grande volume de conteúdo.   \
            \
            Nele, é possível estudar todos os cartões quando quiser.
            """)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.black)

        }
    }
}

struct OnboardingPageFourView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageFourView()
    }
}

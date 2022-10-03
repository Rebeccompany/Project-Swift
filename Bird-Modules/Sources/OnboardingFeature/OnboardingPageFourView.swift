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
                .resizable()
                .frame(width: 180, height: 180)
            HStack {
                VStack(alignment: .leading) {
                    Text("Modo Spixii")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text("Modo de estudo para aprendizado a longo prazo baseado no método de repetição espaçada.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    Text("Nele, o app cria as sessões de estudo e controla quantos e quais cartões você deve estudar no dia.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    Text("Modo Intenso")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text("Modo de estudo para memorização a curto prazo de grande volume de conteúdo.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    Text("Nele, é possível estudar todos os cartões quando quiser.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                }
                Spacer()
            }
            
        }
        .padding()
    }
}

struct OnboardingPageFourView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageFourView()
    }
}

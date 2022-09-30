//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird

struct OnboardingPageThreeView: View {
    var body: some View {
        VStack {
            HBImages.BirdThreeOnboarding
            HStack {
                Text("Baralhos")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(HBColor.actionColor)
                Spacer()
            }
            Text("""
    Os flashcards pertencem a um baralho! \
    \
    Exemplo: baralho chamado ”Animais”
    """)
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(.black)
            HBImages.decksOnboarding
            HStack {
                Text("Coleções")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(HBColor.actionColor)
                Spacer()
            }
            Text("""
    Os baralhos podem ser agrupados em coleções. \
    \
    Exemplo: coleção chamada ”Língua Inglesa”
    """)
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(.black)
            HBImages.collectionOnboarding
        }
    }
}

struct OnboardingPageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageThreeView()
    }
}

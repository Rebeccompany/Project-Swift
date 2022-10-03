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
                .resizable()
                .frame(width: 180, height: 180)
            HStack {
                VStack(alignment: .leading) {
                    Text("Baralhos")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text("Os flashcards pertencem a um baralho!")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    Text("Exemplo: baralho chamado ”Animais”")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                }
                Spacer()
            }
            HBImages.decksOnboarding
                .resizable()
                .frame(width: 150, height: 67)
            HStack {
                VStack(alignment: .leading) {
                    Text("Coleções")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text("Os baralhos podem ser agrupados em coleções.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    Text("Exemplo: coleção chamada ”Língua Inglesa”")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.bottom)
                }
                Spacer()
            }
            HBImages.collectionOnboarding
                .resizable()
                .frame(width: 150, height: 60)
        }
        .padding()
    }
}

struct OnboardingPageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageThreeView()
    }
}

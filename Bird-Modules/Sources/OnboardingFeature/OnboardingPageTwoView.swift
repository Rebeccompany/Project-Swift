//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird
import Models

struct OnboardingPageTwoView: View {
    var body: some View {
        VStack {
            HBImages.BirdOneOnboarding
                .resizable()
                .frame(width: 200, height: 200)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("flashcards", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_dois_um", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_dois_dois", bundle: .module, comment: ""))
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

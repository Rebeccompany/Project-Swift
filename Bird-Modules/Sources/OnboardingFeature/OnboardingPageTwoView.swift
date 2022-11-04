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
            HBImages.BirdTwoOnboarding
                .resizable()
                .frame(width: 180, height: 180)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("flashcards", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.vertical)
                    
                    Text(NSLocalizedString("pagina_dois_um", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    
                    Text(NSLocalizedString("pagina_dois_dois", bundle: .module, comment: ""))
                        .lineLimit(nil)
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
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct OnboardingPageTwoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageTwoView()
    }
}

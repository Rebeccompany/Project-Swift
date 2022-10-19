//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird
import Models

struct OnboardingPageFourView: View {
    var body: some View {
        VStack {
            HBImages.BirdOneOnboarding
                .resizable()
                .frame(width: 180, height: 180)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("modo_spixii", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_quatro_um", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_quatro_dois", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("modo_intenso", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_quatro_tres", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_quatro_quatro", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
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

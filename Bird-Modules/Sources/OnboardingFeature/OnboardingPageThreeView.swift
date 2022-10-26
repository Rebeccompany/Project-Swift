//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird
import Models

struct OnboardingPageThreeView: View {
    var body: some View {
        VStack {
            HBImages.BirdThreeOnboarding
                .resizable()
                .frame(width: 180, height: 180)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("baralhos", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_um", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_dois", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                }
                Spacer()
            }
            HBImages.decksOnboarding
                .resizable()
                .frame(width: 150, height: 67)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("colecoes", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_tres", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_quatro", bundle: .module, comment: ""))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
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

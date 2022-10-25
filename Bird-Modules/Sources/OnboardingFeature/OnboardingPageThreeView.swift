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
            ZStack(alignment: .bottom) {
                Circle()
                    .fill(HBColor.secondaryBackground)
                    .frame(width: 140, height: 140)
                HBImages.BirdThreeOnboarding
                    .resizable()
                    .frame(width: 210, height: 200)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("baralhos", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_um", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_dois", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                }
                Spacer()
            }
            HBImages.decksOnboarding
                .resizable()
                .frame(width: 95, height: 70)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("colecoes", bundle: .module, comment: ""))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(HBColor.actionColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_tres", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.bottom)
                    Text(NSLocalizedString("pagina_tres_quatro", bundle: .module, comment: ""))
                        .lineLimit(nil)
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
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct OnboardingPageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageThreeView()
    }
}

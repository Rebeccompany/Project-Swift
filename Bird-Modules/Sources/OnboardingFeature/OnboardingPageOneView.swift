//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird
import Models

struct OnboardingPageOneView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(HBColor.secondaryBackground)
                HBImages.BirdOneOnboarding
                    .resizable()
            }
            .frame(width: 250, height: 250)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("pagina_um", bundle: .module, comment: ""))
                        .lineLimit(nil)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.all)
                }
            }
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct OnboardingPageOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageOneView()
    }
}

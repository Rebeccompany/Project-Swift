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
            HBImages.BirdOneOnboarding
                .resizable()
                .frame(width: 250, height: 250)
            
            Text(NSLocalizedString("pagina_um", bundle: .module, comment: ""))
                .font(.title3)
                .fontWeight(.regular)
                .foregroundColor(HBColor.collectionTextColor)
                .padding(.all)
                .multilineTextAlignment(.center)
        }
    }
}

struct OnboardingPageOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageOneView()
    }
}

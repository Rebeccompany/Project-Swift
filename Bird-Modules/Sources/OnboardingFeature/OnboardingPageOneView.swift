//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 30/09/22.
//

import SwiftUI
import HummingBird

struct OnboardingPageOneView: View {
    var body: some View {
        VStack {
            HBImages.BirdOneOnboarding
                .resizable()
                .frame(width: 250, height: 250)
            HStack {
                VStack(alignment: .leading) {
                    Text("Aqui você pode estudar através de flashcards e potencializar seu aprendizado e memorização")
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(HBColor.collectionTextColor)
                        .padding(.all)
                }
            }
        }
    }
}

struct OnboardingPageOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageOneView()
    }
}

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
            Text("Aqui você pode estudar através de flashcards e potencializar seu aprendizado e memorização")
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(.black)
        }
    }
}

struct OnboardingPageOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageOneView()
    }
}

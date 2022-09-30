//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 29/09/22.
//

import SwiftUI
import HummingBird

struct OnboardingView: View {
    var body: some View {
        ZStack {
            TabView {
                OnboardingPageOneView()
                    .padding()
                OnboardingPageTwoView()
                    .padding()
                OnboardingPageThreeView()
                    .padding()
                OnboardingPageFourView()
                    .padding()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
        }
    }
}


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

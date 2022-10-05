//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 29/09/22.
//

import SwiftUI
import HummingBird

public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tab: Int = 0
    public init() {
        
    }
    public var body: some View {
        NavigationView {
            TabView(selection: $tab) {
                OnboardingPageOneView().tag(0)
                OnboardingPageTwoView().tag(1)
                OnboardingPageThreeView().tag(2)
                OnboardingPageFourView().tag(3)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .animation(.linear, value: tab)
            .toolbar {
                Button(tab == 3 ? "Começar" : "Pular") {
                    dismiss()
                }
                .foregroundColor(HBColor.actionColor)
                
            }
            
        }
    }
}


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

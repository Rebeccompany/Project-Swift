//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 29/09/22.
//

import SwiftUI
import HummingBird
import Models

public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tab: Int = 0
    public init() {
        
    }
    public var body: some View {
        NavigationStack {
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
                Button(tab == 3 ? NSLocalizedString("comecar", bundle: .module, comment: "") : NSLocalizedString("pular", bundle: .module, comment: "")) {
                    dismiss()
                }
                .foregroundColor(HBColor.actionColor)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .viewBackgroundColor(HBColor.primaryBackground)
        }
    }
}


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

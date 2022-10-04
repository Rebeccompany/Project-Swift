//
//  SwiftUIView.swift
//  
//
//  Created by Claudia Fiorentino on 29/09/22.
//

import SwiftUI
import HummingBird

var names = ["Pular","Pular","Pular","Começar"]

//var nomeBotao: [String] =
struct OnboardingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                TabView {
                    OnboardingPageOneView()
                    OnboardingPageTwoView()
                    OnboardingPageThreeView()
                    OnboardingPageFourView()
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .toolbar {
                ForEach(0..<names.endIndex) { index in
                    Button(names[index]) {
                        print("Hello")
                    }
                    .padding(.trailing)
                    .foregroundColor(HBColor.actionColor)

                }
            }
            
            
            
            //            .toolbar {
            //                if(TabView.indexViewStyle() == 4) {
            //                    Button("Começar") {
            //                        print("Hello")
            //                    }
            //                    .padding(.trailing)
            //                    .foregroundColor(HBColor.actionColor)
            //                }
            //                else {
            //                    Button("Pular") {
            //                        print("Hello")
            //                    }
            //                    .padding(.trailing)
            //                    .foregroundColor(HBColor.actionColor)
            //                }
            //            }
            
        }
    }
}


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

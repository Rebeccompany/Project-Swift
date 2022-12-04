//
//  ErrorView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import SwiftUI
import HummingBird

struct ErrorView: View {
    var action: () -> Void
    
    var body: some View {
        VStack {
            HBImages.errorSpixii
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .clipShape(Circle())
                .background {
                    Circle().fill(HBColor.secondaryBackground)
                }
                .frame(maxWidth: 300)
            
            Text("Oh no!, something is wrong, check your internet connection and press the button bellow to try again.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .padding(.bottom)
            
            Button {
                action()
            } label: {
                Label {
                    Text("Retry")
                } icon: {
                    Image(systemName: "gobackward")
                }

            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .frame(maxWidth: 320)
        }
    }
}

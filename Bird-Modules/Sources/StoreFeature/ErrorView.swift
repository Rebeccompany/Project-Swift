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
            
            Text("error_message".localized(.module))
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .padding(.bottom)
            
            Button {
                action()
            } label: {
                Label {
                    Text("retry".localized(.module))
                } icon: {
                    Image(systemName: "gobackward")
                }

            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .frame(maxWidth: 320)
        }
    }
}

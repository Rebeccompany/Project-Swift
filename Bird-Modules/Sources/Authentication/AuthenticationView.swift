//
//  AuthenticationView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import AuthenticationServices
import HummingBird
import SwiftUI

public struct AuthenticationView: View {
    @ObservedObject private var model: AuthenticationModel
    
    public init(model: AuthenticationModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack {
            Spacer()
            VStack {
                HBAssets.logo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Spixii")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
            }
            .padding()
            .frame(width: 300, height: 300)
            .background {
                RoundedRectangle(
                    cornerRadius: 32
                )
                .fill(HBColor.collectionBlack)
                .brightness(0.08)
            }
            Spacer()
            SignInWithAppleButton(
                onRequest: model.onSignInRequest,
                onCompletion: model.onSignInCompletion
            )
            .signInWithAppleButtonStyle(.white)
            .padding(.horizontal, 24)
            .frame(width: 330, height: 60)
        }
        .viewBackgroundColor(HBColor.collectionBlack)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(model: .init(keychainService: KeychainServiceMock()))
    }
}

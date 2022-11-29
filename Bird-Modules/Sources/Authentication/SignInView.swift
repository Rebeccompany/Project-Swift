//
//  SignInView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 28/11/22.
//

import SwiftUI
import AuthenticationServices
import HummingBird

struct SignInView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var model: AuthenticationModel
    @Binding private var path: NavigationPath
    private var dismiss: () -> Void
    
    init(model: AuthenticationModel, path: Binding<NavigationPath>, dismiss: @escaping () -> Void) {
        self.model = model
        self._path = path
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack {
            VStack {
                HBImages.spixiiBeach
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding([.horizontal])
            .frame(maxWidth: .infinity)
            .background(HBColor.collectionLightBlue.brightness(0.12))
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Hello!")
                    .font(.title.bold())
                    .padding(.bottom, 4)
                Text("To use our online features we need you to sign in. you just got to press the **Sign in with Apple** button below.")
                    .padding(.bottom, 4)
                Text("You will be able to **download** and **upload** your decks and more features are coming your way in the future.")
                    .padding(.bottom, 4)
                Text("If you do not wish to Sign in you can just press the **cancel** button")
            }
            .padding()
            .frame(maxWidth: 450)
            .padding(.bottom, 32)
            
            
            SignInWithAppleButton(
                onRequest: model.onSignInRequest,
                onCompletion: model.onSignInCompletion
            )
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(height: 44)
            .padding(.horizontal)
            .frame(maxWidth: 450)
            
            Button {
                dismiss()
            } label: {
                Text("Cancelar")
                    .frame(maxWidth: .infinity)
            }
            .tint(.red)
            .buttonStyle(.bordered)
            .frame(height: 44)
            .padding([.horizontal, .bottom])
            .frame(maxWidth: 450)
            
        }
        .onChange(of: model.shouldDismiss) { newValue in
            if newValue {
                dismiss()
            }
        }
        .onChange(of: model.currentLogedInUserIdentifer) { newValue in
            if newValue != nil {
                path.append(AuthenticationRoute.fillInfo)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        
    }
}

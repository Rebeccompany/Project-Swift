//
//  AuthenticationView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import AuthenticationServices
import HummingBird
import Habitat
import SwiftUI

public struct AuthenticationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    @ObservedObject private var model: AuthenticationModel
    
    public init(model: AuthenticationModel) {
        self.model = model
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            SignInView(model: model, path: $path) { dismiss() }
                .navigationDestination(for: AuthenticationRoute.self) { route in
                    switch route {
                    case .fillInfo:
                        FillInfoView(model: model, path: $path) { dismiss() }
                    }
                }
        }
        .onChange(of: model.user) { newValue in
            if newValue != nil {
                dismiss()
            }
        }
    }
}

enum AuthenticationRoute: Hashable {
    case fillInfo
}

struct FillInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var path: NavigationPath
    @ObservedObject private var model: AuthenticationModel
    @State private var userNameField: String = ""
    private var dismiss: () -> Void
    
    init(model: AuthenticationModel, path: Binding<NavigationPath>, dismiss: @escaping () -> Void) {
        self.model = model
        self._path = path
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack {
            HStack {
                HBImages.simplifiedSpixiiHeart
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HBImages.simplifiedSpixiiParty
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HBImages.simplifiedSpixiiHeart
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding()
            .padding(.vertical, 48)
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? HBColor.collectionBlack.brightness(0) : HBColor.collectionLightBlue.brightness(0.1))
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Just one more step")
                    .font(.title.bold())
                    .padding(.bottom, 4)
                
                Text("We would love to know how to call you! So please type in the field below a username.")
                    .padding(.bottom, 4)
                Text("Your username is going to show in all your public decks, so everyone knows the amazing pearson who built that Deck")
                    .padding(.bottom, 4)
                
            }
            .padding(.horizontal)
            .frame(maxWidth: 450)
            
            Spacer()
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Username")
                        .font(.headline)
                    Spacer()
                    Text("\(24 - userNameField.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                TextField("type your username here", text: $userNameField)
                    .onChange(of: userNameField) { newValue in
                        if userNameField.count > 24 {
                            userNameField = String(newValue.prefix(24))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(HBColor.primaryBackground)
                    .cornerRadius(8)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal)
            .frame(maxWidth: 450)
            
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .tint(.red)
                .buttonStyle(.bordered)
                .padding(.bottom, 8)
                
                Button {
                    model.completeSignUp(username: userNameField)
                } label: {
                    Text("Finish")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .tint(HBColor.actionColor)
                .buttonStyle(.borderedProminent)
                .disabled(userNameField.isEmpty)
            }
            .padding([.horizontal, .bottom])
            .frame(maxWidth: 450)
        }
        .navigationBarBackButtonHidden()
    }
}

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

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            AuthenticationView(model: .init())
        }
    }
}

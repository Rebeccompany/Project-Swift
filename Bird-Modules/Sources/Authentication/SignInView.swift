//
//  SignInView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 28/11/22.
//

import SwiftUI
import AuthenticationServices
import HummingBird
import Utils

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
                Text("hello".localized(.module))
                    .font(.title.bold())
                    .padding(.bottom, 4)
                Text("message_1".localized(.module))
                    .padding(.bottom, 4)
                Text("message_2".localized(.module))
                    .padding(.bottom, 4)
                Text("message_3".localized(.module))
            }
            .padding()
            .frame(maxWidth: 450)
            .padding(.bottom, 32)
            
            
            SignInWithAppleButton(.signIn) {
                model.onSignInRequest($0)
            } onCompletion: {
                model.onSignInCompletion($0)
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(height: 44)
            .padding(.horizontal)
            .frame(maxWidth: 450)
            
            Button {
                dismiss()
            } label: {
                Text("cancel".localized(.module))
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
        #if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
        #endif
        
    }
}

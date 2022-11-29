//
//  FillInfoView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 28/11/22.
//

import SwiftUI
import HummingBird

struct FillInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var path: NavigationPath
    @ObservedObject private var model: AuthenticationModel
    @State private var userNameField: String = ""
    @FocusState private var focusState: Int?
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
                    .focused($focusState, equals: 0)
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusState = nil
                }
            }
        }
    }
}

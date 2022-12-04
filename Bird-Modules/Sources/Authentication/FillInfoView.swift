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
                Text("name_title".localized(.module))
                    .font(.title.bold())
                    .padding(.bottom, 4)
                
                Text("name_message_1".localized(.module))
                    .padding(.bottom, 4)
                Text("name_message_2".localized(.module))
                    .padding(.bottom, 4)
                
            }
            .padding(.horizontal)
            .frame(maxWidth: 450)
            
            Spacer()
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("name_textfield_title".localized(.module))
                        .font(.headline)
                    Spacer()
                    Text("\(24 - userNameField.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                TextField("name_textfield_empty_state".localized(.module), text: $userNameField)
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
                    model.completeSignUp(username: userNameField)
                } label: {
                    Text("finish".localized(.module))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .tint(HBColor.actionColor)
                .buttonStyle(.borderedProminent)
                .disabled(userNameField.isEmpty)
                
                Button {
                    dismiss()
                } label: {
                    Text("cancel".localized(.module))
                        .frame(maxWidth: .infinity)
                }
                .tint(.red)
                .buttonStyle(.bordered)
                .padding(.bottom, 8)
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

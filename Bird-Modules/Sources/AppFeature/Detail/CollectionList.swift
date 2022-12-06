//
//  CollectionList.swift
//  
//
//  Created by Marcos Chevis on 28/11/22.
//

import SwiftUI
import Models
import HummingBird
struct CollectionList: View {
    @ObservedObject private var viewModel: ContentViewModel
    @Binding private var deck: Deck?
    
    @Environment(\.dismiss) private var dismiss
    
    internal init(viewModel: ContentViewModel, deck: Binding<Deck?>) {
        self.viewModel = viewModel
        self._deck = deck
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                #if os(iOS)
                List {
                    ForEach(viewModel.collections.filter { $0.id != deck?.collectionId }) { collection in
                        Button {
                            guard let deck else { return }
                            viewModel.change(deck: deck, to: collection)
                            dismiss()
                        } label: {
                            Label {
                                Text(collection.name)
                            } icon: {
                                Image(systemName: collection.icon.rawValue)
                            }
                            .foregroundColor(HBColor.collectionTextColor)
                        }
                    }
                }
                .backgroundStyle(HBColor.primaryBackground)
                #elseif os(macOS)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.collections.filter { $0.id != deck?.collectionId }) { collection in
                            HStack(alignment: .center) {
                                Button {
                                    guard let deck else { return }
                                    viewModel.change(deck: deck, to: collection)
                                    dismiss()
                                } label: {
                                    HStack {
                                        Label {
                                            Text(collection.name)
                                                .font(.system(size: 17))
                                        } icon: {
                                            Image(systemName: collection.icon.rawValue)
                                                .font(.system(size: 17))
                                        }
                                        .foregroundColor(HBColor.collectionTextColor)
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                }
                                .padding(.leading)
                                .padding(.top, 5)
                                .buttonStyle(.plain)
                                Spacer()
                            }
                            Divider()
                        }
                    }
                    .padding(.top)
                    .backgroundStyle(HBColor.primaryBackground)
                    
                }
                Spacer()
                #endif
                
                if deck?.collectionId != nil {
                    Button {
                        if let deck {
                            viewModel.change(deck: deck, to: nil)
                        }
                        dismiss()
                    } label: {
                        Text("remover_da_coleção".localized(.module))
                    }
                    .buttonStyle(DeleteButtonStyle())
                    .padding()
                }
            }
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(Text("escolher_coleção", bundle: .module))
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("cancelar", bundle: .module, comment: ""), role: .destructive) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            #elseif os(macOS)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancelar", bundle: .module, comment: ""), role: .destructive) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            #endif
        }
    }
}

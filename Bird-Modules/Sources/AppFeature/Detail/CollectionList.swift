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
                List {
                    ForEach(viewModel.collections) { collection in
                        if collection.id != deck?.collectionId {
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
                }
                .backgroundStyle(HBColor.primaryBackground)
                
                Button {
                    if let deck {
                        viewModel.change(deck: deck, to: nil)
                    }
                    dismiss()
                } label: {
                    Text("Remover da coleção")
                }
                .buttonStyle(DeleteButtonStyle())
                .padding()
            }
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(Text("escolher_coleção", bundle: .module))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("cancelar", bundle: .module, comment: ""), role: .destructive) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

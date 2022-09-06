//
//  SwiftUIView.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage

struct NewCollectionView: View {

    @ObservedObject var viewModel: NewCollectionViewModel

    public init(viewModel: NewCollectionViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack (alignment: .leading) {

            Text("Nome")
                .font(.callout)
                .bold()
            TextField("", text: $viewModel.collectionName)
                .textFieldStyle(CollectionDeckTextFieldStyle())
            Text("Cores")
                .font(.callout)
                .bold()

            IconColorGridView {
                ForEach(viewModel.colors, id: \.self) {color in
                    Button {

                    } label: {
                        HBColor.getHBColrFromCollectionColor(color)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))
                    .frame(width: 45, height: 45)
                }
            }
            Spacer()
        }
        .padding()
        .ViewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Criar Coleção")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    print("cancelarr!")
                }
                .foregroundColor(Color.red)

            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("OK") {
                    //viewModel.createCollection()
                }
            }


        }

    }
    
    
    
}

struct NewCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewCollectionView(
                viewModel: .init(
                    colors: CollectionColor.allCases,
                    collectionRepository: CollectionRepositoryMock()
                ))
                .preferredColorScheme(.light)
        }
        
        
    }
}

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

public struct NewCollectionView: View {

    @ObservedObject var viewModel: NewCollectionViewModel

    public init(viewModel: NewCollectionViewModel) {
        self.viewModel = viewModel
    }

   public var body: some View {

       NavigationView {
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
                            viewModel.currentSelectedColor = color

                        } label: {
                            HBColor.getHBColrFromCollectionColor(color)
                        }
                        .accessibility(label: Text(CollectionColor.getColorString(color)))
                        .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))
                        .frame(width: 45, height: 45)
                    }
                }
               
                Spacer()
               
               if (viewModel.editingCollection != nil) {
                   Button() {
                       viewModel.deleteCollection()
                   } label: {
                       Text("Apagar Coleção")
                   }
                   .buttonStyle(DeleteButtonStyle())

               }
               
            }
            .onAppear(perform: viewModel.startUp)
            .padding()
            .alert("Ocorreu um erro interno. Tente novamente.", isPresented: $viewModel.showingErrorAlert) {
                Button("OK", role: .cancel) { viewModel.showingErrorAlert = false}
                    }
            .ViewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(viewModel.editingCollection == nil ? "Criar Coleção" : "Editar Coleção")
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
                        if (viewModel.editingCollection == nil) {
                            viewModel.createCollection()
                        } else {
                            viewModel.editCollection()
                        }
                        
                    }
                    .disabled(!viewModel.canSubmit)
                }


        }
       }
       .navigationViewStyle(.stack)

    }
    
}

struct NewCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        
            NewCollectionView(
                viewModel: .init(
                    colors: CollectionColor.allCases,
                    collectionRepository: CollectionRepositoryMock()
                ))
                .preferredColorScheme(.light)
        
        
        
    }
}

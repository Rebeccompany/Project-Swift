//
//  NewDeckView.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage

struct NewDeckView: View {
    @ObservedObject
    var viewModel: NewDeckViewModel
    
    public init(viewModel: NewDeckViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Nome")
                .font(.callout)
                .bold()
            
            TextField("", text: $viewModel.deckName)
                .textFieldStyle(CollectionDeckTextFieldStyle())
                .padding(.bottom)
            
            Text("Cores")
                .font(.callout)
                .bold()
            
            IconColorGridView {
                ForEach (viewModel.colors, id: \.self) { color in
                    Button{
                        viewModel.currentSelectedColor = color
                    } label: {
                        HBColor.getHBColrFromCollectionColor(color)
                            .frame(width: 45, height: 45)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))

                }
            }
            
            Text("Ícones")
                .font(.callout)
                .bold()
                .padding(.top)
            
            IconColorGridView {
                ForEach (viewModel.icons, id: \.self) { icon in
                    Button{
                        viewModel.currentSelectedIcon = icon
                    } label: {
                        Image(systemName: IconNames.getIconString(icon))
                            .frame(width: 45, height: 45)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                    
                }
            }
            Spacer()
        }
        .onAppear(perform: viewModel.startUp)
        .padding()
        
        .ViewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Criar Baralho")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("OK") {
                    print("ok clicado")
                    viewModel.createDeck()
                }
                .disabled(viewModel.canSubmit)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    print("cancelar clicado")
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct NewDeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewDeckView(viewModel: NewDeckViewModel(colors: CollectionColor.allCases, icons: IconNames.allCases, deckRepository: DeckRepositoryMock(), collectionId: [UUID()]))
                .preferredColorScheme(.dark)
        }
    }
}

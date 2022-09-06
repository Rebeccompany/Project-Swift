//
//  SwiftUIView.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import HummingBird
import Models

struct NewCollectionView: View {
    
    @State var deckName: String = ""
    var colors: [CollectionColor]
    var currentSelectedColor: CollectionColor? = nil
    
    public init(colors: [CollectionColor], currentSelectedColor: CollectionColor?) {
        self.colors = colors
        self.currentSelectedColor = currentSelectedColor
    }
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Nome")
                .font(.callout)
                .bold()
            TextField("", text: $deckName)
                .textFieldStyle(CollectionDeckTextFieldStyle())
            Text("Cores")
                .font(.callout)
                .bold()
            
            IconColorGridView {
                ForEach(colors, id: \.self) {color in
                    Button {
                        
                    } label: {
                        HBColor.getHBColrFromCollectionColor(color)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: currentSelectedColor == color ? true : false))
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
                .foregroundColor(.red)
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("OK") {
                    print("ok!")
                }
            }
            
            
        }

    }
    
    
    
}

struct NewCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewCollectionView(colors: CollectionColor.allCases, currentSelectedColor: CollectionColor.red)
                .preferredColorScheme(.light)
        }
        
        
    }
}

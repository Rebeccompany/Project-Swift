//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import HummingBird
import Models

struct NewDeckView: View {
    @State var nameText: String = ""
    var colors: [CollectionColor]
    var icons: [IconNames]
    var currentSelectedColor: CollectionColor? = nil
    var currentSelectedIcon: IconNames? = nil
    
    public init(colors: [CollectionColor], icons: [IconNames], currentSelectedColor: CollectionColor, currentSelectedIcon: IconNames) {
        self.colors = colors
        self.icons = icons
        self.currentSelectedColor = currentSelectedColor
        self.currentSelectedIcon = currentSelectedIcon
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Nome")
                .font(.callout)
                .bold()
            
            TextField("", text: $nameText)
                .textFieldStyle(CollectionDeckTextFieldStyle())
                .padding(.bottom)
            
            Text("Cores")
                .font(.callout)
                .bold()
            
            IconColorGridView {
                ForEach (colors, id: \.self) { color in
                    Button{} label: {
                        HBColor.getHBColrFromCollectionColor(color)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: currentSelectedColor == color ? true : false))
                    .frame(width: 45, height: 45)
                }
            }
            
            Text("Ícones")
                .font(.callout)
                .bold()
                .padding(.top)
            
            IconColorGridView {
                ForEach (icons, id: \.self) { icon in
                    Button{} label: {
                        Image(systemName: IconNames.getIconString(icon))
                            .frame(width: 35, height: 35)
                    }
                    .buttonStyle(ColorIconButtonStyle(isSelected: currentSelectedIcon == icon ? true : false))
                    .frame(width: 45, height: 45)
                }
            }
            Spacer()
        }
        .padding()
        
        .ViewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Criar Baralho")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("OK") {
                    print("ok clicado")
                }
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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewDeckView(colors: CollectionColor.allCases, icons: IconNames.allCases, currentSelectedColor: CollectionColor.darkBlue, currentSelectedIcon: IconNames.book)
                .preferredColorScheme(.dark)
        }
    }
}

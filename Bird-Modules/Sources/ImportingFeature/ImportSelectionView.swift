//
//  ImportSelectionView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/22.
//

import SwiftUI
import HummingBird

struct ImportSelectionView: View {
    @Binding var presentFileSheet: Bool
    
    var body: some View {
        VStack {
            GroupBox("Arquivo CSV - .csv") {
                VStack(alignment: .leading) {
                    Text("O baralho no formato CSV precisa que seja um deck padrão com apenas frente e verso e **sem imagens**. Os nomes dos cabeçalhos do arquivo csv precisam ser ”Front” e ”Back”.")
                    Text("Se você tem um deck no formato Anki você pode transformar ele em CSV usando o link abaixo")
                    if let convertURL = URL(string: "https://www.easy4u.tools/apkg2csv") {
                        Link("Transformar .apkg em .csv", destination: convertURL)
                            .foregroundColor(HBColor.actionColor)
                            .padding(.top, 4)
                    }
                }
                .padding(.vertical)
                
                Button {
                    presentFileSheet = true
                } label: {
                   Label("Importar .csv", systemImage: "arrow.up")
                }
                .buttonStyle(.bordered)
                .tint(HBColor.actionColor)
                .foregroundColor(HBColor.actionColor)
                
                
            }
            .padding()
        }
        .navigationTitle("Importar Flashcards")
    }
}

struct ImportSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImportSelectionView(presentFileSheet: .constant(false))
    }
}

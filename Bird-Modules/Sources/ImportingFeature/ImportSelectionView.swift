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
            GroupBox(NSLocalizedString("csv_title", bundle: .module, comment: "")) {
                VStack(alignment: .leading) {
                    Text("csv_description", bundle: .module)
                    Text("csv_anki_description", bundle: .module)
                    if let convertURL = URL(string: "https://www.easy4u.tools/apkg2csv") {
                        Link(
                            NSLocalizedString("csv_anki_link", bundle: .module, comment: ""),
                            destination: convertURL
                        )
                            .foregroundColor(HBColor.actionColor)
                            .padding(.top, 4)
                    }
                }
                .padding(.vertical)
                
                Button {
                    presentFileSheet = true
                } label: {
                   Label(
                    NSLocalizedString("csv_import_button", bundle: .module, comment: ""),
                    systemImage: "arrow.up"
                   )
                }
                .buttonStyle(.bordered)
                .tint(HBColor.actionColor)
                .foregroundColor(HBColor.actionColor)
                
                
            }
            .padding()
        }
        .navigationTitle(Text("Importar Flashcards", bundle: .module))
    }
}

struct ImportSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImportSelectionView(presentFileSheet: .constant(false))
    }
}

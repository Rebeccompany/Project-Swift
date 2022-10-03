//
//  ImportView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/22.
//

import SwiftUI
import Flock

public struct ImportView: View {
    @State private var path: NavigationPath = .init()
    @State private var importedFiles: [ImportedCardInfo] = []
    @State private var presentFileSheet = false
    
    public init() {}
    
    public var body: some View {
        Router(path: $path) {
            ImportSelectionView(presentFileSheet: $presentFileSheet)
                .sheet(isPresented: $presentFileSheet) {
                    DocumentPicker(fileContent: $importedFiles)
                }
        } destination: { (route: ImportRoute) in
            switch route {
            case .preview(let cards):
                List(cards.indices, id: \.self) { i in
                    Text(cards[i].front)
                }
            }
        }
        .onChange(of: presentFileSheet) { newValue in
            if !newValue {
                path.append(ImportRoute.preview(cards: importedFiles))
            }
        }

    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}

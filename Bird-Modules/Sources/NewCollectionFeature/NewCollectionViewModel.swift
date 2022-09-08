//
//  NewCollectionViewModel.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Combine

class NewCollectionViewModel: ObservableObject {
    
    private let collectionRepository: CollectionRepositoryProtocol
    @Published var collectionName: String = ""
    var colors: [CollectionColor]
    @Published var currentSelectedColor: CollectionColor? = nil
    
    init(colors: [CollectionColor], collectionRepository: CollectionRepositoryProtocol = CollectionRepository()) {
        self.colors = colors
        self.collectionRepository = collectionRepository
    }
    
    
    func createCollection() {
        guard let selectedColor = currentSelectedColor else {
            #warning("error")
            return
        }
        do {
            try collectionRepository.createCollection(DeckCollection(id: UUID(), name: collectionName, color: selectedColor, datesLogs: DateLogs(lastAccess: Date(), lastEdit: Date(), createdAt: Date()), decksIds: []))
        } catch {
            #warning("tratar error")
        }
        
    }
}



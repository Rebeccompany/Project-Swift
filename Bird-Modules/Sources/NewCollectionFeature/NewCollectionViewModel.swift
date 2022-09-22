//
//  NewCollectionViewModel.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import Models
import Storage
import Combine
import Utils

public class NewCollectionViewModel: ObservableObject {
    @Published var collectionName: String = ""
    @Published var currentSelectedIcon: IconNames?
    @Published var canSubmit: Bool
    @Published var editingCollection: DeckCollection?
    
    private let dateHandler: DateHandlerProtocol
    private let idGenerator: UUIDGeneratorProtocol
    private let collectionRepository: CollectionRepositoryProtocol
    var icons: [IconNames]
    
    public init(
        collectionRepository: CollectionRepositoryProtocol = CollectionRepository.shared,
        dateHandler: DateHandlerProtocol = DateHandler(),
        idGenerator: UUIDGeneratorProtocol = UUIDGenerator(),
        editingCollection: DeckCollection? = nil
    ) {
        self.icons = IconNames.allCases
        self.collectionRepository = collectionRepository
        self.dateHandler = dateHandler
        self.idGenerator = idGenerator
        self.canSubmit = false
        self.editingCollection = editingCollection
        
        if let editingCollection = editingCollection {
            setupCollectionContentIntoFields(collection: editingCollection)
        }
        
    }
    
    private func setupCollectionContentIntoFields(collection: DeckCollection) {
        collectionName = collection.name
        currentSelectedIcon = collection.icon
    }
    
#warning("Leak de mémoria por auto referencia")
    func startUp() {
        Publishers.CombineLatest($collectionName, $currentSelectedIcon)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
    }
    
    private func canSubmitData(name: String, currentSelectedColor: IconNames?) -> Bool {
        !name.isEmpty && currentSelectedColor != nil
    }
    
    func createCollection() throws {
        guard let currentSelectedIcon
        else { return }
        
        try collectionRepository.createCollection(newCollection(selectedIcon: currentSelectedIcon))
    }
    
    func newCollection(selectedIcon: IconNames) -> DeckCollection {
        DeckCollection(
            id: idGenerator.newId(),
            name: collectionName,
            icon: selectedIcon,
            datesLogs: DateLogs(
                lastAccess: dateHandler.today,
                lastEdit: dateHandler.today,
                createdAt: dateHandler.today),
            decksIds: [])
    }
    
    func editCollection() throws {
        guard let currentSelectedIcon,
            let editingCollectionUnwraped = editingCollection
        else {
            return
        }
        
        var editingCollection = editingCollectionUnwraped
        editingCollection.name = collectionName
        editingCollection.icon = currentSelectedIcon
        editingCollection.datesLogs.lastAccess = dateHandler.today
        editingCollection.datesLogs.lastEdit = dateHandler.today
        try collectionRepository.editCollection(editingCollection)
        self.editingCollection = editingCollection
    }
    
    func deleteCollection() throws {
        guard let editingCollection = editingCollection
        else { return }
        try collectionRepository.deleteCollection(editingCollection)
    }
}

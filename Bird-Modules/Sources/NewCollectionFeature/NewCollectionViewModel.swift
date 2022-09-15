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
    @Published var currentSelectedColor: CollectionColor?
    @Published var canSubmit: Bool
    @Published var editingCollection: DeckCollection?
    
    private let dateHandler: DateHandlerProtocol
    private let idGenerator: UUIDGeneratorProtocol
    private let collectionRepository: CollectionRepositoryProtocol
    var colors: [CollectionColor]
    
    public init(
        colors: [CollectionColor],
        collectionRepository: CollectionRepositoryProtocol = CollectionRepository.shared,
        dateHandler: DateHandlerProtocol = DateHandler(),
        idGenerator: UUIDGeneratorProtocol = UUIDGenerator(),
        editingCollection: DeckCollection? = nil
    ) {
        self.colors = colors
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
        currentSelectedColor = collection.color
    }
    
    func startUp() {
        Publishers.CombineLatest($collectionName, $currentSelectedColor)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
    }
    
    private func canSubmitData(name: String, currentSelectedColor: CollectionColor?) -> Bool {
        !name.isEmpty && currentSelectedColor != nil
    }
    
    func createCollection() throws {
        guard let selectedColor = currentSelectedColor
        else { return }
        
        try collectionRepository.createCollection(newCollection(selectedColor: selectedColor))
    }
    
    func newCollection(selectedColor: CollectionColor) -> DeckCollection {
        DeckCollection(
            id: idGenerator.newId(),
            name: collectionName,
            color: selectedColor,
            datesLogs: DateLogs(
                lastAccess: dateHandler.today,
                lastEdit: dateHandler.today,
                createdAt: dateHandler.today),
            decksIds: [])
    }
    
    func editCollection() throws {
        guard let selectedColor = currentSelectedColor,
            let editingCollectionUnwraped = editingCollection
        else {
            return
        }
        
        var editingCollection = editingCollectionUnwraped
        editingCollection.name = collectionName
        editingCollection.color = selectedColor
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

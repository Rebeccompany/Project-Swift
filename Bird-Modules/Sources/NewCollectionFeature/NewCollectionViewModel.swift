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
    @Published var currentSelectedColor: CollectionColor? = nil
    @Published var canSubmit: Bool
    @Published var showingErrorAlert: Bool = false
    @Published var isEditing: Bool
    @Published var editingCollection: DeckCollection?
    
    
    private let dateHandler: DateHandlerProtocol
    private let idGenerator: UUIDGeneratorProtocol
    private let collectionRepository: CollectionRepositoryProtocol
    var colors: [CollectionColor]
    
    public init(
        colors: [CollectionColor],
        collectionRepository: CollectionRepositoryProtocol = CollectionRepository(),
        dateHandler: DateHandlerProtocol = DateHandler(),
        idGenerator: UUIDGeneratorProtocol = UUIDGenerator()
    ) {
        self.colors = colors
        self.collectionRepository = collectionRepository
        self.dateHandler = dateHandler
        self.idGenerator = idGenerator
        self.canSubmit = false
        self.isEditing = false
        
        
    }
    
    func startUp() {
        Publishers.CombineLatest($collectionName, $currentSelectedColor)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
        
        guard let editingCollectionName = editingCollection?.name else { return }
        collectionName = editingCollectionName
        guard let editingCollectionColor = editingCollection?.color else { return }
        currentSelectedColor = editingCollectionColor
    }
    
    private func canSubmitData(name: String, currentSelectedColor: CollectionColor?) -> Bool {
        !name.isEmpty && currentSelectedColor != nil
    }
    
    func createCollection() {
        guard let selectedColor = currentSelectedColor else { return }
        
        do {
            try collectionRepository.createCollection(newCollection(selectedColor: selectedColor))
        } catch {
            showingErrorAlert = true
        }
    }
    
    func newCollection(selectedColor: CollectionColor) -> DeckCollection {
        return DeckCollection(
            id: idGenerator.newId(),
            name: collectionName,
            color: selectedColor,
            datesLogs: DateLogs(
                lastAccess: dateHandler.today,
                lastEdit: dateHandler.today,
                createdAt: dateHandler.today),
            decksIds: [])
    }
    
    func editCollection() {
        guard let selectedColor = currentSelectedColor,
            var editingCollection = editingCollection
        else {
            return
        }
        do {
            editingCollection.name = collectionName
            editingCollection.color = selectedColor
            editingCollection.datesLogs.lastAccess = dateHandler.today
            editingCollection.datesLogs.lastEdit = dateHandler.today
            try collectionRepository.editCollection(editingCollection)
            
        } catch {
            showingErrorAlert = true
        }
    }
    
    func deleteCollection() {
        do {
            guard let editingCollection = editingCollection else { return }
            try collectionRepository.deleteCollection(editingCollection)
        } catch {
            showingErrorAlert = true
        }
    }
}



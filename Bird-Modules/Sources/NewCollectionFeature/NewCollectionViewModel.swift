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
        
    }
    
    func startUp() {
        Publishers.CombineLatest($collectionName, $currentSelectedColor)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
    }
    
    private func canSubmitData(name: String, currentSelectedColor: CollectionColor?) -> Bool {
        !name.isEmpty && currentSelectedColor != nil
    }
    
    func createCollection() {
        guard let selectedColor = currentSelectedColor else {
            return
        }
        do {
            try collectionRepository.createCollection(
                DeckCollection(
                    id: idGenerator.newId(),
                    name: collectionName,
                    color: selectedColor,
                    datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                    decksIds: []))
        } catch {
            showingErrorAlert = true
        }
        
    }
}



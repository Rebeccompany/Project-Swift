//
//  File.swift
//  
//
//  Created by Rebecca Mello on 08/11/22.
//

import Foundation
import Models
import ClassKit
import Storage

protocol Node {
    var parent: Node? { get }
    var children: [Node]? { get }
    var identifier: String { get }
    var contextType: CLSContextType { get }
}

extension Node {
    var identifierPath: [String] {
        var pathComponents: [String] = [identifier]
        
        if let parent = self.parent {
            pathComponents = parent.identifierPath + pathComponents
        }
        
        return pathComponents
    }
    
    /// Finds a node in the play list hierarchy by its identifier path.
    func descendant(matching identifierPath: [String]) -> Node? {
        if let identifier = identifierPath.first {
            if let child = children?.first(where: { $0.identifier == identifier }) {
                return child.descendant(matching: Array(identifierPath.suffix(identifierPath.count - 1)))
            } else {
                return nil
            }
        } else {
            return self
        }
    }
}

extension Deck: Node {
    var parent: Node? {
        nil
    }
    
    var children: [Node]? {
        nil
    }
    
    var identifier: String {
        self.storeId!
    }
    
    var contextType: CLSContextType {
        .exercise
    }
    
}

final public class CLSDeckLibrary: NSObject, CLSDataStoreDelegate {
    
    public static var shared = CLSDeckLibrary()
    
    private(set) var decks: [Deck] = []

    override private init() {
        super.init()
        setupClassKit()
    }
    
    func setupClassKit() {
        CLSDataStore.shared.delegate = self
    }
    
    public func addDecks(_ decks: [Deck], creatingContexts: Bool = true) {
        decks.forEach { deck in
            addDeck(deck, creatingContexts: creatingContexts)
        }
    }
    
    func addDeck(_ deck: Deck, creatingContexts: Bool = true) {
        if !decks.contains(where: { $0.storeId == deck.storeId }) {
            decks.append(deck)

            // Give ClassKit a chance to set up its contexts.
            if creatingContexts {
                setupContext(for: deck)
            }
        }
    }
    
    private func setupContext(for deck: Deck) {
        CLSDataStore.shared.mainAppContext.descendant(matchingIdentifierPath: deck.identifierPath) { _, _ in }
    }
    
    public func createContext(forIdentifier identifier: String, parentContext: CLSContext, parentIdentifierPath: [String]) -> CLSContext? {
        
        let identifierPath = parentIdentifierPath + [identifier]
        
        guard let deckIdentifier = identifierPath.first,
              let deckNode = Self.shared.decks.first(where: { $0.identifier == deckIdentifier }) else {
            return nil
        }
        
        let context = CLSContext(type: deckNode.contextType, identifier: identifier, title: deckNode.identifier)
        context.topic = .math
        
        context.universalLinkURL = URL(string: "spixii://" + deckIdentifier)
        
        return context
    }
}




// An extension to provide a complete identifier path for a given ClassKit context.
extension CLSContext {
    var identifierPath: [String] {
        var pathComponents: [String] = [identifier]
        
        if let parent = self.parent {
            pathComponents = parent.identifierPath + pathComponents
        }
        
        return pathComponents
    }
}

//public func publishContextIfNeeded(completion: ((Error?) -> Void)? = nil) {
//    let deckContext = CLSContext(type: .custom, identifier: "deck", title: "Deck")
//
//    let spixiiStudyContext = CLSContext(type: .task, identifier: "spixiiStudy", title: "Spixii Study")
//    spixiiStudyContext.displayOrder = 0
//
//    let intenseStudyContext = CLSContext(type: .task, identifier: "intenseStudy", title: "Intense Study")
//    intenseStudyContext.displayOrder = 1
//
//    var deckContextToCreate: [String: CLSContext] = [
//        deckContext.identifier: deckContext
//    ]
//
//    var studyContextsToCreate: [String: CLSContext] = [
//        spixiiStudyContext.identifier: spixiiStudyContext,
//        intenseStudyContext.identifier: intenseStudyContext
//    ]
//
//    let deckParent = CLSDataStore.shared.mainAppContext
//    let deckPredicate = NSPredicate(format: "parent = %@", deckParent)
//    CLSDataStore.shared.contexts(matching: deckPredicate) { contexts, _ in
//        for context in contexts {
//            deckContextToCreate.removeValue(forKey: context.identifier)
//        }
//        for (_, context) in deckContextToCreate {
//            deckParent.addChildContext(context)
//        }
//    }
//
//    let studyParent = deckContext
//    let studyPredicate = NSPredicate(format: "parent = %@", studyParent)
//    CLSDataStore.shared.contexts(matching: studyPredicate) { contexts, _ in
//        for context in contexts {
//            studyContextsToCreate.removeValue(forKey: context.identifier)
//        }
//        for (_, context) in studyContextsToCreate {
//            studyParent.addChildContext(context)
//        }
//    }
//
//    CLSDataStore.shared.save() { (error) in
//        completion?(error)
//        if let error = error {
//            print(error.localizedDescription)
//        }
//    }
//}

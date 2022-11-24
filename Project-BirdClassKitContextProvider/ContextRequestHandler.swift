//
//  ContextRequestHandler.swift
//  Project-BirdClassKitContextProvider
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit
import ClassKitFeature

import Combine
final class ContextRequestHandler: NSObject, NSExtensionRequestHandling, CLSContextProvider {
    func beginRequest(with context: NSExtensionContext) {}
    
    func updateDescendants(of context: CLSContext, completion: @escaping (Error?) -> Void) {
        CLSDeckLibrary.shared.updateDescendants(of: context, completion: completion)
    }
}

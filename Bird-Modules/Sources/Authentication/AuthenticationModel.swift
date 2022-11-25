//
//  AuthenticationModel.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import Foundation
import AuthenticationServices
import SwiftUI

public final class AuthenticationModel: ObservableObject {
    
    @Published public var currentLogedInUserIdentifer: String?
    @Published public var didOcurredErrorOnSignInCompletion: Bool = false
    @Published var shouldDismiss = false
    
    private let idProvider = ASAuthorizationAppleIDProvider()
    private let keychainService: KeychainServiceProtocol
    
    private let credentialKey = "userCredential"
    private let accessGroup = "com.projectbird.birdmodules.authentication"
    private let serviceKey = "com.projectbird.spixii"
    
    public init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
        self.currentLogedInUserIdentifer = try? keychainService.get(forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
    }
    
    func onSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
    }
    
    func onSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            onSignInSuccess(auth)
        case .failure(_):
            didOcurredErrorOnSignInCompletion = true
        }
    }
    
    private func onSignInSuccess(_ auth: ASAuthorization) {
        switch auth.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            onAppleIdCredentialReceived(appleIDCredential)
        default:
            break
        }
    }
    
    private func onAppleIdCredentialReceived(_ appleIDCredential: ASAuthorizationAppleIDCredential) {
        do {
            try keychainService.set(appleIDCredential.user, forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
            currentLogedInUserIdentifer = appleIDCredential.user
            //Save no back
        } catch {
            didOcurredErrorOnSignInCompletion = true
        }
    }
    
    public func isSignedIn() async throws -> Bool {
        guard let currentLogedInUserIdentifer else { return false }
        
        let state = try await idProvider.credentialState(forUserID: currentLogedInUserIdentifer)
        switch state {
        case .authorized:
            self.shouldDismiss = true
            return true
        case .notFound, .revoked:
            return false
        default:
            return false
        }
    }
}

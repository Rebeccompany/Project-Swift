//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import Foundation
import AuthenticationServices
import SwiftUI

final class AuthenticationModel: ObservableObject {
    
    @Published var currentLogedInUserIdentifer: String?
    @Published var didOcurredErrorOnSignInCompletion: Bool = false
    
    private let idProvider = ASAuthorizationAppleIDProvider()
    
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
        currentLogedInUserIdentifer = appleIDCredential.user
    }
    
    func isSignedIn() async throws -> Bool {
        guard let currentLogedInUserIdentifer else { return false }
        
        let state = try await idProvider.credentialState(forUserID: currentLogedInUserIdentifer)
        switch state {
        case .authorized:
            return true
        case .notFound, .revoked:
            return false
        default:
            return false
        }
    }
}

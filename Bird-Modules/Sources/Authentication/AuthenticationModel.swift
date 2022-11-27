//
//  AuthenticationModel.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import Foundation
import Habitat
import Puffins
import Keychain
import AuthenticationServices
import Combine
import Models

public final class AuthenticationModel: ObservableObject {
    
    @Dependency(\.externalUserService) private var userService
    
    @Published public var currentLogedInUserIdentifer: String?
    @Published public var user: UserDTO?
    @Published public var didOcurredErrorOnSignInCompletion: Bool = false
    @Published var shouldDismiss = false
    
    private let idProvider = ASAuthorizationAppleIDProvider()
    
    //COLOCAR NO HABITAT
    private let keychainService: KeychainServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private let credentialKey = "userCredential"
    private let accessGroup = "com.projectbird.birdmodules.authentication"
    private let serviceKey = "com.projectbird.spixii"
    
    public init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
        self.currentLogedInUserIdentifer = try? keychainService.get(forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
        print("User_ID", currentLogedInUserIdentifer)
        //pegar id e buscar usuario
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
    
    public func signOut() {
        do {
            try keychainService.delete(forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
            currentLogedInUserIdentifer = nil
        } catch {
            didOcurredErrorOnSignInCompletion = true
        }
    }
    
    public func deleteAccount() {
        
    }
    
    func onSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
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
        print("User_ID", appleIDCredential.user)
//        userService.singUp(user: UserDTO(appleIdentifier: appleIDCredential.user, userName: appleIDCredential.fullName?.formatted() ?? " "))
//            .receive(on: RunLoop.main)
//            .sink {[weak self] completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(_):
//                    self?.didOcurredErrorOnSignInCompletion = true
//                }
//            } receiveValue: {[weak self] user in
//                self?.saveIdInKeychain(user.appleIdentifier)
//            }
//            .store(in: &cancellables)

    }
    
    private func saveIdInKeychain(_ id: String) {
        do {
            try keychainService.set(id, forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
            currentLogedInUserIdentifer = id
            shouldDismiss = true
        } catch {
            didOcurredErrorOnSignInCompletion = true
        }
    }
}

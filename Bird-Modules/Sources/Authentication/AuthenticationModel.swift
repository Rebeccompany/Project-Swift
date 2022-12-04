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

@MainActor
public final class AuthenticationModel: ObservableObject {
    
    @Dependency(\.externalUserService) private var userService
    @Dependency(\.externalDeckService) private var externalDeckService
    @Dependency(\.deckRepository) private var deckRepository
    @Dependency(\.keychainService) private var keychainService
    @Dependency(\.notificationCenter) private var notificationCenter
    
    @Published public var currentLogedInUserIdentifer: String?
    @Published public var user: User?
    @Published public var didOcurredErrorOnSignInCompletion: Bool = false
    @Published var shouldDismiss = false

    private let idProvider = ASAuthorizationAppleIDProvider()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let credentialKey = "userCredential"
    private let refreshTokenKey = "refreshToken"
    private let accessGroup = "com.projectbird.birdmodules.authentication"
    private let serviceKey = "com.projectbird.spixii"
    
    private var authCode: Data?
    
    public init() {
        let id = try? keychainService.get(forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
        signIn(id: id)
        setup(id: id)
    }
    
    private func setup(id: String?) {
        guard let id else { return }
        
        notificationCenter.notificationPublisher(
            for: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )
        .sink {[weak self] _ in
            self?.deleteUserAfterTokenBeenRevoked(cameFromNotification: true, userId: id)
        }
        .store(in: &cancellables)
    }
    
    public func isSignedIn() async throws -> Bool {
        guard let user else { return false }
        let state = try await idProvider.credentialState(forUserID: user.appleIdentifier)
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
            try keychainService.delete(forKey: refreshTokenKey, inService: serviceKey, inGroup: accessGroup)
            currentLogedInUserIdentifer = nil
            user = nil
        } catch {
            didOcurredErrorOnSignInCompletion = true
        }
    }
    
    public func deleteAccount() {
        guard
            let user,
            let refreshToken = try? keychainService.get(forKey: refreshTokenKey, inService: serviceKey, inGroup: accessGroup)
        else {
            return
        }
        
        userService
            .revokeUser(data: SignUpResponse(user: user, refreshToken: refreshToken))
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    self?.deleteUserAfterTokenBeenRevoked(userId: user.appleIdentifier)
                case.failure(_):
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

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
    
    func completeSignUp(username: String) {
        guard
            let currentLogedInUserIdentifer,
            let authCode,
            let decodedAuthCode = String(data: authCode, encoding: .utf8)
        else {
            didOcurredErrorOnSignInCompletion = true
            return
        }
        userService.signUp(user: SignInDTO(user: User(appleIdentifier: currentLogedInUserIdentifer, userName: username), authorizationCode: decodedAuthCode))
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.didOcurredErrorOnSignInCompletion = true
                }
            } receiveValue: {[weak self] response in
                self?.saveIdInKeychain(response.user.appleIdentifier, refreshToken: response.refreshToken)
                self?.user = response.user
            }
            .store(in: &cancellables)
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
        guard
            let authData = appleIDCredential.authorizationCode,
            let decodedAuthCode = String(data: authData, encoding: .utf8)
        else {
            didOcurredErrorOnSignInCompletion = true
            return
        }
        userService.signIn(user: SignInDTO(user: User(appleIdentifier: appleIDCredential.user, userName: ""), authorizationCode: decodedAuthCode))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.currentLogedInUserIdentifer = appleIDCredential.user
                    self?.authCode = appleIDCredential.authorizationCode
                }
            } receiveValue: { [weak self] response in
                self?.user = response.user
                self?.saveIdInKeychain(response.user.appleIdentifier, refreshToken: response.refreshToken)
            }
            .store(in: &cancellables)

    }
    
    private func saveIdInKeychain(_ id: String, refreshToken: String) {
        do {
            try keychainService.set(id, forKey: credentialKey, inService: serviceKey, inGroup: accessGroup)
            try keychainService.set(refreshToken, forKey: refreshTokenKey, inService: serviceKey, inGroup: accessGroup)
            currentLogedInUserIdentifer = id
            shouldDismiss = true
        } catch {
            didOcurredErrorOnSignInCompletion = true
        }
    }
    
    private func signIn(id: String?) {
        guard let id else { return }
        
        userService
            .authUser(id: id)
            .map { $0 as User? }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .assign(to: &$user)
    }
    
    private func deleteUserAfterTokenBeenRevoked(cameFromNotification: Bool = false, userId: String) {
        if cameFromNotification {
            removeUserDataFromServer(userId: userId)
        }
        
        signOut()
        removeDecksFromServer(userId: userId)
        removeStoreIdFromDecks(userId: userId)
    }
    
    private func removeStoreIdFromDecks(userId: String) {
        deckRepository
            .deckListener()
            .first()
            .map { $0.filter { deck in deck.storeId != nil && deck.ownerId == userId } }
            .replaceError(with: [])
            .sink {[weak self] decks in
                decks.forEach { deck in
                    var editedDeck = deck
                    editedDeck.storeId = nil
                    editedDeck.ownerId = nil
                    try? self?.deckRepository.editDeck(editedDeck)
                }
            }
            .store(in: &cancellables)
    }
    
    private func removeDecksFromServer(userId: String) {
        externalDeckService
            .deleteAllDeckFromUser(id: userId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

    }
    
    private func removeUserDataFromServer(userId: String) {
        userService
            .deleteUser(id: userId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

    }
}

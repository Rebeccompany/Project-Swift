//
//  AuthModelTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 28/11/22.
//

import XCTest
@testable import Authentication
import AuthenticationServices
import Models
import Habitat
import Keychain
import Puffins

final class AuthModelTests: XCTestCase {
    
    var sut: AuthenticationModel!
    var keychainService: KeychainServiceMock!
    var userService: ExternalUserServiceMock!

    @MainActor override func setUp() {
        keychainService = KeychainServiceMock()
        userService = ExternalUserServiceMock()
        
        setupHabitatForIsolatedTesting(
            externalUserService: userService,
            keychainService: keychainService
        )
        
        sut = AuthenticationModel()
    }
    
    override func tearDown() {
        sut = nil
        keychainService = nil
        userService = nil
    }
    
    @MainActor func testOnReceiveRequest() {
        let request = ASAuthorizationAppleIDRequest(coder: NSCoder())!
        sut.onSignInRequest(request)
        XCTAssertEqual(request.requestedScopes, [.fullName, .email])
    }

}

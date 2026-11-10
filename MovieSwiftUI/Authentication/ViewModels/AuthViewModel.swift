//
//  AuthViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    
    enum LoadingAction {
        case guest
        case signIn
    }
    typealias WebAuthenticator = (_ url: URL, _ callbackScheme: String) async throws -> URL

    private let createGuestSessionUseCase: any CreateGuestSessionUseCase
    private let createRequestTokenUseCase: any CreateRequestTokenUseCase
    private let createSessionUseCase: any CreateSessionUseCase
    private let configuration: AuthConfiguration

    private(set) var authState: AuthState = .missing
    private(set) var loadingAction: LoadingAction?
    private(set) var errorMessage: String?
    var isLoading: Bool { loadingAction != nil }

    init(
        createGuestSessionUseCase: any CreateGuestSessionUseCase,
        createRequestTokenUseCase: any CreateRequestTokenUseCase,
        createSessionUseCase: any CreateSessionUseCase,
        configuration: AuthConfiguration = .live
    ) {
        self.createGuestSessionUseCase = createGuestSessionUseCase
        self.createRequestTokenUseCase = createRequestTokenUseCase
        self.createSessionUseCase = createSessionUseCase
        self.configuration = configuration
    }

    // MARK: - Guest

    func continueAsGuest() async {
        guard !isLoading else { return }

        loadingAction = .guest
        errorMessage = nil
        defer { loadingAction = nil }

        do {
            let sessionId = try await createGuestSessionUseCase.execute()
            try Task.checkCancellation()

            authState = .guest(sessionId: sessionId)
        } catch is CancellationError {
            // Cancelled
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - TMDB Sign In

    func signIn(using authenticate: WebAuthenticator) async {
        guard !isLoading else { return }

        loadingAction = .signIn
        errorMessage = nil
        defer { loadingAction = nil }

        do {
            let token = try await createRequestTokenUseCase.execute()
            let url = try configuration.authorizationURL(for: token)
            let callbackURL = try await authenticate(url, configuration.callbackScheme)

            guard configuration.isValidCallback(callbackURL) else {
                throw AuthConfigurationError.invalidCallback
            }

            let sessionId = try await createSessionUseCase.execute(requestToken: token)
            try Task.checkCancellation()

            authState = .signedIn(sessionId: sessionId)
        } catch is CancellationError {
            // Cancelled
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Sign Out

    func signOut() {
        authState = .missing
        errorMessage = nil
    }
}

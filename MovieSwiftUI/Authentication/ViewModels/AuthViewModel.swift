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
    private let authSessionStorage: any AuthSessionStorage
    private let configuration: AuthConfiguration

    private(set) var authState: AuthState = .missing
    private(set) var loadingAction: LoadingAction?
    private(set) var errorMessage: String?
    var isLoading: Bool { loadingAction != nil }
    var isSignedIn: Bool {
        if case .signedIn = authState { return true }
        return false
    }
    var sessionId: String? {
        if case .signedIn(let sessionId) = authState { return sessionId }
        return nil
    }
    init(
        createGuestSessionUseCase: any CreateGuestSessionUseCase,
        createRequestTokenUseCase: any CreateRequestTokenUseCase,
        createSessionUseCase: any CreateSessionUseCase,
        authSessionStorage: any AuthSessionStorage,
        configuration: AuthConfiguration = .live
    ) {
        self.createGuestSessionUseCase = createGuestSessionUseCase
        self.createRequestTokenUseCase = createRequestTokenUseCase
        self.createSessionUseCase = createSessionUseCase
        self.authSessionStorage = authSessionStorage
        self.configuration = configuration
        restoreSession()
    }

    // MARK: - Session Restore

    private func restoreSession() {
        if let sessionId = authSessionStorage.getSessionId() {
            authState = .signedIn(sessionId: sessionId)
        } else if let guestSessionId = authSessionStorage.getGuestSessionId() {
            authState = .guest(sessionId: guestSessionId)
        }
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

            authSessionStorage.saveGuestSessionId(sessionId)
            authState = .guest(sessionId: sessionId)
        } catch {
            handle(error: error, fallback: "Failed continuing as guest")
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

            authSessionStorage.saveSessionId(sessionId)
            authSessionStorage.removeGuestSessionId()
            authState = .signedIn(sessionId: sessionId)
        } catch {
            handle(error: error, fallback: "Failed signing in")
        }
    }

    // MARK: - Sign Out

    func signOut() {
        authSessionStorage.removeSessionId()
        authSessionStorage.removeGuestSessionId()
        authState = .missing
        errorMessage = nil
    }
    
    // MARK: - Error Handling

    private func handle(error: Error, fallback: String) {
        guard !error.isCancellation else { return }
        errorMessage = error.isInternetConnectionError ? "No internet connection" : fallback
    }
}

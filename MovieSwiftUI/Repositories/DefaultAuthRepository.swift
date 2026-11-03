//
//  DefaultAuthRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

enum AuthRepositoryError: LocalizedError {
    case invalidGuestSession
    case invalidRequestToken
    case invalidUserSession

    var errorDescription: String? {
        switch self {
        case .invalidGuestSession:
            "Couldn't start a guest session. Please try again."
        case .invalidRequestToken:
            "Couldn't start sign in. Please try again."
        case .invalidUserSession:
            "Sign in failed. Please try again."
        }
    }
}

final class DefaultAuthRepository: AuthRepository {

    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Guest Authentication

    func createGuestSession() async throws -> String {

        let response = try await networkClient.request(
            AuthEndpoints.guestSession()
        )

        guard response.success,
              !response.guestSessionId.isEmpty else {
            throw AuthRepositoryError.invalidGuestSession
        }

        return response.guestSessionId
    }

    // MARK: - User Authentication

    func createRequestToken() async throws -> String {

        let response = try await networkClient.request(
            AuthEndpoints.requestToken()
        )

        guard response.success,
              !response.requestToken.isEmpty else {
            throw AuthRepositoryError.invalidRequestToken
        }

        return response.requestToken
    }

    func createSession(
        requestToken: String
    ) async throws -> String {

        let response = try await networkClient.request(
            AuthEndpoints.createSession(
                requestToken: requestToken
            )
        )

        guard response.success,
              !response.sessionId.isEmpty else {
            throw AuthRepositoryError.invalidUserSession
        }

        return response.sessionId
    }
}

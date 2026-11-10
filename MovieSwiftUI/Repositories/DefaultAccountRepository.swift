//
//  DefaultAccountRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultAccountRepository: AccountRepository {

    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchAccount(sessionId: String) async throws -> Account {
        let response = try await networkClient.request(
            AccountEndpoints.details(sessionId: sessionId)
        )

        return Account(
            id: response.id,
            username: response.username,
            avatarPath: response.avatar?.tmdb?.avatarPath
        )
    }
}

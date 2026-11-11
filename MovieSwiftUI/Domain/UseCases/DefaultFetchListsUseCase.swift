//
//  DefaultFetchListsUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultFetchListsUseCase: FetchListsUseCase {

    private let accountRepository: any AccountRepository
    private let listRepository: any ListRepository

    init(
        accountRepository: any AccountRepository,
        listRepository: any ListRepository
    ) {
        self.accountRepository = accountRepository
        self.listRepository = listRepository
    }

    func execute(sessionId: String, page: Int) async throws -> MovieListsPage {
        let account = try await accountRepository.fetchAccount(
            sessionId: sessionId
        )

        return try await listRepository.fetchLists(
            accountId: account.id,
            sessionId: sessionId,
            page: page
        )
    }
}

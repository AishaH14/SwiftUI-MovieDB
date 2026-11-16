//
//  DefaultFetchAccountUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultFetchAccountUseCase: FetchAccountUseCase {

    private let accountRepository: any AccountRepository

    init(accountRepository: any AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute(sessionId: String) async throws -> Account {
        try await accountRepository.fetchAccount(sessionId: sessionId)
    }
}

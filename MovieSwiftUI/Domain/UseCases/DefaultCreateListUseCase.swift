//
//  DefaultCreateListUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultCreateListUseCase: CreateListUseCase {

    private let listRepository: any ListRepository

    init(listRepository: any ListRepository) {
        self.listRepository = listRepository
    }

    func execute(
        sessionId: String,
        name: String,
        description: String
    ) async throws -> Int {
        try await listRepository.createList(
            sessionId: sessionId,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}

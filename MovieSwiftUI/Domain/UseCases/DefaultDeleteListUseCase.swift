//
//  DefaultDeleteListUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultDeleteListUseCase: DeleteListUseCase {

    private let listRepository: any ListRepository

    init(listRepository: any ListRepository) {
        self.listRepository = listRepository
    }

    func execute(listId: Int, sessionId: String) async throws {
        try await listRepository.deleteList(
            listId: listId,
            sessionId: sessionId
        )
    }
}

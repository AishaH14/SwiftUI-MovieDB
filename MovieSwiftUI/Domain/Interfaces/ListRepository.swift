//
//  ListRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol ListRepository {
    func fetchLists(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MovieListsPage
    func createList(
        sessionId: String,
        name: String,
        description: String
    ) async throws -> Int
    func deleteList(
        listId: Int,
        sessionId: String)
    async throws
}

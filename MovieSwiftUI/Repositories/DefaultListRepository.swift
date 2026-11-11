//
//  DefaultListRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultListRepository: ListRepository {

    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchLists(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MovieListsPage {

        let response = try await networkClient.request(
            ListEndpoints.accountLists(
                accountId: accountId,
                sessionId: sessionId,
                page: page
            )
        )

        return MovieListsPage(
            page: response.page,
            totalPages: response.totalPages,
            lists: response.results.map(makeList)
        )
    }
    func createList(
        sessionId: String,
        name: String,
        description: String
    ) async throws -> Int {

        let response = try await networkClient.request(
            ListEndpoints.createList(
                sessionId: sessionId,
                request: CreateListRequestDTO(
                    name: name,
                    description: description,
                    language: "en"
                )
            )
        )

        guard response.success else {
            throw ListRepositoryError.createFailed
        }

        return response.listId
    }
    func deleteList(listId: Int, sessionId: String) async throws {
        _ = try await networkClient.request(
            ListEndpoints.deleteList(
                listId: listId,
                sessionId: sessionId
            )
        )
    }

    // MARK: - Helpers

    private func makeList(from dto: ListDTO) -> MovieList {
        MovieList(
            id: dto.id,
            name: dto.name,
            description: dto.description ?? "",
            itemCount: dto.itemCount,
            posterPath: dto.posterPath
        )
    }
}

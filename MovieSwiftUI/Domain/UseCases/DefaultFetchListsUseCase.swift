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

        let listsPage = try await listRepository.fetchLists(
            accountId: account.id,
            sessionId: sessionId,
            page: page
        )

        return MovieListsPage(
            page: listsPage.page,
            totalPages: listsPage.totalPages,
            lists: await withCoverPosters(listsPage.lists)
        )
    }

    private func withCoverPosters(_ lists: [MovieList]) async -> [MovieList] {
        let listRepository = listRepository

        return await withTaskGroup(of: (Int, MovieList).self) { group in
            for (index, list) in lists.enumerated() {
                group.addTask {
                    guard list.posterPath == nil, list.itemCount > 0,
                          let details = try? await listRepository.fetchListDetails(listId: list.id)
                    else { return (index, list) }

                    let coverList = MovieList(
                        id: list.id,
                        name: list.name,
                        description: list.description,
                        itemCount: list.itemCount,
                        posterPath: details.items.first?.posterPath
                    )
                    return (index, coverList)
                }
            }

            var result = lists
            for await (index, list) in group {
                result[index] = list
            }
            return result
        }
    }
        
    }

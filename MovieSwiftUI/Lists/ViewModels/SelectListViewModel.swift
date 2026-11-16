//
//  SelectListViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class SelectListViewModel {

    enum State {
        case loading
        case loaded
        case failed(String)
    }

    private let movieId: Int
    private let sessionId: String
    private let fetchListsUseCase: any FetchListsUseCase
    private let listMoviesUseCase: any ListMoviesUseCase

    private(set) var state: State = .loading
    private(set) var lists: [MovieList] = []
    private(set) var selectedListIds: Set<Int> = []
    private(set) var isSaving = false
    var errorMessage: String?

    private var initialListIds: Set<Int> = []

    var hasChanges: Bool { selectedListIds != initialListIds }

    init(
        movieId: Int,
        sessionId: String,
        fetchListsUseCase: any FetchListsUseCase,
        listMoviesUseCase: any ListMoviesUseCase
    ) {
        self.movieId = movieId
        self.sessionId = sessionId
        self.fetchListsUseCase = fetchListsUseCase
        self.listMoviesUseCase = listMoviesUseCase
    }

    // MARK: - Loading

    func load() async {
        state = .loading

        do {
            let page = try await fetchListsUseCase.execute(sessionId: sessionId, page: 1)
            lists = page.lists
            initialListIds = try await listIdsContainingMovie(in: page.lists)
            selectedListIds = initialListIds
            state = .loaded
        } catch {
            guard !error.isCancellation else { return }
            state = .failed(message(for: error, fallback: "Failed loading lists"))
        }
    }

    // MARK: - Selection

    func isSelected(_ list: MovieList) -> Bool {
        selectedListIds.contains(list.id)
    }

    func toggle(_ list: MovieList) {
        if selectedListIds.contains(list.id) {
            selectedListIds.remove(list.id)
        } else {
            selectedListIds.insert(list.id)
        }
    }

    // MARK: - Save

    func save() async -> Bool {
        isSaving = true
        defer { isSaving = false }

        do {
            for listId in selectedListIds.subtracting(initialListIds) {
                try await listMoviesUseCase.addMovie(movieId, toList: listId, sessionId: sessionId)
            }
            for listId in initialListIds.subtracting(selectedListIds) {
                try await listMoviesUseCase.removeMovie(movieId, fromList: listId, sessionId: sessionId)
            }
            return true
        } catch {
            errorMessage = message(for: error, fallback: "Failed updating your lists")
            return false
        }
    }

    // MARK: - Helpers

    private func listIdsContainingMovie(in lists: [MovieList]) async throws -> Set<Int> {
        let movieId = movieId
        let useCase = listMoviesUseCase

        return try await withThrowingTaskGroup(of: (Int, Bool).self) { group in
            for list in lists {
                group.addTask {
                    (list.id, try await useCase.isMovie(movieId, inList: list.id))
                }
            }

            var ids = Set<Int>()
            for try await (listId, isInList) in group where isInList {
                ids.insert(listId)
            }
            return ids
        }
    }

    private func message(for error: Error, fallback: String) -> String {
        error.isInternetConnectionError ? "No internet connection" : fallback
    }
}

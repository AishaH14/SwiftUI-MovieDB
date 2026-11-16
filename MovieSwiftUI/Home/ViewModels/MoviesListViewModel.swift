//
//  MoviesListViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

enum MoviesListSource: Hashable {
    case search
    case section(MovieSection)
}

@MainActor
@Observable
final class MoviesListViewModel {

    enum State {
        case loading
        case loaded
        case failed(String)
    }

    let source: MoviesListSource
    private let searchMoviesUseCase: any SearchMoviesUseCase
    private let fetchMoviesUseCase: any FetchMoviesUseCase

    private(set) var state: State = .loading
    private(set) var category: MediaCategory = .movies
    private(set) var genres: [Genre] = []
    private(set) var selectedGenreId: Int?
    private(set) var recentQueries: [String] = []
    private(set) var submittedQuery = ""
    private(set) var isLoadingNextPage = false
    var query = ""
    var errorMessage: String?

    private var allItems: [MoviesListItemViewModel] = []
    private var currentPage = 0
    private var totalPages = 1

    var items: [MoviesListItemViewModel] {
        guard let selectedGenreId else { return allItems }
        return allItems.filter { $0.genreIds.contains(selectedGenreId) }
    }

    var title: String {
        switch source {
        case .search: "Movies"
        case .section(let section): section.title
        }
    }

    var isSearchable: Bool { source == .search }

    init(
        source: MoviesListSource,
        searchMoviesUseCase: any SearchMoviesUseCase,
        fetchMoviesUseCase: any FetchMoviesUseCase
    ) {
        self.source = source
        self.searchMoviesUseCase = searchMoviesUseCase
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }

    // MARK: - Loading

    func load() async {
        refreshRecentQueries()
        await loadGenres()
        await loadFirstPage()
    }

    func loadFirstPage() async {
        state = .loading
        currentPage = 0
        totalPages = 1

        do {
            let page = try await fetchPage(1)
            allItems = makeItems(from: page)
            currentPage = page.page
            totalPages = page.totalPages
            state = .loaded
        } catch {
            guard !error.isCancellation else { return }
            state = .failed(message(for: error, fallback: "Failed loading movies"))
        }
    }

    func loadNextPageIfNeeded(currentItem: MoviesListItemViewModel) async {
        guard currentItem.id == allItems.last?.id,
              currentPage < totalPages,
              !isLoadingNextPage else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let page = try await fetchPage(currentPage + 1)
            let existingIds = Set(allItems.map(\.id))
            allItems += makeItems(from: page).filter { !existingIds.contains($0.id) }
            currentPage = page.page
            totalPages = page.totalPages
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed loading more movies")
        }
    }

    // MARK: - Search

    func search() async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isSearchable, !trimmedQuery.isEmpty else { return }

        submittedQuery = trimmedQuery
        selectedGenreId = nil
        await loadFirstPage()
        refreshRecentQueries()
    }

    func cancelSearch() async {
        guard isSearchable, !submittedQuery.isEmpty else { return }

        submittedQuery = ""
        selectedGenreId = nil
        await loadFirstPage()
    }

    // MARK: - Filters

    func selectCategory(_ newCategory: MediaCategory) async {
        guard newCategory != category else { return }

        category = newCategory
        selectedGenreId = nil
        genres = []
        await loadGenres()
        await loadFirstPage()
    }

    func selectGenre(_ genreId: Int?) {
        selectedGenreId = genreId
    }

    // MARK: - Helpers

    private func fetchPage(_ page: Int) async throws -> MoviesPage {
        switch source {
        case .search where !submittedQuery.isEmpty:
            return try await searchMoviesUseCase.execute(
                query: submittedQuery,
                category: category,
                page: page
            )

        case .search:
            return try await fetchMoviesUseCase.execute(
                section: .popular,
                category: category,
                page: page
            )

        case .section(let section):
            return try await fetchMoviesUseCase.execute(
                section: section,
                category: category,
                page: page
            )
        }
    }

    private func loadGenres() async {
        do {
            genres = try await searchMoviesUseCase.fetchGenres(category: category)
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed loading genres")
        }
    }

    private func refreshRecentQueries() {
        guard isSearchable else { return }
        recentQueries = searchMoviesUseCase.fetchRecentQueries()
    }

    private func makeItems(from page: MoviesPage) -> [MoviesListItemViewModel] {
        page.movies.map { MoviesListItemViewModel(movie: $0, category: category) }
    }

    private func message(for error: Error, fallback: String) -> String {
        error.isInternetConnectionError ? "No internet connection" : fallback
    }
}

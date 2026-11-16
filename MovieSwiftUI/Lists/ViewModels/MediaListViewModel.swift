//
//  MediaListViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

enum MediaListSource: Hashable {
    case list(MovieList)
    case favorites
    case watchlist
}

@MainActor
@Observable
final class MediaListViewModel {

    enum State {
        case loading
        case loaded
        case failed(String)
    }

    let source: MediaListSource
    private let sessionId: String
    private let fetchListDetailsUseCase: any FetchListDetailsUseCase
    private let listMoviesUseCase: any ListMoviesUseCase
    private let movieUserStateUseCase: any MovieUserStateUseCase

    private(set) var state: State = .loading
    private(set) var movies: [MovieCardItemViewModel] = []
    private(set) var isLoadingNextPage = false
    private(set) var isDeleting = false
    var errorMessage: String?
    var toastMessage: String?

    private var currentPage = 0
    private var totalPages = 1

    var title: String {
        switch source {
        case .list(let list): list.name
        case .favorites: "Favorites"
        case .watchlist: "Watchlist"
        }
    }

    var itemCount: Int { movies.count }

    init(
        source: MediaListSource,
        sessionId: String,
        fetchListDetailsUseCase: any FetchListDetailsUseCase,
        listMoviesUseCase: any ListMoviesUseCase,
        movieUserStateUseCase: any MovieUserStateUseCase
    ) {
        self.source = source
        self.sessionId = sessionId
        self.fetchListDetailsUseCase = fetchListDetailsUseCase
        self.listMoviesUseCase = listMoviesUseCase
        self.movieUserStateUseCase = movieUserStateUseCase
    }

    // MARK: - Loading

    func loadFirstPage() async {
        state = .loading
        currentPage = 0
        totalPages = 1

        do {
            let page = try await fetchPage(1)
            movies = page.movies.map(MovieCardItemViewModel.init(movie:))
            currentPage = page.page
            totalPages = page.totalPages
            state = .loaded
        } catch {
            guard !error.isCancellation else { return }
            state = .failed(message(for: error, fallback: "Failed loading movies"))
        }
    }

    func loadNextPageIfNeeded(currentMovie: MovieCardItemViewModel) async {
        guard currentMovie.id == movies.last?.id,
              currentPage < totalPages,
              !isLoadingNextPage else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let page = try await fetchPage(currentPage + 1)
            movies.append(contentsOf: page.movies.map(MovieCardItemViewModel.init(movie:)))
            currentPage = page.page
            totalPages = page.totalPages
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed loading more movies")
        }
    }

    // MARK: - Delete

    func deleteMovies(withIds movieIds: Set<Int>) async {
        guard !movieIds.isEmpty, !isDeleting else { return }
        isDeleting = true
        defer { isDeleting = false }

        var deletedIds = Set<Int>()
        for movieId in movieIds {
            do {
                try await removeMovie(movieId)
                deletedIds.insert(movieId)
            } catch {
                errorMessage = message(for: error, fallback: "Failed deleting some movies")
            }
        }

        movies.removeAll { deletedIds.contains($0.id) }

        if !deletedIds.isEmpty {
            let count = deletedIds.count
            toastMessage = "\(count) \(count == 1 ? "movie" : "movies") removed"
        }
    }

    // MARK: - Helpers

    private func fetchPage(_ page: Int) async throws -> MoviesPage {
        switch source {
        case .list(let list):
            let details = try await fetchListDetailsUseCase.execute(listId: list.id)
            return MoviesPage(page: 1, totalPages: 1, movies: details.items)

        case .favorites:
            return try await movieUserStateUseCase.fetchFavoriteMovies(sessionId: sessionId, page: page)

        case .watchlist:
            return try await movieUserStateUseCase.fetchWatchlistMovies(sessionId: sessionId, page: page)
        }
    }

    private func removeMovie(_ movieId: Int) async throws {
        switch source {
        case .list(let list):
            try await listMoviesUseCase.removeMovie(movieId, fromList: list.id, sessionId: sessionId)

        case .favorites:
            try await movieUserStateUseCase.updateFavorite(movieId: movieId, favorite: false, sessionId: sessionId)

        case .watchlist:
            try await movieUserStateUseCase.updateWatchlist(movieId: movieId, watchlist: false, sessionId: sessionId)
        }
    }

    private func message(for error: Error, fallback: String) -> String {
        error.isInternetConnectionError ? "No internet connection" : fallback
    }
}

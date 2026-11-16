//
//  MovieDetailsViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailsViewModel {

    enum State {
        case loading
        case loaded(MovieSummary)
        case failed(String)
    }

    let movieId: Int
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let movieUserStateUseCase: any MovieUserStateUseCase

    private(set) var state: State = .loading
    private(set) var isFavorite = false
    private(set) var isInWatchlist = false
    private(set) var isUpdatingFavorite = false
    private(set) var isUpdatingWatchlist = false
    var errorMessage: String?

    init(
        movieId: Int,
        fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase,
        movieUserStateUseCase: any MovieUserStateUseCase
    ) {
        self.movieId = movieId
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.movieUserStateUseCase = movieUserStateUseCase
    }

    // MARK: - Details

    func loadDetails() async {
        state = .loading

        do {
            let movie = try await fetchMovieDetailsUseCase.execute(movieId: movieId)
            state = .loaded(movie)
        } catch {
            guard !error.isCancellation else { return }
            state = .failed(message(for: error, fallback: "Failed loading movie details"))
        }
    }

    // MARK: - User State

    func loadUserState(sessionId: String) async {
        do {
            let userState = try await movieUserStateUseCase.fetchState(
                movieId: movieId,
                sessionId: sessionId
            )
            isFavorite = userState.isFavorite
            isInWatchlist = userState.isInWatchlist
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed loading your movie status")
        }
    }

    func toggleFavorite(sessionId: String) async {
        guard !isUpdatingFavorite else { return }
        isUpdatingFavorite = true
        defer { isUpdatingFavorite = false }

        let newValue = !isFavorite
        do {
            try await movieUserStateUseCase.updateFavorite(
                movieId: movieId,
                favorite: newValue,
                sessionId: sessionId
            )
            isFavorite = newValue
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed updating favorites")
        }
    }

    func toggleWatchlist(sessionId: String) async {
        guard !isUpdatingWatchlist else { return }
        isUpdatingWatchlist = true
        defer { isUpdatingWatchlist = false }

        let newValue = !isInWatchlist
        do {
            try await movieUserStateUseCase.updateWatchlist(
                movieId: movieId,
                watchlist: newValue,
                sessionId: sessionId
            )
            isInWatchlist = newValue
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = message(for: error, fallback: "Failed updating watchlist")
        }
    }

    // MARK: - Error Handling

    private func message(for error: Error, fallback: String) -> String {
        error.isInternetConnectionError ? "No internet connection" : fallback
    }
}

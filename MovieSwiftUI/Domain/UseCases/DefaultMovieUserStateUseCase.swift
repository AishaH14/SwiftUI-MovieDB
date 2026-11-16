//
//  DefaultMovieUserStateUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultMovieUserStateUseCase: MovieUserStateUseCase {

    private let accountRepository: any AccountRepository

    init(accountRepository: any AccountRepository) {
        self.accountRepository = accountRepository
    }

    func fetchState(movieId: Int, sessionId: String) async throws -> MovieUserState {
        try await accountRepository.fetchMovieUserState(
            movieId: movieId,
            sessionId: sessionId
        )
    }

    func updateFavorite(movieId: Int, favorite: Bool, sessionId: String) async throws {
        let account = try await accountRepository.fetchAccount(sessionId: sessionId)
        try await accountRepository.updateFavorite(
            accountId: account.id,
            sessionId: sessionId,
            movieId: movieId,
            favorite: favorite
        )
    }

    func updateWatchlist(movieId: Int, watchlist: Bool, sessionId: String) async throws {
        let account = try await accountRepository.fetchAccount(sessionId: sessionId)
        try await accountRepository.updateWatchlist(
            accountId: account.id,
            sessionId: sessionId,
            movieId: movieId,
            watchlist: watchlist
        )
    }
    
    func fetchFavoriteMovies(sessionId: String, page: Int) async throws -> MoviesPage {
        let account = try await accountRepository.fetchAccount(sessionId: sessionId)
        return try await accountRepository.fetchFavoriteMovies(
            accountId: account.id,
            sessionId: sessionId,
            page: page
        )
    }

    func fetchWatchlistMovies(sessionId: String, page: Int) async throws -> MoviesPage {
        let account = try await accountRepository.fetchAccount(sessionId: sessionId)
        return try await accountRepository.fetchWatchlistMovies(
            accountId: account.id,
            sessionId: sessionId,
            page: page
        )
    }
}

//
//  DefaultAccountRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultAccountRepository: AccountRepository {

    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchAccount(sessionId: String) async throws -> Account {
        let response = try await networkClient.request(
            AccountEndpoints.details(sessionId: sessionId)
        )
        return response.toDomain()
    }

    func fetchMovieUserState(
        movieId: Int,
        sessionId: String
    ) async throws -> MovieUserState {
        let response = try await networkClient.request(
            MovieEndpoints.accountStates(movieId: movieId, sessionId: sessionId)
        )
        return response.toDomain()
    }

    func updateFavorite(
        accountId: Int,
        sessionId: String,
        movieId: Int,
        favorite: Bool
    ) async throws {
        _ = try await networkClient.request(
            AccountEndpoints.updateFavorite(
                accountId: accountId,
                sessionId: sessionId,
                request: UpdateFavoriteRequestDTO(mediaId: movieId, favorite: favorite)
            )
        )
    }

    func updateWatchlist(
        accountId: Int,
        sessionId: String,
        movieId: Int,
        watchlist: Bool
    ) async throws {
        _ = try await networkClient.request(
            AccountEndpoints.updateWatchlist(
                accountId: accountId,
                sessionId: sessionId,
                request: UpdateWatchlistRequestDTO(mediaId: movieId, watchlist: watchlist)
            )
        )
    }

    func fetchFavoriteMovies(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MoviesPage {
        let response = try await networkClient.request(
            AccountEndpoints.favoriteMovies(accountId: accountId, sessionId: sessionId, page: page)
        )
        return response.toDomain()
    }

    func fetchWatchlistMovies(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MoviesPage {
        let response = try await networkClient.request(
            AccountEndpoints.watchlistMovies(accountId: accountId, sessionId: sessionId, page: page)
        )
        return response.toDomain()
    }
}

//
//  AccountRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol AccountRepository {
    func fetchAccount(sessionId: String) async throws -> Account

    func fetchMovieUserState(
        movieId: Int,
        sessionId: String
    ) async throws -> MovieUserState

    func updateFavorite(
        accountId: Int,
        sessionId: String,
        movieId: Int,
        favorite: Bool
    ) async throws

    func updateWatchlist(
        accountId: Int,
        sessionId: String,
        movieId: Int,
        watchlist: Bool
    ) async throws

    func fetchFavoriteMovies(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MoviesPage

    func fetchWatchlistMovies(
        accountId: Int,
        sessionId: String,
        page: Int
    ) async throws -> MoviesPage
}

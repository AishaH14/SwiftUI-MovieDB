//
//  MovieUserStateUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol MovieUserStateUseCase {
    func fetchState(movieId: Int, sessionId: String) async throws -> MovieUserState
    func updateFavorite(movieId: Int, favorite: Bool, sessionId: String) async throws
    func updateWatchlist(movieId: Int, watchlist: Bool, sessionId: String) async throws
    func fetchFavoriteMovies(sessionId: String, page: Int) async throws -> MoviesPage
    func fetchWatchlistMovies(sessionId: String, page: Int) async throws -> MoviesPage
}

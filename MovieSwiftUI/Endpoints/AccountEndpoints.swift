//
//  AccountEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum AccountEndpoints {

    private enum Path {
        static let account = "account"

        static func favorite(_ accountId: Int) -> String {
            "\(account)/\(accountId)/favorite"
        }

        static func watchlist(_ accountId: Int) -> String {
            "\(account)/\(accountId)/watchlist"
        }

        static func favoriteMovies(_ accountId: Int) -> String {
            "\(favorite(accountId))/movies"
        }

        static func watchlistMovies(_ accountId: Int) -> String {
            "\(watchlist(accountId))/movies"
        }
    }

    // MARK: - Endpoints

    static func details(sessionId: String) -> APIEndpoint<AccountResponseDTO> {
        APIEndpoint(
            path: Path.account,
            queryItems: [.sessionId(sessionId)]
        )
    }

    static func favoriteMovies(
        accountId: Int,
        sessionId: String,
        page: Int = 1
    ) -> APIEndpoint<MovieResponseDTO> {
        APIEndpoint(
            path: Path.favoriteMovies(accountId),
            queryItems: [.sessionId(sessionId), .page(page)]
        )
    }

    static func watchlistMovies(
        accountId: Int,
        sessionId: String,
        page: Int = 1
    ) -> APIEndpoint<MovieResponseDTO> {
        APIEndpoint(
            path: Path.watchlistMovies(accountId),
            queryItems: [.sessionId(sessionId), .page(page)]
        )
    }

    static func updateFavorite(
        accountId: Int,
        sessionId: String,
        request: UpdateFavoriteRequestDTO
    ) -> APIEndpoint<StatusResponseDTO> {
        APIEndpoint(
            path: Path.favorite(accountId),
            method: .post,
            queryItems: [.sessionId(sessionId)],
            body: request
        )
    }

    static func updateWatchlist(
        accountId: Int,
        sessionId: String,
        request: UpdateWatchlistRequestDTO
    ) -> APIEndpoint<StatusResponseDTO> {
        APIEndpoint(
            path: Path.watchlist(accountId),
            method: .post,
            queryItems: [.sessionId(sessionId)],
            body: request
        )
    }
}

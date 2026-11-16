//
//  MovieEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum MovieEndpoints {

    private enum Path {
        static let movie = "movie"
        static let tv = "tv"

        static func mediaType(_ category: MediaCategory) -> String {
            category == .movies ? movie : tv
        }

        static func section(_ section: MovieSection, category: MediaCategory) -> String {
            switch (section, category) {
            case (.nowPlaying, .movies): "\(movie)/now_playing"
            case (.nowPlaying, .tvShows): "\(tv)/airing_today"
            case (.popular, _): "\(mediaType(category))/popular"
            case (.topRated, _): "\(mediaType(category))/top_rated"
            case (.upcoming, .movies): "\(movie)/upcoming"
            case (.upcoming, .tvShows): "\(tv)/on_the_air"
            }
        }

        static func details(_ movieId: Int) -> String {
            "\(movie)/\(movieId)"
        }

        static func accountStates(_ movieId: Int) -> String {
            "\(details(movieId))/account_states"
        }

        static func search(_ category: MediaCategory) -> String {
            "search/\(mediaType(category))"
        }

        static func genres(_ category: MediaCategory) -> String {
            "genre/\(mediaType(category))/list"
        }
    }

    // MARK: - Endpoints

    static func section(
        _ section: MovieSection,
        category: MediaCategory = .movies,
        page: Int = 1
    ) -> APIEndpoint<MovieResponseDTO> {
        APIEndpoint(
            path: Path.section(section, category: category),
            queryItems: [.page(page)]
        )
    }

    static func search(
        query: String,
        category: MediaCategory,
        page: Int = 1
    ) -> APIEndpoint<MovieResponseDTO> {
        APIEndpoint(
            path: Path.search(category),
            queryItems: [.query(query), .page(page)]
        )
    }

    static func genres(category: MediaCategory) -> APIEndpoint<GenresResponseDTO> {
        APIEndpoint(path: Path.genres(category))
    }

    static func details(movieId: Int) -> APIEndpoint<MovieDTO> {
        APIEndpoint(path: Path.details(movieId))
    }

    static func accountStates(
        movieId: Int,
        sessionId: String
    ) -> APIEndpoint<AccountStatesResponseDTO> {
        APIEndpoint(
            path: Path.accountStates(movieId),
            queryItems: [.sessionId(sessionId)]
        )
    }
}

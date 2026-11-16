//
//  MovieEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum MovieEndpoints {
    static func nowPlaying(page: Int = 1) -> APIEndpoint<MovieResponseDTO> {
        movies(path: "movie/now_playing", page: page)
    }

    static func popular(page: Int = 1) -> APIEndpoint<MovieResponseDTO> {
        movies(path: "movie/popular", page: page)
    }

    static func topRated(page: Int = 1) -> APIEndpoint<MovieResponseDTO> {
        movies(path: "movie/top_rated", page: page)
    }

    static func upcoming(page: Int = 1) -> APIEndpoint<MovieResponseDTO> {
        movies(path: "movie/upcoming", page: page)
    }
    
    static func details(movieId: Int) -> APIEndpoint<MovieDTO> {
        APIEndpoint(path: "movie/\(movieId)")
    }
    static func accountStates(
        movieId: Int,
        sessionId: String
    ) -> APIEndpoint<AccountStatesResponseDTO> {
        APIEndpoint(
            path: "movie/\(movieId)/account_states",
            queryItems: [.sessionId(sessionId)]
        )
    }
    
    private static func movies(
        path: String,
        page: Int
    ) -> APIEndpoint<MovieResponseDTO> {
        APIEndpoint(
            path: path,
            queryItems: [.page(page)]
        )
    }
}

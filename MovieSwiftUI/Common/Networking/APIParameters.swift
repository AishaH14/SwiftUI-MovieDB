//
//  APIParameters.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum APIParameters {
    static let apiKey = "api_key"
    static let sessionId = "session_id"
    static let page = "page"
    static let movieId = "movie_id"
    static let query = "query"
    static let language = "language"
}

extension URLQueryItem {

    static func sessionId(_ sessionId: String) -> URLQueryItem {
        URLQueryItem(name: APIParameters.sessionId, value: sessionId)
    }

    static func page(_ page: Int) -> URLQueryItem {
        URLQueryItem(name: APIParameters.page, value: String(page))
    }

    static func movieId(_ movieId: Int) -> URLQueryItem {
        URLQueryItem(name: APIParameters.movieId, value: String(movieId))
    }

    static func query(_ query: String) -> URLQueryItem {
        URLQueryItem(name: APIParameters.query, value: query)
    }
}

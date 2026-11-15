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
}

extension URLQueryItem {

    static func sessionId(_ sessionId: String) -> URLQueryItem {
        URLQueryItem(name: APIParameters.sessionId, value: sessionId)
    }

    static func page(_ page: Int) -> URLQueryItem {
        URLQueryItem(name: APIParameters.page, value: String(page))
    }
}

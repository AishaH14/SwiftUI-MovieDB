//
//  AuthConfiguration.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct AuthConfiguration: Sendable {
    let callbackScheme: String
    let callbackHost: String
    let authorizationBaseURL: URL

    static let live = AuthConfiguration(
        callbackScheme: "movieswiftui",
        callbackHost: "auth",
        authorizationBaseURL: URL(string: "https://www.themoviedb.org/authenticate")!
    )

    func authorizationURL(for token: String) throws -> URL {
        var components = URLComponents(
            url: authorizationBaseURL.appendingPathComponent(token),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(name: "redirect_to", value: "\(callbackScheme)://\(callbackHost)")
        ]
        guard let url = components?.url else {
            throw AuthConfigurationError.invalidAuthorizationURL
        }
        return url
    }

    func isValidCallback(_ url: URL) -> Bool {
        url.scheme == callbackScheme && url.host == callbackHost
    }
}

enum AuthConfigurationError: LocalizedError {
    case invalidAuthorizationURL
    case invalidCallback

    var errorDescription: String? {
        switch self {
        case .invalidAuthorizationURL:
            "Couldn't open the sign in page."
        case .invalidCallback:
            "Authentication failed. Please try again."
        }
    }
}

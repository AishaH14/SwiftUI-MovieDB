//
//  WebAuthenticationSession+TMDB.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI
import AuthenticationServices

extension WebAuthenticationSession {

    func authenticateWithTMDB(url: URL, callbackScheme: String) async throws -> URL {
        do {
            return try await authenticate(
                using: url,
                callbackURLScheme: callbackScheme
            )
        } catch let error as ASWebAuthenticationSessionError
                    where error.code == .canceledLogin {
            throw CancellationError()
        }
    }
}

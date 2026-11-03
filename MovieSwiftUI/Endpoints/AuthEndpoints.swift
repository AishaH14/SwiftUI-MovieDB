//
//  AuthEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum AuthEndpoints {

    private struct CreateSessionBody: Encodable {
        let requestToken: String
    }

    static func requestToken() -> APIEndpoint<RequestTokenResponseDTO> {
        APIEndpoint(path: "authentication/token/new")
    }

    static func createSession(
        requestToken: String
    ) -> APIEndpoint<CreateSessionResponseDTO> {
        APIEndpoint(
            path: "authentication/session/new",
            method: .post,
            body: CreateSessionBody(requestToken: requestToken)
        )
    }

    static func guestSession() -> APIEndpoint<GuestSessionResponseDTO> {
        APIEndpoint(path: "authentication/guest_session/new")
    }
}

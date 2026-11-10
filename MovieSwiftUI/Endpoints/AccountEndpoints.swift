//
//  AccountEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum AccountEndpoints {

    static func details(sessionId: String) -> APIEndpoint<AccountResponseDTO> {
        APIEndpoint(
            path: "account",
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionId)
            ]
        )
    }
}

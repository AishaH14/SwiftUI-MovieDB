//
//  ListEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum ListEndpoints {
    static func createList(
        sessionId: String,
        request: CreateListRequestDTO
    ) -> APIEndpoint<CreateListResponseDTO> {
        APIEndpoint(
            path: "list",
            method: .post,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionId)
            ],
            body: request
        )
    }
    static func accountLists(
        accountId: Int,
        sessionId: String,
        page: Int = 1
    ) -> APIEndpoint<ListsResponseDTO> {
        APIEndpoint(
            path: "account/\(accountId)/lists",
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionId),
                URLQueryItem(name: "page", value: String(page))
            ]
        )
    }
    static func deleteList(
        listId: Int,
        sessionId: String
    ) -> APIEndpoint<ListActionResponseDTO> {
        APIEndpoint(
            path: "list/\(listId)",
            method: .delete,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionId)
            ]
        )
    }
}

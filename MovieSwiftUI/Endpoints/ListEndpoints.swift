//
//  ListEndpoints.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum ListEndpoints {

    private enum Path {
        static let list = "list"

        static func list(_ listId: Int) -> String {
            "list/\(listId)"
        }

        static func accountLists(_ accountId: Int) -> String {
            "account/\(accountId)/lists"
        }
    }

    // MARK: - Endpoints

    static func accountLists(
        accountId: Int,
        sessionId: String,
        page: Int = 1
    ) -> APIEndpoint<ListsResponseDTO> {
        APIEndpoint(
            path: Path.accountLists(accountId),
            queryItems: [.sessionId(sessionId), .page(page)]
        )
    }

    static func createList(
        sessionId: String,
        request: CreateListRequestDTO
    ) -> APIEndpoint<CreateListResponseDTO> {
        APIEndpoint(
            path: Path.list,
            method: .post,
            queryItems: [.sessionId(sessionId)],
            body: request
        )
    }

    static func deleteList(
        listId: Int,
        sessionId: String
    ) -> APIEndpoint<ListActionResponseDTO> {
        APIEndpoint(
            path: Path.list(listId),
            method: .delete,
            queryItems: [.sessionId(sessionId)]
        )
    }
    
    static func listDetails(
        listId: Int
    ) -> APIEndpoint<ListDetailsResponseDTO> {
        APIEndpoint(path:
        Path.list(listId))
    }
}

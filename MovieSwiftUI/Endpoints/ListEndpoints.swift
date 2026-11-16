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

        static func listDetails(_ listId: Int) -> String {
            "\(list)/\(listId)"
        }

        static func accountLists(_ accountId: Int) -> String {
            "account/\(accountId)/lists"
        }

        static func addListItem(_ listId: Int) -> String {
            "\(listDetails(listId))/add_item"
        }

        static func removeListItem(_ listId: Int) -> String {
            "\(listDetails(listId))/remove_item"
        }

        static func itemStatus(_ listId: Int) -> String {
            "\(listDetails(listId))/item_status"
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
    ) -> APIEndpoint<StatusResponseDTO> {
        APIEndpoint(
            path: Path.listDetails(listId),
            method: .delete,
            queryItems: [.sessionId(sessionId)]
        )
    }
    
    static func listDetails(
        listId: Int
    ) -> APIEndpoint<ListDetailsResponseDTO> {
        APIEndpoint(path: Path.listDetails(listId))
    }
    
    static func addMovieToList(
        listId: Int,
        sessionId: String,
        request: ListItemRequestDTO
    ) -> APIEndpoint<StatusResponseDTO> {
        APIEndpoint(
            path: Path.addListItem(listId),
            method: .post,
            queryItems: [.sessionId(sessionId)],
            body: request
        )
    }

    static func removeMovieFromList(
        listId: Int,
        sessionId: String,
        request: ListItemRequestDTO
    ) -> APIEndpoint<StatusResponseDTO> {
        APIEndpoint(
            path: Path.removeListItem(listId),
            method: .post,
            queryItems: [.sessionId(sessionId)],
            body: request
        )
    }

    static func itemStatus(
        listId: Int,
        movieId: Int
    ) -> APIEndpoint<ItemStatusResponseDTO> {
        APIEndpoint(
            path: Path.itemStatus(listId),
            queryItems: [.movieId(movieId)]
        )
    }
}

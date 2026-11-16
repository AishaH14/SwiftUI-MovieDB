//
//  DefaultListMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultListMoviesUseCase: ListMoviesUseCase {

    private let listRepository: any ListRepository

    init(listRepository: any ListRepository) {
        self.listRepository = listRepository
    }

    func addMovie(_ movieId: Int, toList listId: Int, sessionId: String) async throws {
        try await listRepository.addMovieToList(
            listId: listId,
            sessionId: sessionId,
            movieId: movieId
        )
    }

    func removeMovie(_ movieId: Int, fromList listId: Int, sessionId: String) async throws {
        try await listRepository.removeMovieFromList(
            listId: listId,
            sessionId: sessionId,
            movieId: movieId
        )
    }

    func isMovie(_ movieId: Int, inList listId: Int) async throws -> Bool {
        try await listRepository.isMovieInList(
            listId: listId,
            movieId: movieId
        )
    }
}

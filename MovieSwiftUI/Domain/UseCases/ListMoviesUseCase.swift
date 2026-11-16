//
//  ListMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol ListMoviesUseCase {
    func addMovie(_ movieId: Int, toList listId: Int, sessionId: String) async throws
    func removeMovie(_ movieId: Int, fromList listId: Int, sessionId: String) async throws
    func isMovie(_ movieId: Int, inList listId: Int) async throws -> Bool
}

//
//  MovieRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol MovieRepository {
    func fetchMovies(
        section: MovieSection,
        category: MediaCategory,
        page: Int
    ) async throws -> MoviesPage

    func fetchMovieDetails(movieId: Int) async throws -> MovieSummary

    func searchMovies(
        query: String,
        category: MediaCategory,
        page: Int
    ) async throws -> MoviesPage

    func fetchGenres(category: MediaCategory) async throws -> [Genre]
}

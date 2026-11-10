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
        page: Int
    ) async throws -> MoviesPage
    func fetchMovieDetails(movieId: Int) async throws -> MovieSummary
}

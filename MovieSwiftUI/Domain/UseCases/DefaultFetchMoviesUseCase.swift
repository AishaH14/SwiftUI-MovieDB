//
//  DefaultFetchMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultFetchMoviesUseCase: FetchMoviesUseCase {

    private let movieRepository: any MovieRepository

    init(movieRepository: any MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute(
        section: MovieSection,
        page: Int
    ) async throws -> MoviesPage {
        try await movieRepository.fetchMovies(
            section: section,
            page: page
        )
    }
}

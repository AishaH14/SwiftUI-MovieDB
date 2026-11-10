//
//  DefaultFetchMovieDetailsUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    private let movieRepository: any MovieRepository

    init(movieRepository: any MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute(movieId: Int) async throws -> MovieSummary {
        try await movieRepository.fetchMovieDetails(movieId: movieId)
    }
}

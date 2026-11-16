//
//  DefaultSearchMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let movieRepository: any MovieRepository
    private let moviesQueriesRepository: any MoviesQueriesRepository
    private let maxRecentQueries = 10

    init(
        movieRepository: any MovieRepository,
        moviesQueriesRepository: any MoviesQueriesRepository
    ) {
        self.movieRepository = movieRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }

    func execute(query: String, category: MediaCategory, page: Int) async throws -> MoviesPage {
        let moviesPage = try await movieRepository.searchMovies(
            query: query,
            category: category,
            page: page
        )

        if page == 1 {
            moviesQueriesRepository.saveRecentQuery(query)
        }
        return moviesPage
    }

    func fetchRecentQueries() -> [String] {
        moviesQueriesRepository.fetchRecentQueries(maxCount: maxRecentQueries)
    }

    func fetchGenres(category: MediaCategory) async throws -> [Genre] {
        try await movieRepository.fetchGenres(category: category)
    }
}

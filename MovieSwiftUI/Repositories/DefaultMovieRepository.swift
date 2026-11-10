//
//  DefaultMovieRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultMovieRepository: MovieRepository {

    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchMovies(
        section: MovieSection,
        page: Int
    ) async throws -> MoviesPage {

        let response = try await networkClient.request(
            endpoint(for: section, page: page)
        )

        return MoviesPage(
            page: response.page,
            totalPages: response.totalPages,
            movies: response.results.map(makeMovie)
        )
    }
    func fetchMovieDetails(movieId: Int) async throws -> MovieSummary {
        let response = try await networkClient.request(
            MovieEndpoints.details(movieId: movieId)
        )

        return makeMovie(from: response)
    }
    // MARK: - Helpers

    private func endpoint(
        for section: MovieSection,
        page: Int
    ) -> APIEndpoint<MovieResponseDTO> {
        switch section {
        case .nowPlaying:
            MovieEndpoints.nowPlaying(page: page)
        case .popular:
            MovieEndpoints.popular(page: page)
        case .topRated:
            MovieEndpoints.topRated(page: page)
        case .upcoming:
            MovieEndpoints.upcoming(page: page)
        }
    }

    private func makeMovie(from dto: MovieDTO) -> MovieSummary {
        MovieSummary(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            rating: dto.voteAverage
        )
    }
}

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
        category: MediaCategory,
        page: Int
    ) async throws -> MoviesPage {
        let response = try await networkClient.request(
            MovieEndpoints.section(section, category: category, page: page)
        )
        return response.toDomain()
    }

    func fetchMovieDetails(movieId: Int) async throws -> MovieSummary {
        let response = try await networkClient.request(
            MovieEndpoints.details(movieId: movieId)
        )
        return response.toDomain()
    }

    func searchMovies(
        query: String,
        category: MediaCategory,
        page: Int
    ) async throws -> MoviesPage {
        let response = try await networkClient.request(
            MovieEndpoints.search(query: query, category: category, page: page)
        )
        return response.toDomain()
    }

    func fetchGenres(category: MediaCategory) async throws -> [Genre] {
        let response = try await networkClient.request(
            MovieEndpoints.genres(category: category)
        )
        return response.toDomain()
    }
}

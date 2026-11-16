//
//  MovieResponseDTO+Mapping.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct MovieResponseDTO: Decodable {
    let page: Int
    let totalPages: Int
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let firstAirDate: String?
    let genreIds: [Int]?
}

// MARK: - Mappings to Domain

extension MovieResponseDTO {
    func toDomain() -> MoviesPage {
        MoviesPage(
            page: page,
            totalPages: totalPages,
            movies: results.map { $0.toDomain() }
        )
    }
}

extension MovieDTO {
    func toDomain() -> MovieSummary {
        MovieSummary(
            id: id,
            title: title ?? name ?? "",
            overview: overview ?? "",
            posterPath: posterPath,
            backdropPath: backdropPath,
            rating: voteAverage ?? 0,
            releaseDate: releaseDate ?? firstAirDate,
            genreIds: genreIds ?? []
        )
    }
}

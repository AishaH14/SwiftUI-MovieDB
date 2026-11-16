//
//  GenresResponseDTO+Mapping.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct GenresResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

// MARK: - Mappings to Domain

extension GenresResponseDTO {
    func toDomain() -> [Genre] {
        genres.map { $0.toDomain() }
    }
}

extension GenreDTO {
    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}

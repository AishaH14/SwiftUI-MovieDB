//
//  MovieSummary.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation

struct MovieSummary: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: Double
}

struct MoviesPage: Sendable {
    let page: Int
    let totalPages: Int
    let movies: [MovieSummary]
}
